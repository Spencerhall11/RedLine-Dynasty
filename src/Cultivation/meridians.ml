(* meridians.ml *)


(* regenerating the capacity *)
let get_internal_regen (tier: int) (stage: int) : float =
  let base = 15.0 +. (float_of_int tier *. 5.0) in
  let stage_bonus = float_of_int stage *. 2.0 in
  base +. stage_bonus

(* formual for Qi tier with capacity based on the tier *)
let get_peak_capacity (tier: int) (stage: int) : float =
  (float_of_int tier *. 300.0) +. (float_of_int stage *. 100.0)


(* tick process*)
let tick (state: meridian_state) (tier: int) (stage: int) : meridian_state =
  if state.is_blocked then
    { state with current_qi = Float.min (get_peak_capacity tier stage) state.current_qi }
  else
    let regen = state.internal_base_regen *. state.environmental_multiplier in
    let capacity = get_peak_capacity tier stage in
    let new_qi = Float.min capacity (state.current_qi +. regen) in
    { state with current_qi = new_qi }



