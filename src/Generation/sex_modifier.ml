(* src/Generation/sex_modifier.ml *)
open Core.Types

let apply_sex_bias (sex : sex) (stats : stats) : stats =
  match sex with
  | Female -> { stats with stamina = stats.stamina + 5 } 
  | Male   -> { stats with strength = stats.strength + 5 }
  | Androgynous -> { stats with intelligence = stats.intelligence + 5 }

(* Bounds the hardware specs to prevent integer overflow or underflow *)
let apply_stats_clamp (stats : stats) : stats =
  let clamp v = max 0 (min v 100) in (* Assuming 100 is your absolute stat cap *)
  {
    strength = clamp stats.strength;
    stamina = clamp stats.stamina;
    speed = clamp stats.speed;
    intelligence = clamp stats.intelligence;
    wisdom = clamp stats.wisdom;
    creativity = clamp stats.creativity;
    restraint = clamp stats.restraint;
  }