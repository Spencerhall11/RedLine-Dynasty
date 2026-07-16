"""
Convert Natural Earth and Resolve Ecoregions shapefiles into CSVs matching geography.ml types.
Can be executed from ANY folder (handles relative pathing automatically).
"""

import os
from pathlib import Path
import geopandas as gpd
import h3
import pandas as pd
from shapely.geometry import Point

# --- Configuration ---
RES = 3

# Safely resolve absolute directories so it runs whether you're in root or map_data
SCRIPT_DIR = Path(__file__).resolve().parent
DATA_DIR = SCRIPT_DIR
OUTPUT_DIR = SCRIPT_DIR / "processed"

print(f"Executing map builder pipeline...")
print(f"Data directory: {DATA_DIR}")
print(f"Output directory: {OUTPUT_DIR}\n")

# --- 1. Load Datasets Safely ---
try:
    countries = gpd.read_file(DATA_DIR / "ne_50m_admin_0_countries/ne_50m_admin_0_countries.shp")
    provinces_raw = gpd.read_file(DATA_DIR / "ne_50m_admin_1_states_provinces/ne_50m_admin_1_states_provinces.shp")
    places = gpd.read_file(DATA_DIR / "ne_50m_populated_places/ne_50m_populated_places.shp")
except Exception as e:
    print(f"CRITICAL ERROR: Could not load initial Natural Earth datasets: {e}")
    print("Verify that Natural Earth folders exist directly under the same directory as build_map.py.")
    exit(1)

print(f"Loaded {len(countries)} countries, {len(provinces_raw)} provinces, {len(places)} places")

# --- 2. Nations Table ---
nations = countries[["ISO_A2", "SOVEREIGNT", "geometry"]].copy()
nations = nations.rename(columns={"ISO_A2": "nation_id", "SOVEREIGNT": "nation_name"})
nations = nations[nations["nation_id"] != "-99"]  # Remove disputed/unresolved IDs

# --- 3. Provinces & Fallback Configuration ---
provinces_from_admin1 = provinces_raw[["adm1_code", "name", "iso_a2", "geometry"]].copy()
provinces_from_admin1 = provinces_from_admin1.rename(
    columns={"adm1_code": "province_id", "name": "province_name", "iso_a2": "nation_id"}
)

# Area calculation using Equal Area Projection
provinces_from_admin1_proj = provinces_from_admin1.set_geometry(provinces_raw.geometry).to_crs("ESRI:54009")
provinces_from_admin1["area_sq_km"] = provinces_from_admin1_proj.geometry.area / 1_000_000
 
subdivided_nation_ids = set(provinces_from_admin1["nation_id"].unique())
unsubdivided = nations[~nations["nation_id"].isin(subdivided_nation_ids)].copy()
unsubdivided["province_id"] = "WHOLE_" + unsubdivided["nation_id"]
unsubdivided["province_name"] = unsubdivided["nation_name"]

unsubdivided_proj = unsubdivided.to_crs("ESRI:54009")
unsubdivided["area_sq_km"] = unsubdivided_proj.geometry.area / 1_000_000
unsubdivided = unsubdivided[["province_id", "province_name", "nation_id", "area_sq_km", "geometry"]]
 
provinces = pd.concat([provinces_from_admin1, unsubdivided], ignore_index=True)
provinces = gpd.GeoDataFrame(provinces, geometry="geometry", crs=provinces_raw.crs)
print(f"Provinces after fallback: {len(provinces)} "
      f"({len(provinces_from_admin1)} real admin-1 + {len(unsubdivided)} whole-country fallback)")

# --- 4. Province Adjacency ---
sindex = provinces.sindex
adjacency = {pid: [] for pid in provinces["province_id"]}
for idx, row in provinces.iterrows():
    candidate_idxs = list(sindex.intersection(row.geometry.bounds))
    for cand_idx in candidate_idxs:
        if cand_idx == idx:
            continue
        cand = provinces.iloc[cand_idx]
        if row.geometry.touches(cand.geometry):
            adjacency[row["province_id"]].append(cand["province_id"])
print("Adjacency computed")

# --- 5. Global H3 Tile Grid & Ocean Matrix ---
land_union = countries.union_all()
res0_cells = h3.get_res0_cells()
all_cells = set()
for c in res0_cells:
    all_cells |= set(h3.cell_to_children(c, RES))

centers = {c: h3.cell_to_latlng(c) for c in all_cells}
tile_points = gpd.GeoDataFrame(
    {"tile_id": list(centers.keys())},
    geometry=[Point(lng, lat) for lat, lng in centers.values()],
    crs=countries.crs,
)

