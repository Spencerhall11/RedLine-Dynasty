open Types
open Logic

let tiger = Beast_types.iron_flesh_tiger

let stress_attempts = 100_000_000

let () =
  Random.self_init ();
  let start_time = Sys.time () in
  let best = ref None in (* (attempt_num, stats, diag, overcapped_count) *)
  let stillborn_count = ref 0 in
  for i = 1 to stress_attempts do
    let stats, diag = resolve_stats_diagnostic tiger in
    if not (is_viable stats) then incr stillborn_count;
    let overcapped = List.length diag.perfect_specimen_hits in
    let awakened = diag.core_crash_stat <> None in
    if is_viable stats && awakened then
      match !best with
      | None -> best := Some (i, stats, diag, overcapped)
      | Some (_, _, _, best_count) ->
          if overcapped > best_count then best := Some (i, stats, diag, overcapped)
  done;
  let elapsed = Sys.time () -. start_time in
  Printf.printf "Ran %d attempts in %.2fs (%.0f attempts/sec)\n"
    stress_attempts elapsed (float_of_int stress_attempts /. elapsed);
  let stillborn_pct = 100.0 *. float_of_int !stillborn_count /. float_of_int stress_attempts in
  Printf.printf "Stillborn: %d / %d (%.4f%%)\n" !stillborn_count stress_attempts stillborn_pct;
  match !best with
  | None -> print_endline "No viable+awakened tiger found in this run."
  | Some (attempt_num, stats, diag, count) ->
      Printf.printf "Best awakened tiger: attempt #%d, %d natural max caps\n" attempt_num count;
      Printf.printf "  STR=%d STA=%d SPD=%d INT=%d WIS=%d CRE=%d RES=%d\n"
        stats.strength stats.stamina stats.speed stats.intelligence
        stats.wisdom stats.creativity stats.restraint;
      Printf.printf "  Overcapped stats: %s\n" (String.concat ", " diag.perfect_specimen_hits);
      Printf.printf "  Core Crash Lottery hit: %s\n"
        (match diag.core_crash_stat with Some s -> s | None -> "(none)")