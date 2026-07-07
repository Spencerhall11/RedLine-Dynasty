open Types
open Logic

let tiger = Beast_types.iron_flesh_tiger

(* Condition A: stillborn. Just the count -- no cause breakdown needed. *)
let rec find_stillborn attempts =
  match attempt_spawn (Printf.sprintf "a-%d" attempts) tiger Feral Forest_Cell "region-1" with
  | Stillborn _ -> attempts
  | Viable _ -> find_stillborn (attempts + 1)

(* Condition B: alive, AND 3+ stats independently break their natural
   cap (Perfect Specimen Overclock, Vector 2), AND the Core Crash
   Lottery (Vector 1) also fires independently on the same roll. Uses
   resolve_stats_diagnostic's explicit fired-flag rather than
   inferring it from before/after equality, which would silently
   miscount the (rare but real) case where the crash bonus rolls 0. *)
let rec find_breakthrough attempts =
  let stats, diag = resolve_stats_diagnostic tiger in
  let overcapped = List.length diag.perfect_specimen_hits in
  let core_crash_fired = diag.core_crash_stat <> None in
  if is_viable stats && overcapped >= 3 && core_crash_fired then (attempts, stats, diag)
  else find_breakthrough (attempts + 1)

let () =
  Random.self_init ();

  let stillborn_count = find_stillborn 1 in
  Printf.printf "Stillborn: %d attempts\n" stillborn_count;

  let breakthrough_count, stats, diag = find_breakthrough 1 in
  Printf.printf "3-stat overcap + Core Crash Lottery: %d attempts\n" breakthrough_count;
  Printf.printf "  STR=%d STA=%d SPD=%d INT=%d WIS=%d CRE=%d RES=%d\n"
    stats.strength stats.stamina stats.speed stats.intelligence
    stats.wisdom stats.creativity stats.restraint;
  Printf.printf "  Overcapped stats: %s\n" (String.concat ", " diag.perfect_specimen_hits);
  Printf.printf "  Core Crash Lottery hit: %s\n"
    (match diag.core_crash_stat with Some s -> s | None -> "(none)");

  (* Build the actual beast for this breakthrough roll and pull its art.
     Forced to Wood/Water since that's the only asset that currently
     exists -- swap this once more art is added. *)
  let breakthrough_beast =
    assemble_forced "breakthrough-tiger" tiger Calculating "region-1"
      "Standard Wood Qi" (Some "Standard Water Qi") stats
  in
  ignore (pull_and_show_image breakthrough_beast)