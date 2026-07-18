open Core.Types
open Generation.Cultivator_generation

type audit_record = {
  mutable total_processed : int;
  mutable stillborns : int;
  mutable successes : int;
  mutable best_stats : stats option;
  mutable best_sum : int;
}

(* Pre-convert to array for O(1) selection *)
let qi_array = Array.of_list qi_types
let registry_size = Array.length qi_array

let audit_results = 
  let map = Hashtbl.create registry_size in
  List.iter (fun qi -> Hashtbl.add map qi.name {
    total_processed = 0;
    stillborns = 0;
    successes = 0;
    best_sum = 0;
    best_stats = None
  }) qi_types;
  map

let run_stress_test pop_size =
  print_endline "Initiating Systemic Yield Audit...";
  
  let start_time = Unix.gettimeofday () in
  
  for _ = 1 to pop_size do
    (* Use the pre-indexed array for O(1) access *)
    let qi = qi_array.(Random.int registry_size) in
    let record = Hashtbl.find audit_results qi.name in
    
    record.total_processed <- record.total_processed + 1;
    if Random.int 100 = 0 then
      record.stillborns <- record.stillborns + 1
    else (
      record.successes <- record.successes + 1;
      let candidate_stats = generate_stats () in 
      let sum = (candidate_stats.strength + candidate_stats.stamina + 
                 candidate_stats.speed + candidate_stats.intelligence + 
                 candidate_stats.wisdom + candidate_stats.creativity + 
                 candidate_stats.restraint) in
      
      if sum > record.best_sum then (
        record.best_sum <- sum;
        record.best_stats <- Some candidate_stats;
      )
    )
  done;
  
  let end_time = Unix.gettimeofday () in
  let duration = end_time -. start_time in
  let eps = float_of_int pop_size /. duration in
  
  Printf.printf "\nAudit Complete in %.2f seconds.\n" duration;
  Printf.printf "Throughput: %.2f entities/second.\n" eps

let print_report () =
  Printf.printf "%-20s | %-10s | %-10s | %-10s\n" "Qi Type" "Success %" "Stillborn %" "Best Stat Sum";
  Hashtbl.iter (fun name r ->
    let total = float_of_int r.total_processed in
    let yield = if total > 0.0 then (float_of_int r.successes /. total) *. 100.0 else 0.0 in
    let fail = if total > 0.0 then (float_of_int r.stillborns /. total) *. 100.0 else 0.0 in
    Printf.printf "%-20s | %-10.2f | %-10.2f | %-10d\n" name yield fail r.best_sum;
    match r.best_stats with
    | Some s -> Printf.printf "   -> Elite: STR:%d STA:%d SPD:%d INT:%d WIS:%d CRE:%d RES:%d\n" 
                s.strength s.stamina s.speed s.intelligence s.wisdom s.creativity s.restraint
    | None -> ()
  ) audit_results

let () =
  Random.self_init ();
  run_stress_test 100_000_000;
  print_report ()