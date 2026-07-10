open Redline_dynasty_lib.Qi_types
open Redline_dynasty_lib.Cultivator_generation

type beast_record = {
  mutable count : int;
  mutable best_stats : stats option;
  mutable best_sum : int;
}

let registry = Hashtbl.create 30


(*Initialize registry with zeroed metrics*)

let () =
  List.iter (fun qi -> 
    Hashtbl.add registry qi.name {
      count = 0;
      best_stats = None;
      best_sum = 0;
    }
  ) qi_types

let run_beast_stress_test pop_size =
  Printf.printf "Initiating Beast Registry Stress Test (%d entities)...\n" pop_size;
  let start_time = Unix.gettimeofday () in

  for i = 1 to pop_size do
    (* Simulate generation *)
    let qi = List.nth qi_types (Random.int 30) in
    let candidate = generate_stats i in
    
    (*In-place calculation (avoiding object allocation where possible) *)
    let sum = candidate.strength + candidate.stamina + candidate.speed + 
              candidate.intelligence + candidate.wisdom + candidate.creativity + 
              candidate.restraint in
    
    (* Update Registry *)
    let record = Hashtbl.find registry qi.name in
    record.count <- record.count + 1;
    
    if sum > record.best_sum then (
      record.best_sum <- sum;
      record.best_stats <- Some candidate;
    );
    
    (* Progress indicator every 100M *)
    if i mod 100_000_000 = 0 then
      Printf.printf "Processed %dM entities...\n" (i / 1_000_000)
  done;

  let duration = Unix.gettimeofday () -. start_time in
  Printf.printf "Registry Audit Complete in %.2f seconds.\n" duration;
  Printf.printf "Throughput: %.2f M entities/second.\n" ( (float_of_int pop_size /. duration) /. 1_000_000.0)

let print_results () =
  Printf.printf "\n%-20s | %-12s | %-10s\n" "Qi Type" "Processed" "Best Sum";
  Hashtbl.iter (fun name r ->
    Printf.printf "%-20s | %-12d | %-10d\n" name r.count r.best_sum;
    match r.best_stats with
    | Some s -> Printf.printf "   -> Elite: STR:%d STA:%d SPD:%d INT:%d WIS:%d CRE:%d RES:%d\n" 
                s.strength s.stamina s.speed s.intelligence s.wisdom s.creativity s.restraint
    | None -> ()
  ) registry

let () =
  Random.self_init ();
  (* Running 500 Million *)
  run_beast_stress_test 500_000_000;
  print_results ()