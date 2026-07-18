open Core.Types

(* Define the beast types directly inside the test framework *)
type synergy_entry = {
  stat_name : string;
  synergy_element : string;
  synergy_name : string;
  synergy_desc : string;
}

type transformation_requirements = {
  min_qi_tier : int;
  min_intelligence : int;
  min_memory_depth : int;
  required_skill : string;
  min_mastery : float;
  base_success_chance : float;
}

type species_template = {
  species_name : string;
  max_strength : int;
  max_stamina : int;
  max_speed : int;
  max_intelligence : int;
  max_wisdom : int;
  max_creativity : int;
  max_restraint : int;
  mutation_tolerance : float;
  core_crash_chance : float;
  core_crash_max_bonus : int;
  perfect_specimen_max_bonus : int;
  spawn_weights : (cell_type * (string * float) list) list;
  synergy_table : synergy_entry list;
  transformation_reqs : transformation_requirements option;
}

(* Telemetry tracker per sub-category *)
type breed_counter = {
  mutable spawn_count  : int64;
  mutable death_count  : int64;
  mutable peak_sum     : int;
  mutable peak_stats   : stats option;
  mutable peak_element : string option; (* Tracks the element context for beasts *)
}

type entity_metrics = {
  variant_tracking : (string, breed_counter) Hashtbl.t;
}

let create_metrics () = {
  variant_tracking = Hashtbl.create 32;
}

let track_specimen metrics name is_stillborn current_sum stat_profile element_name =
  let counter = 
    match Hashtbl.find_opt metrics.variant_tracking name with
    | Some c -> c
    | None ->
        let new_c = { 
          spawn_count = 0L; 
          death_count = 0L; 
          peak_sum = -1; 
          peak_stats = None; 
          peak_element = None; 
        } in
        Hashtbl.add metrics.variant_tracking name new_c;
        new_c
  in
  counter.spawn_count <- Int64.add counter.spawn_count 1L;
  if is_stillborn then
    counter.death_count <- Int64.add counter.death_count 1L
  else if current_sum > counter.peak_sum then begin
    counter.peak_sum <- current_sum;
    counter.peak_stats <- Some stat_profile;
    counter.peak_element <- Some element_name;
  end

