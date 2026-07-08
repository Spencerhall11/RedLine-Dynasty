
(*define the ability*)
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


(*dispatch, apply logic to entity and environment*)
let execute_ability (abil: ability) (user_qi: float) (target: meridian_state) : (float * meridian_state) option =
  if user_qi < abil.qi_cost then None 
  else
    let new_user_qi = user_qi -. abil.qi_cost in
    let apply_effect state eff =
      match eff with
      | Damage_Qi amount -> { state with current_qi = Float.max 0.0 (state.current_qi -. amount) }
      | Drain_Qi amount  -> { state with current_qi = Float.max 0.0 (state.current_qi -. amount) }
      | Buff_Regen amt   -> { state with internal_base_regen = state.internal_base_regen +. amt }
      (* Refinement: Added lock_duration to track the cooldown *)
      | Grid_Lock duration -> { state with is_blocked = true; lock_duration = duration }
    in
    let updated_target = List.fold_left apply_effect target abil.effects in
    Some (new_user_qi, updated_target)