# Split global tiles strictly by whether they fall inside the Natural Earth land mask
land_tiles = tile_points[tile_points.within(land_union)].copy()
ocean_tiles_set = all_cells - set(land_tiles["tile_id"])

ocean_tiles = pd.DataFrame({
    "tile_id": list(ocean_tiles_set),
    "province_id": "DEEP_OCEAN",
    "biome": "Ocean_Cell"
})
ocean_tiles["latitude"] = ocean_tiles["tile_id"].map(lambda c: h3.cell_to_latlng(c)[0])
ocean_tiles["longitude"] = ocean_tiles["tile_id"].map(lambda c: h3.cell_to_latlng(c)[1])

print(f"Grid split finalized: {len(land_tiles)} land cells, {len(ocean_tiles)} ocean cells.")

# --- 6. Assign Province (sjoin) ---
tiles_with_province = gpd.sjoin(
    land_tiles, provinces[["province_id", "geometry"]], how="left", predicate="within"
)

# --- 7. Load & Parse Ecoregions (Corrected path to Ecoregions2017.shp) ---
ecoregions_path = DATA_DIR / "Resolve_Ecoregions_4212368435134123772/Biomes_and_Ecoregions_2017.shp"
try:
    ecoregions = gpd.read_file(ecoregions_path)
except Exception as e:
    print(f"\nCRITICAL ERROR: Resolve Ecoregions file missing at:\n{ecoregions_path}\nError details: {e}")
    exit(1)

biome_mapping = {
    "Boreal Forests/Taiga": "Forest_Cell",
    "Temperate Broadleaf & Mixed Forests": "Forest_Cell",
    "Temperate Conifer Forests": "Forest_Cell",
    "Tropical & Subtropical Coniferous Forests": "Forest_Cell",
    "Tropical & Subtropical Dry Broadleaf Forests": "Forest_Cell",
    "Tropical & Subtropical Moist Broadleaf Forests": "Forest_Cell",
    "Mediterranean Forests, Woodlands & Scrub": "Forest_Cell",
    "Deserts & Xeric Shrublands": "Desert_Cell",
    "Flooded Grasslands & Savannas": "Plains_Cell",
    "Temperate Grasslands, Savannas & Shrublands": "Plains_Cell",
    "Tropical & Subtropical Grasslands, Savannas & Shrublands": "Plains_Cell",
    "Montane Grasslands & Shrublands": "Mountain_Cell",
    "Mangroves": "Coastal_Cell",
    "Tundra": "Ice_Cell",
    "N/A": "Rock_Ice",
}
ecoregions["game_biome"] = ecoregions["BIOME_NAME"].map(biome_mapping)
ecoregions_clean = ecoregions[ecoregions["game_biome"].notna()].copy()
print(f"{len(ecoregions)} total ecoregions -> {len(ecoregions_clean)} after dropping unmapped biomes")

# --- 8. Assign Biomes (Point-in-Polygon) ---
ecoregions_matched_crs = ecoregions_clean.to_crs(tiles_with_province.crs)

# Drop index_right safely to avoid KeyErrors if some runs don't include it
tiles_with_province_clean = tiles_with_province.drop(columns="index_right", errors="ignore")

tiles_with_biome = gpd.sjoin(
    tiles_with_province_clean, ecoregions_matched_crs[["game_biome", "geometry"]],
    how="left", predicate="within"
)
unmatched_biome = tiles_with_biome["game_biome"].isna().sum()
print(f"{unmatched_biome} tiles didn't fall inside any ecoregion (coastline rounding / N/A zones)")

# --- 9. Assign Industrial Overrides ---
try:
    urban = gpd.read_file(DATA_DIR / "ne_50m_urban_areas/ne_50m_urban_areas.shp")
    urban_matched_crs = urban.to_crs(tiles_with_biome.crs)
    tiles_with_biome_clean = tiles_with_biome.drop(columns="index_right", errors="ignore")
    tiles_with_urban = gpd.sjoin(
        tiles_with_biome_clean, urban_matched_crs[["geometry"]],
        how="left", predicate="within"
    )
    is_urban = tiles_with_urban["index_right"].notna()
    tiles_with_urban.loc[is_urban, "game_biome"] = "Industrial_Cell"
    print(f"{is_urban.sum()} tiles fall inside a real urban footprint -> Industrial_Cell (overriding natural biome)")
except Exception as e:
    print(f"Warning: ne_50m_urban_areas could not be processed. Skipping urban override. Detail: {e}")
    tiles_with_urban = tiles_with_biome