(* Comprehensive array mirroring your species templates for stress testing *)
let beast_species_pool : species_template array = [|
  { species_name = "Iron-Flesh Tiger"; max_strength = 85; max_stamina = 95; max_speed = 55; max_intelligence = 80; max_wisdom = 50; max_creativity = 40; max_restraint = 75; mutation_tolerance = 0.55; core_crash_chance = 0.005; core_crash_max_bonus = 40; perfect_specimen_max_bonus = 30; spawn_weights = []; synergy_table = []; transformation_reqs = None };
  { species_name = "Blood-Drinker Lion"; max_strength = 100; max_stamina = 65; max_speed = 75; max_intelligence = 60; max_wisdom = 30; max_creativity = 90; max_restraint = 35; mutation_tolerance = 0.75; core_crash_chance = 0.008; core_crash_max_bonus = 50; perfect_specimen_max_bonus = 20; spawn_weights = []; synergy_table = []; transformation_reqs = None };
  { species_name = "Tectonic Iron-Bear"; max_strength = 110; max_stamina = 120; max_speed = 35; max_intelligence = 65; max_wisdom = 85; max_creativity = 30; max_restraint = 90; mutation_tolerance = 0.50; core_crash_chance = 0.004; core_crash_max_bonus = 45; perfect_specimen_max_bonus = 35; spawn_weights = []; synergy_table = []; transformation_reqs = None };
  { species_name = "Void-Shimmer Fox"; max_strength = 50; max_stamina = 70; max_speed = 130; max_intelligence = 70; max_wisdom = 60; max_creativity = 40; max_restraint = 30; mutation_tolerance = 0.80; core_crash_chance = 0.008; core_crash_max_bonus = 25; perfect_specimen_max_bonus = 30; spawn_weights = []; synergy_table = []; transformation_reqs = None };
  { species_name = "Tectonic Iron-Ox"; max_strength = 120; max_stamina = 150; max_speed = 20; max_intelligence = 40; max_wisdom = 90; max_creativity = 20; max_restraint = 120; mutation_tolerance = 0.40; core_crash_chance = 0.002; core_crash_max_bonus = 20; perfect_specimen_max_bonus = 50; spawn_weights = []; synergy_table = []; transformation_reqs = None };
  { species_name = "Phantom-Stride Steed"; max_strength = 60; max_stamina = 110; max_speed = 150; max_intelligence = 60; max_wisdom = 70; max_creativity = 40; max_restraint = 50; mutation_tolerance = 0.65; core_crash_chance = 0.015; core_crash_max_bonus = 20; perfect_specimen_max_bonus = 60; spawn_weights = []; synergy_table = []; transformation_reqs = None };
  { species_name = "Star-Glance Deer"; max_strength = 30; max_stamina = 60; max_speed = 100; max_intelligence = 110; max_wisdom = 120; max_creativity = 50; max_restraint = 40; mutation_tolerance = 0.90; core_crash_chance = 0.01; core_crash_max_bonus = 15; perfect_specimen_max_bonus = 60; spawn_weights = []; synergy_table = []; transformation_reqs = None };
  { species_name = "Steel-Bristle Boar"; max_strength = 110; max_stamina = 130; max_speed = 45; max_intelligence = 45; max_wisdom = 55; max_creativity = 30; max_restraint = 80; mutation_tolerance = 0.65; core_crash_chance = 0.003; core_crash_max_bonus = 35; perfect_specimen_max_bonus = 35; spawn_weights = []; synergy_table = []; transformation_reqs = None };
  { species_name = "Jade-Pulse Rabbit"; max_strength = 25; max_stamina = 55; max_speed = 120; max_intelligence = 95; max_wisdom = 95; max_creativity = 85; max_restraint = 40; mutation_tolerance = 0.85; core_crash_chance = 0.009; core_crash_max_bonus = 20; perfect_specimen_max_bonus = 45; spawn_weights = []; synergy_table = []; transformation_reqs = None };
  { species_name = "Monolith-Core Elephant"; max_strength = 140; max_stamina = 160; max_speed = 25; max_intelligence = 85; max_wisdom = 100; max_creativity = 40; max_restraint = 110; mutation_tolerance = 0.45; core_crash_chance = 0.003; core_crash_max_bonus = 30; perfect_specimen_max_bonus = 45; spawn_weights = []; synergy_table = []; transformation_reqs = None };
  { species_name = "Ram-Driver Rhinoceros"; max_strength = 130; max_stamina = 120; max_speed = 50; max_intelligence = 50; max_wisdom = 60; max_creativity = 30; max_restraint = 95; mutation_tolerance = 0.50; core_crash_chance = 0.005; core_crash_max_bonus = 35; perfect_specimen_max_bonus = 40; spawn_weights = []; synergy_table = []; transformation_reqs = None };
  { species_name = "Chroma-Blur Leopard"; max_strength = 75; max_stamina = 80; max_speed = 145; max_intelligence = 80; max_wisdom = 60; max_creativity = 65; max_restraint = 45; mutation_tolerance = 0.80; core_crash_chance = 0.010; core_crash_max_bonus = 30; perfect_specimen_max_bonus = 50; spawn_weights = []; synergy_table = []; transformation_reqs = None };
  { species_name = "Hyper-Clock Cheetah"; max_strength = 65; max_stamina = 70; max_speed = 160; max_intelligence = 75; max_wisdom = 50; max_creativity = 60; max_restraint = 35; mutation_tolerance = 0.75; core_crash_chance = 0.018; core_crash_max_bonus = 25; perfect_specimen_max_bonus = 55; spawn_weights = []; synergy_table = []; transformation_reqs = None };
  { species_name = "Scavenging Scum Hyena"; max_strength = 80; max_stamina = 95; max_speed = 90; max_intelligence = 65; max_wisdom = 45; max_creativity = 75; max_restraint = 40; mutation_tolerance = 0.85; core_crash_chance = 0.012; core_crash_max_bonus = 35; perfect_specimen_max_bonus = 25; spawn_weights = []; synergy_table = []; transformation_reqs = None };
  { species_name = "Core-Breaker Badger"; max_strength = 95; max_stamina = 115; max_speed = 60; max_intelligence = 55; max_wisdom = 75; max_creativity = 40; max_restraint = 90; mutation_tolerance = 0.60; core_crash_chance = 0.004; core_crash_max_bonus = 45; perfect_specimen_max_bonus = 35; spawn_weights = []; synergy_table = []; transformation_reqs = None };
  { species_name = "Grid-Tunnel Mole"; max_strength = 50; max_stamina = 100; max_speed = 40; max_intelligence = 70; max_wisdom = 95; max_creativity = 50; max_restraint = 105; mutation_tolerance = 0.55; core_crash_chance = 0.002; core_crash_max_bonus = 30; perfect_specimen_max_bonus = 40; spawn_weights = []; synergy_table = []; transformation_reqs = None };
  { species_name = "Signal-Spike Hedgehog"; max_strength = 45; max_stamina = 90; max_speed = 55; max_intelligence = 65; max_wisdom = 85; max_creativity = 55; max_restraint = 110; mutation_tolerance = 0.65; core_crash_chance = 0.005; core_crash_max_bonus = 20; perfect_specimen_max_bonus = 45; spawn_weights = []; synergy_table = []; transformation_reqs = None };
  { species_name = "Logic-Leak Weasel"; max_strength = 40; max_stamina = 65; max_speed = 135; max_intelligence = 100; max_wisdom = 70; max_creativity = 95; max_restraint = 35; mutation_tolerance = 0.85; core_crash_chance = 0.015; core_crash_max_bonus = 30; perfect_specimen_max_bonus = 50; spawn_weights = []; synergy_table = []; transformation_reqs = None };
  { species_name = "Cache-Hoarder Squirrel"; max_strength = 35; max_stamina = 75; max_speed = 115; max_intelligence = 90; max_wisdom = 80; max_creativity = 100; max_restraint = 55; mutation_tolerance = 0.80; core_crash_chance = 0.007; core_crash_max_bonus = 20; perfect_specimen_max_bonus = 40; spawn_weights = []; synergy_table = []; transformation_reqs = None }
|]

