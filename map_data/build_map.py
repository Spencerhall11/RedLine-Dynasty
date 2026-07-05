### Convert natural earth shapefile into a CSV to match geography.ml types
### run from map data folder python build_map.py
### outputs land into map_data/processed/*.csv 

### imports
import geopandas as gpd
import h3
import pandas as pd
from shapely.geometry import Point

### H3 resolution
RES = 3

### load datasets
countries = gpd.read_file("ne_50m_admin_0_countries/ne_50m_admin_0_countries.shp")
provinces_raw = gpd.read_file(
    "ne_50m_admin_1_states_provinces/ne_50m_admin_1_states_provinces.shp"
    )
places = gpd.read_file("ne_50m_populated_places/ne_50m_populated_places.shp")

print(f"Loaded {len(countries)} countries, {len(provinces_raw)} provinces, {len(places)} places")

### nations table
nations = countries[["ISO_A2", "SOVEREIGNT", "geometry"]].copy()
nations = nations.rename(columns={"ISO_A2": "nation_id", "SOVEREIGNT": "nation_name"})
nations = nations[nations["nation_id"] != "-99"] ### for disputed territories

### provinces
provinces_from_admin1 = provinces_raw[["adm1_code", "name", "iso_a2", "geometry"]].copy()
provinces_from_admin1 = provinces_from_admin1.rename(
    columns={"adm1_code": "province_id", "name": "province_name", "iso_a2": "nation_id"}
)

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

### Provinces sharing a border
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

### Global H3 tile grid
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
land_tiles = tile_points[tile_points.within(land_union)].copy()
print(f"{len(land_tiles)} land tiles generated")

### assign each tile's province (point-in-polygon against real province shapes)
tiles_with_province = gpd.sjoin(
    land_tiles, provinces[["province_id", "geometry"]], how="left", predicate="within"
)
unmatched_province = tiles_with_province["province_id"].isna().sum()
print(f"{unmatched_province} tiles didn't fall inside any province (coastline rounding)")

### biomes -- load the ecoregions dataset (this was referenced before but never loaded)
ecoregions = gpd.read_file(
    "Resolve_Ecoregions_4212368435134123772/Biomes_and_Ecoregions_2017.shp"
)

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
    "N/A": None,
}
ecoregions["game_biome"] = ecoregions["BIOME_NAME"].map(biome_mapping)
ecoregions_clean = ecoregions[ecoregions["game_biome"].notna()].copy()
print(f"{len(ecoregions)} total ecoregions -> {len(ecoregions_clean)} after dropping unmappable ones")
print(ecoregions_clean["game_biome"].value_counts())

### assign each tile's biome (point-in-polygon against real ecoregion shapes)
# .to_crs() guards against the two datasets not sharing a CRS -- sjoin
# silently gives WRONG matches if they don't line up, rather than erroring,
# so this check matters even though it looks like a formality.
#
# .drop(columns="index_right") matters too: the FIRST sjoin (tiles-to-province,
# above) already added a column called "index_right". A second sjoin refuses
# to run if that column name is already taken -- this isn't optional cleanup,
# the script crashes without it.
ecoregions_matched_crs = ecoregions_clean.to_crs(tiles_with_province.crs)
tiles_with_province_clean = tiles_with_province.drop(columns="index_right")
tiles_with_biome = gpd.sjoin(
    tiles_with_province_clean, ecoregions_matched_crs[["game_biome", "geometry"]],
    how="left", predicate="within"
)
unmatched_biome = tiles_with_biome["game_biome"].isna().sum()
print(f"{unmatched_biome} tiles didn't fall inside any ecoregion (coastline rounding / N/A zones)")

### tiles_out -- this is the piece that was missing: nothing before this
### point ever actually built it, even though later code depended on it.
tiles_out = tiles_with_biome[["tile_id", "province_id", "game_biome"]].copy()
tiles_out = tiles_out.rename(columns={"game_biome": "biome"})
tiles_out["latitude"] = tiles_out["tile_id"].map(lambda c: h3.cell_to_latlng(c)[0])
tiles_out["longitude"] = tiles_out["tile_id"].map(lambda c: h3.cell_to_latlng(c)[1])
tiles_out = tiles_out.dropna(subset=["province_id"])

# Arctic/Antarctic safety net
polar_mask = tiles_out["biome"].isna() & (
    (tiles_out["latitude"] >= 66.5) | (tiles_out["latitude"] <= -60)
)
tiles_out.loc[polar_mask, "biome"] = "Glacial_Cell"
print(f"{polar_mask.sum()} biome-less tiles caught by the polar safety net -> Glacial_Cell")

# Whatever's STILL missing a biome after the polar catch is genuine
still_missing = tiles_out["biome"].isna().sum()
print(f"{still_missing} tiles still biome-less after the polar catch (coastline noise) -- dropping")
tiles_out = tiles_out.dropna(subset=["biome"])

### Population centers
def classify_kind(row):
    if row["ADM0CAP"] == 1:
        return "Capital"
    elif row["POP_MAX"] >= 1_000_000:
        return "City"
    elif row["POP_MAX"] >= 50_000:
        return "Town"
    else:
        return "Village"
 
places_clean = places[["NAME", "POP_MAX", "ADM0CAP", "geometry"]].copy()
places_clean["kind"] = places_clean.apply(classify_kind, axis=1)
places_clean["center_id"] = "PLACE_" + places_clean.index.astype(str)
### snap to containing tile
places_clean["tile_id"] = places_clean.geometry.apply(
    lambda pt: h3.latlng_to_cell(pt.y, pt.x, RES)
)
generated_land_tiles = set(tiles_out["tile_id"])
off_land_count = (~places_clean["tile_id"].isin(generated_land_tiles)).sum()
print(f"{off_land_count} population centers' H3 cell wasn't in the generated land-tile set "
      f"(near-coastline rounding -- their city is on land, the cell center just isn't)")
 
pop_centers_out = places_clean[["center_id", "NAME", "kind", "POP_MAX", "tile_id"]]
pop_centers_out = pop_centers_out.rename(columns={"NAME": "center_name", "POP_MAX": "population"})

### Export it to match geography.ml types
import os
os.makedirs("processed", exist_ok=True)
 
nations[["nation_id", "nation_name"]].to_csv("processed/nations.csv", index=False)
provinces[["province_id", "province_name", "nation_id", "area_sq_km"]].to_csv(
    "processed/provinces.csv", index=False)
pd.DataFrame(
    [(pid, adj) for pid, adjs in adjacency.items() for adj in adjs],
    columns=["province_id", "adjacent_province_id"]
).to_csv("processed/province_adjacency.csv", index=False)
tiles_out.to_csv("processed/tiles.csv", index=False)
pop_centers_out.to_csv("processed/population_centers.csv", index=False)
 
print("\nDone. Files written to processed/:")
for f in ["nations.csv", "provinces.csv", "province_adjacency.csv", "tiles.csv", "population_centers.csv"]:
    path = f"processed/{f}"
    print(f"  {f}: {os.path.getsize(path):,} bytes")