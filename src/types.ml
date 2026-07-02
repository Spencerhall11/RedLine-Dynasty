
(* definition of Qi element *) 
type element_id = string

(* 2+1 rule: tracks base and unlocked evolved *)
type affinity_set ={
    base_affinities : element_id list; (* limit of 2*)
    evolved_affinity : element_id option; (*3rd slot, starts blank*)
}

(* Foundation: base stats*)
type ancestry = {
    id : string;
    res_multiplies : (element_id*float) list;
    core_trait: string;
}

(* Environment: early game enhancements *)
type nationality = {
    id : string;
    firmware_locks : element_id list;
    growth_bonus: float;
}

(* Culture: Social protocols *)
type ethnicity = {
    id : string;
    social_scripts : string list;
}

(* Kernel: geographical energy state and source *)
type kernel_state = {
    elements : element_id list;
    stability : float;
    entropy : float;
}

(*The Character: The character node*)
type cultivator ={
    id : string;
    ancestry : ancestry;
    nationality : nationality;
    ethnicity : ethnicity;
    affinities : affinity_set; (* This enforces the 2+1 rule *)
    morality_stain : float;
}


(*World State*)
type world_state ={
    year : int;
    regions : (string * kernel_state) list;
    population : cultivator list;
    archive_logs : string list;
}