let run_generation_pass (label : string) (iterations : int) (qi_pool : qi_type array) =
  let metrics = create_metrics () in
  let pool_size = Array.length qi_pool in
  let species_pool_size = Array.length beast_species_pool in
  
  Printf.printf "[INFO] Starting Tracking Pass for: %s...\n%!" label;
  let start_time = Unix.gettimeofday () in

  for _ = 1 to iterations do
    let qi = qi_pool.(Random.int pool_size) in
    
    let name_key, str, sta, spd, int_, wis, crt, rst =
      if label = "BEASTS" then
        let spec = beast_species_pool.(Random.int species_pool_size) in
        (spec.species_name,
         Random.int (spec.max_strength + 1),
         Random.int (spec.max_stamina + 1),
         Random.int (spec.max_speed + 1),
         Random.int (spec.max_intelligence + 1),
         Random.int (spec.max_wisdom + 1),
         Random.int (spec.max_creativity + 1),
         Random.int (spec.max_restraint + 1))
      else
        (qi.name,
         Random.int 101, Random.int 101, Random.int 101,
         Random.int 101, Random.int 101, Random.int 101, Random.int 101)
    in

    let current_sum = str + sta + spd + int_ + wis + crt + rst in
    let stat_profile = { strength = str; stamina = sta; speed = spd; intelligence = int_; wisdom = wis; creativity = crt; restraint = rst } in

    (* Rule of Zero Check: An absolute evolutionary filter *)
    let rolled_zero = 
      str = 0 || sta = 0 || spd = 0 || int_ = 0 || wis = 0 || crt = 0 || rst = 0 
    in

    let stillbirth_trigger = 
      if rolled_zero then 
        true 
      else 
        match qi.category with
        | Esoteric -> (float_of_int (wis + rst) /. 200.0) < (1.0 -. qi.stability_base)
        | Abstract -> (float_of_int (int_ + crt) /. 200.0) < (1.0 -. qi.stability_base)
        | Foundational | Biological -> Random.float 1.0 > qi.stability_base
    in

    track_specimen metrics name_key stillbirth_trigger current_sum stat_profile qi.name
  done;

  let end_time = Unix.gettimeofday () in
  
  Printf.printf "\n=== TELEMETRY PASSTHROUGH: %s ===\n" label;
  Printf.printf "Execution Time: %.2f seconds\n" (end_time -. start_time);
  Printf.printf "--- Breakdown by Category Variant ---\n";
  
  Hashtbl.iter (fun name c ->
    let rate = if c.spawn_count > 0L 
      then (Int64.to_float c.death_count /. Int64.to_float c.spawn_count) *. 100.0 
      else 0.0 
    in
    Printf.printf "  * %s:\n" name;
    Printf.printf "    Metrics   -> Spawns: %Ld | Stillbirths: %Ld (%.2f%%)\n" 
      c.spawn_count c.death_count rate;
    
    match c.peak_stats with
    | Some p ->
        let context_label = if label = "BEASTS" then "Spawned Environment Element" else "Inherent Element" in
        let element_val = match c.peak_element with Some e -> e | None -> "Unknown" in
        Printf.printf "    Strongest -> Sum: %d | %s: %s\n" c.peak_sum context_label element_val;
        Printf.printf "                 STR: %d | STA: %d | SPD: %d | INT: %d | WIS: %d | CRT: %d | RST: %d\n"
          p.strength p.stamina p.speed p.intelligence p.wisdom p.creativity p.restraint
    | None -> Printf.printf "    Strongest -> No viable specimen survived.\n"
  ) metrics.variant_tracking

(* Executable main block calling the functions *)
let () =
  Random.self_init ();
  let qi_pool = Array.of_list Cultivation.qi_types in
  let target_iterations = 10_000_000 in
  
  run_generation_pass "CULTIVATORS" target_iterations qi_pool;
  print_endline "--------------------------------------------------------------------------------";
  run_generation_pass "BEASTS" target_iterations qi_pool;
  print_endline "\n[SUCCESS] Matrix Group Telemetry Extraction Complete."