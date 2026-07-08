(* meridians.ml *)

(* formual for Qi tier with capacity based on the tier *)
let get_peak_capacity (tier: int) (stage: int) : float =
    let tier_base_capacity = float_of_int tier *. 300.0 in
    let stage_bonus = float_of_int stage *. 100.0 in
    tier_base_capacity +. stage_bonus

(* regenerating the capacity *)
let get_regen_rate (tier : int) : float =
    15.0 +. (float_of_int tier *. 5.0)

(* call regen every turn *)
let tick (current_qi : float)(tier : int)(stage : int) : float =
    let capacity = get_peak_capacity tier stage in
    let regen = get_regen_rate tier in
    Float.min capacity (current_qi +. regen)



