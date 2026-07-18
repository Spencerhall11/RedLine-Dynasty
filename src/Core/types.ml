(* Contains all the types *)

(* Map related types *)
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

(* Fully synchronized with geography.ml *)
type cell_type = 
  | Forest_Cell
  | Plains_Cell
  | Desert_Cell
  | Mountain_Cell
  | Glacial_Cell
  | Ice_Cell
  | Coastal_Cell
  | Industrial_Cell
  | Mountain_Peak_Cell
  | Ocean_Cell
  | Blood_Stained_Battlefield_Cell
  | Technical_Citadel_Cell

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


(* Qi and ability related *)
type qi_effect =
  | Damage_Qi of float
  | Drain_Qi of float
  | Buff_Regen of float
  | Grid_Lock of int 

(* Technique *)
type ability = {
  name : string;
  qi_cost : float;
  effects: qi_effect list;
}

type rank_value = int

type qi_category = Foundational | Biological | Esoteric | Abstract

type qi_type = {
  id : int;
  name : string;
  category : qi_category;
  stability_base : float;
  spawn_weight : float;
}

(* Alphabetical Manhua-style talent tiers *)
type affinity_tier =
  | E
  | D
  | C
  | B
  | A
  | S
  | SS
  | SSS

(* Maps a specific type of Qi element to its potential talent tier *)
type qi_affinity = {
  qi_id : int;
  tier : affinity_tier;
}

(* Lineage related *)
type trait_data = {
  potency: float;
}

type ancestry_logic = {
  fusion_stability : float;
  inherit_rate : float;
  mutation_threshold : float;
}

module TraitMap = Map.Make(String)
(* Using a map instead of list for performance in large scale *)
type lineage = trait_data TraitMap.t

(* Define environment influence *)
type environmental_data = {
  element_affinity: string; (* e.g., "Ice" *)
  qi_concentration: float;  (* 0.0 to 1.0 scale *)
}

(* Meridian state *)
type meridian_state = {
  current_qi: float;
  internal_base_regen: float;
  environmental_multiplier: float; (* efficiency *)
  is_blocked: bool; 
}


(* Stats for generation *)
type stats = {
  strength: int;
  stamina: int;
  speed: int;
  intelligence: int;
  wisdom: int;
  creativity: int;
  restraint: int;
}

(* Array to store entities *)
type entity_store = {
  ids: string array;
  qi_levels: float array;
  positions: int array;
  (* 
     For the main simulation loop, an entity's element affinities are 
     stored as a flat two-dimensional float array [| entity_index * qi_id |] 
     or an array of float arrays mapping directly to multipliers for lightning-fast lookups.
  *)
  affinity_multipliers : float array array; 
}

type preset_qi_assignment = {
  (* The user-facing unique flair name for this character's setup *)
  custom_technique_name : string; 
  (* 
     Allows the preset list to manually specify exactly which elements this character 
     excels at without restriction. Unlisted elements default to untalented (E-tier) baseline values.
  *)
  individual_affinities : qi_affinity list;
}

type preset_character = {
  input_name     : string;
  forced_stats   : stats;
  starting_rank  : int;
  qi_setup       : preset_qi_assignment;
}