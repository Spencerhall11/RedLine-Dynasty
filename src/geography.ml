(* src/geography.ml *)

open Types

type nation = {
  nation_id : string;      
  nation_name : string;    
}

type province = {
  province_id : string;     
  province_name : string;   
  nation_id : string;       
  area_sq_km : float;       
}

type tile = {
  tile_id : string;         
  province_id : string;    
  cell_type : cell_type;   
  latitude : float;         
  longitude : float;        
}

type population_center = {
  center_id : string;       
  center_name : string;    
  kind : string;            
  population : int;         
  tile_id : string;         
}

let nation_registry : (string, nation) Hashtbl.t = Hashtbl.create 250
let province_registry : (string, province) Hashtbl.t = Hashtbl.create 600
let tile_registry : (string, tile) Hashtbl.t = Hashtbl.create 45000
let center_registry : (string, population_center) Hashtbl.t = Hashtbl.create 1500

let province_adjacency : (string, string list) Hashtbl.t = Hashtbl.create 2000

let cell_type_of_string = function
  | "Forest_Cell" -> Forest_Cell
  | "Plains_Cell" -> Plains_Cell
  | "Desert_Cell" -> Desert_Cell
  | "Mountain_Cell" -> Mountain_Cell
  | "Glacial_Cell" -> Glacial_Cell
  | "Ice_Cell" -> Ice_Cell
  | "Coastal_Cell" -> Coastal_Cell
  | "Industrial_Cell" -> Industrial_Cell
  | "Mountain_Peak_Cell" -> Mountain_Peak_Cell
  | "Ocean_Cell" -> Ocean_Cell
  | "Blood_Stained_Battlefield_Cell" -> Blood_Stained_Battlefield_Cell
  | "Technical_Citadel_Cell" -> Technical_Citadel_Cell
  | _ -> Plains_Cell

let register_nation id name =
  let n = { nation_id = id; nation_name = name } in
  Hashtbl.replace nation_registry id n

let register_province id name nid area_str =
  let p = {
    province_id = id;
    province_name = name;
    nation_id = nid;
    area_sq_km = float_of_string area_str;
  } in
  Hashtbl.replace province_registry id p

let register_adjacency pid adjacent_pid =
  let current_neighbors = 
    try Hashtbl.find province_adjacency pid with Not_found -> [] 
  in
  if not (List.mem adjacent_pid current_neighbors) then
    Hashtbl.replace province_adjacency pid (adjacent_pid :: current_neighbors)

let register_tile id pid biome_str lat_str lng_str =
  let t = {
    tile_id = id;
    province_id = pid;
    cell_type = cell_type_of_string biome_str;
    latitude = float_of_string lat_str;
    longitude = float_of_string lng_str;
  } in
  Hashtbl.replace tile_registry id t

let register_population_center id name kind pop_str tid =
  let c = {
    center_id = id;
    center_name = name;
    kind;
    population = int_of_string pop_str;
    tile_id = tid;
  } in
  Hashtbl.replace center_registry id c

(* Robust CSV Row Parser: Ignores commas inside quoted strings and strips bounding quotes *)
let parse_csv_line line =
  let len = String.length line in
  let rec collect fields current in_quotes i =
    if i >= len then
      List.rev (Buffer.contents current :: fields)
    else
      match line.[i] with
      | '"' -> 
          collect fields current (not in_quotes) (i + 1)
      | ',' when not in_quotes -> 
          let field = Buffer.contents current in
          Buffer.clear current;
          collect (field :: fields) current in_quotes (i + 1)
      | c -> 
          Buffer.add_char current c;
          collect fields current in_quotes (i + 1)
  in
  collect [] (Buffer.create 16) false 0

(* --- SYSTEM DATASET LOADING PIPELINES --- *)

let load_nations path =
  let ic = open_in path in
  try
    ignore (input_line ic); 
    while true do
      let line = input_line ic in
      match parse_csv_line line with
      | id :: name :: _ -> register_nation id name
      | _ -> ()
    done
  with End_of_file -> close_in ic

let load_provinces path =
  let ic = open_in path in
  try
    ignore (input_line ic);
    while true do
      let line = input_line ic in
      match parse_csv_line line with
      | id :: name :: nid :: area :: _ -> register_province id name nid area
      | _ -> ()
    done
  with End_of_file -> close_in ic

let load_adjacencies path =
  let ic = open_in path in
  try
    ignore (input_line ic);
    while true do
      let line = input_line ic in
      match parse_csv_line line with
      | pid :: adjacent_pid :: _ -> register_adjacency pid adjacent_pid
      | _ -> ()
    done
  with End_of_file -> close_in ic

let load_tiles path =
  let ic = open_in path in
  try
    ignore (input_line ic);
    while true do
      let line = input_line ic in
      match parse_csv_line line with
      | id :: pid :: biome :: lat :: lng :: _ -> register_tile id pid biome lat lng
      | _ -> ()
    done
  with End_of_file -> close_in ic

let load_population_centers path =
  let ic = open_in path in
  try
    ignore (input_line ic);
    while true do
      let line = input_line ic in
      match parse_csv_line line with
      | id :: name :: kind :: pop :: tid :: _ -> register_population_center id name kind pop tid
      | _ -> ()
    done
  with End_of_file -> close_in ic

let bootstrap_world_map ~nations_path ~provinces_path ~adjacency_path ~tiles_path ~centers_path =
  load_nations nations_path;
  load_provinces provinces_path;
  load_adjacencies adjacency_path;
  load_tiles tiles_path;
  load_population_centers centers_path