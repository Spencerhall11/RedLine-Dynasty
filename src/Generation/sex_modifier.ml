let apply_sex_bias (sex : sex) (stats : stats) : stats =
  match sex with
  | Female -> { stats with stamina = stats.stamina + 5 } 
  | Male   -> { stats with strength = stats.strength + 5 }
  | Androgynous -> { stats with intelligence = stats.intelligence + 5 }

(* When factory-initializing the entity: *)
let final_stats = apply_sex_bias preset.sex preset.forced_stats |> apply_stats_clamp