# --- 10. Process Output Tiles & Post-Processing Splits ---
tiles_out = tiles_with_urban[["tile_id", "province_id", "game_biome"]].copy()
tiles_out = tiles_out.rename(columns={"game_biome": "biome"})
tiles_out["latitude"] = tiles_out["tile_id"].map(lambda c: h3.cell_to_latlng(c)[0])
tiles_out["longitude"] = tiles_out["tile_id"].map(lambda c: h3.cell_to_latlng(c)[1])

# Filter out elements that don't belong to any administrative province (oceanic gaps)
tiles_out = tiles_out.dropna(subset=["province_id"])

# Split "Rock_Ice" by Latitudes
rock_ice_mask = tiles_out["biome"] == "Rock_Ice"
polar_rock_ice = rock_ice_mask & (
    (tiles_out["latitude"] >= 66.5) | (tiles_out["latitude"] <= -60)
)
alpine_rock_ice = rock_ice_mask & ~polar_rock_ice
tiles_out.loc[polar_rock_ice, "biome"] = "Glacial_Cell"
tiles_out.loc[alpine_rock_ice, "biome"] = "Mountain_Peak_Cell"
print(f"Rock-and-Ice split: {polar_rock_ice.sum()} polar -> Glacial_Cell, {alpine_rock_ice.sum()} alpine -> Mountain_Peak_Cell")

# Drop any remaining biome-less tiles (such as coastline boundaries that missed ecoregion zones)
still_missing = tiles_out["biome"].isna().sum()
print(f"{still_missing} tiles still biome-less (coastal mismatches) -> Dropping")
tiles_out = tiles_out.dropna(subset=["biome"])

print("\nBiome Composition:")
print(tiles_out["biome"].value_counts())

def classify_kind(row):
    if row["ADM0CAP"] == 1: return "Capital"
    elif row["POP_MAX"] >= 1_000_000: return "City"
    elif row["POP_MAX"] >= 50_000: return "Town"
    else: return "Village"
 
places_clean = places[["NAME", "POP_MAX", "ADM0CAP", "geometry"]].copy()
places_clean["kind"] = places_clean.apply(classify_kind, axis=1)
places_clean["center_id"] = "PLACE_" + places_clean.index.astype(str)

# Calculate theoretical H3 Cell matching coordinate
places_clean["tile_id"] = places_clean.geometry.apply(
    lambda pt: h3.latlng_to_cell(pt.y, pt.x, RES)
)

generated_land_tiles = set(tiles_out["tile_id"])
land_tile_gpd = tiles_out[["tile_id", "latitude", "longitude"]].copy()

# SNAP ROUTINE: Find nearest generated land hex for ports/coastal centers in ocean cells
def snap_to_nearest_land(row):
    if row["tile_id"] in generated_land_tiles:
        return row["tile_id"]
    
    # Calculate geometric distances to find the immediate closest valid hex
    pt = row["geometry"]
    distances = (land_tile_gpd["latitude"] - pt.y)**2 + (land_tile_gpd["longitude"] - pt.x)**2
    closest_idx = distances.idxmin()
    return land_tile_gpd.loc[closest_idx, "tile_id"]

print(f"Executing snapping routine for coastal population anomalies...")
places_clean["tile_id"] = places_clean.apply(snap_to_nearest_land, axis=1)

off_land_count = (~places_clean["tile_id"].isin(generated_land_tiles)).sum()
print(f"Remaining population center ocean mismatches after snap: {off_land_count}")
 
pop_centers_out = places_clean[["center_id", "NAME", "kind", "POP_MAX", "tile_id"]]
pop_centers_out = pop_centers_out.rename(columns={"NAME": "center_name", "POP_MAX": "population"})


# --- 12. Safe CSV Export (Appends the new Ocean rows) ---
os.makedirs(OUTPUT_DIR, exist_ok=True)

# Combine the processed land matrix row vectors with the global deep water array
final_tiles_matrix = pd.concat([tiles_out, ocean_tiles], ignore_index=True)
 
nations[["nation_id", "nation_name"]].to_csv(OUTPUT_DIR / "nations.csv", index=False)
provinces[["province_id", "province_name", "nation_id", "area_sq_km"]].to_csv(OUTPUT_DIR / "provinces.csv", index=False)
pd.DataFrame(
    [(pid, adj) for pid, adjs in adjacency.items() for adj in adjs],
    columns=["province_id", "adjacent_province_id"]
).to_csv(OUTPUT_DIR / "province_adjacency.csv", index=False)

# Export the unified global grid payload
final_tiles_matrix.to_csv(OUTPUT_DIR / "tiles.csv", index=False)
pop_centers_out.to_csv(OUTPUT_DIR / "population_centers.csv", index=False)