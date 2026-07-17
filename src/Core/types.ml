(*Contains all the types*)


(*map related types*)
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


(*Qi and ability related*)
type effect =
    | Damage_Qi of float
    | Drain_Qi of float
    | Buff_Regen of float
    | Grid_Lock of int 

(*technique*)
type ability ={
    name : string;
    qi_cost : float;
    effects: effect list;
}

type qi_category = Foundational | Biological | Esoteric | Abstract

type qi_type = {
    id : int;
    name : string;
    category : qi_category;
    stability_base : float;
    spawn_weight : float;
}

(*lineage related*)
type trait_data = {
  potency: float;
}

type ancestry_logic = {
    fusion_stability : float;
    inherit_rate : float;
    mutation_threshold : float;
}


module TraitMap = Map.Make(String)
(*using a map instead of list for performance in large scale*)
type lineage = trait_data TraitMap.t

(*define environment influence*)
type environmental_data = {
  element_affinity: string; (* e.g., "Ice" *)
  qi_concentration: float;  (* 0.0 to 1.0 scale *)
}

(*meridian state*)
type meridian_state = {
  current_qi: float;
  internal_base_regen: float;
  environmental_multiplier: float; (* efficiency *)
  is_blocked: bool; 
}


(*stats for generation*)
type stats = {
  strength: int;
  stamina: int;
  speed: int;
  intelligence: int;
  wisdom: int;
  creativity: int;
  restraint: int;
}

(*array to store entities*)
type entity_store = {
  ids: string array;
  qi_levels: float array;
  positions: int array;
  (* Other fields separated *)
}