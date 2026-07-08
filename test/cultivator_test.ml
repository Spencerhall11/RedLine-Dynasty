open Types
open Logic

let dummy_ancestry =
  { id = "Common"; res_multiplies = []; core_trait = "Baseline";
    stability_penalty = 0.0; affinity_unlock = false }
let dummy_nationality = { id = "Wildlands"; firmware_locks = []; growth_bonus = 1.0 }
let dummy_ethnicity = { id = "Unindexed"; social_scripts = [] }

let founder_trait =
  { trait_name = "Iron-Flesh Tiger Heritage"; potency = 0.7; trait_source = "Iron-Flesh Tiger" }

(* Tunables *)
let reinforcement_chance = 0.05   (* chance an incoming line independently also carries the trait *)
let generations_per_line = 20
let num_lines = 200_000
let breakthroughs_per_lifetime = 10 (* how many attempts each generation gets before reproduction *)

let make_founder (id : string) (sex : sex) (carries_trait : bool) : cultivator =
  {
    id; ancestry = dummy_ancestry; nationality = dummy_nationality; ethnicity = dummy_ethnicity;
    sex; affinities = { base_affinities = [ "Fire"; "Water" ]; evolved_affinity = None };
    morality_stain = 0.1; stability = 0.7; mental_bandwidth = 8.0;
    is_sentient = true; is_renegade = false; disposition = Ambitious; control = Autonomous;
    lineage_traits = (if carries_trait then [ founder_trait ] else []);
    parent_ids = []; generation = 0; qi_tier = 0;
  }

(* Attempts several breakthroughs in a row (a "lifetime" of cultivation
   before breeding). Stops early on a failed attempt -- a failure
   means stability/bandwidth are spent, further attempts would just
   fail the same way, no point burning more iterations on it. *)
let rec cultivate (c : cultivator) (attempts_left : int) : cultivator =
  if attempts_left <= 0 || c.qi_tier >= 10 then c
  else
    let c', _log = attempt_breakthrough c in
    if c'.qi_tier > c.qi_tier then cultivate c' (attempts_left - 1) else c'

let trait_potency (c : cultivator) : float =
  match List.find_opt (fun t -> t.trait_name = founder_trait.trait_name) c.lineage_traits with
  | Some t -> t.potency
  | None -> 0.0

let random_sex () = if Random.bool () then Male else Female

(* Simulates one full family line: two founders -> N generations of
   breeding, each generation cultivating before producing the next.
   Returns the final generation's tier and surviving trait potency
   (0.0 if the trait was diluted below the prune threshold). *)
let run_line (line_id : int) : int * float =
  let mother = cultivate (make_founder (Printf.sprintf "L%d-f0" line_id) Female true) breakthroughs_per_lifetime in
  let father = cultivate (make_founder (Printf.sprintf "L%d-m0" line_id) Male false) breakthroughs_per_lifetime in
  let first_sex = random_sex () in
  let current =
    ref
      (match
         spawn_child (Printf.sprintf "L%d-g1" line_id) mother father first_sex dummy_ancestry
           dummy_nationality dummy_ethnicity Ambitious mother.affinities
       with
      | Ok c -> c
      | Error msg -> failwith ("unexpected fertility gate failure: " ^ msg))
  in
  for gen = 2 to generations_per_line do
    let cultivated = cultivate !current breakthroughs_per_lifetime in
    let mate_sex = match cultivated.sex with Male -> Female | Female -> Male in
    let mate_carries = Random.float 1.0 < reinforcement_chance in
    let mate =
      cultivate (make_founder (Printf.sprintf "L%d-mate%d" line_id gen) mate_sex mate_carries)
        breakthroughs_per_lifetime
    in
    let next_sex = random_sex () in
    let next =
      match
        spawn_child (Printf.sprintf "L%d-g%d" line_id gen) cultivated mate next_sex dummy_ancestry
          dummy_nationality dummy_ethnicity Ambitious cultivated.affinities
      with
      | Ok c -> c
      | Error msg -> failwith ("unexpected fertility gate failure: " ^ msg)
    in
    current := next
  done;
  (* The final descendant is a newborn (qi_tier always resets to 0 at
     birth) until THEY cultivate -- read their tier after their own
     lifetime of attempts, not straight off spawn_child's output. *)
  let final_cultivated = cultivate !current breakthroughs_per_lifetime in
  (final_cultivated.qi_tier, trait_potency !current)

let () =
  Random.self_init ();
  let start_time = Sys.time () in
  let tier_sum = ref 0 in
  let trait_survived_count = ref 0 in
  let best_line = ref (-1, -1, 0.0) in
  for i = 1 to num_lines do
    let final_tier, final_potency = run_line i in
    tier_sum := !tier_sum + final_tier;
    if final_potency > 0.0 then incr trait_survived_count;
    let _, best_tier, best_potency = !best_line in
    if final_tier > best_tier || (final_tier = best_tier && final_potency > best_potency) then
      best_line := (i, final_tier, final_potency)
  done;
  let elapsed = Sys.time () -. start_time in
  let total_cultivators = num_lines * generations_per_line in
  Printf.printf "Simulated %d lines x %d generations = %d cultivators in %.2fs (%.0f cultivators/sec)\n"
    num_lines generations_per_line total_cultivators elapsed
    (float_of_int total_cultivators /. elapsed);
  Printf.printf "Average final tier at generation %d: %.2f\n" generations_per_line
    (float_of_int !tier_sum /. float_of_int num_lines);
  Printf.printf "Trait survived to generation %d in %d / %d lines (%.4f%%)\n" generations_per_line
    !trait_survived_count num_lines
    (100.0 *. float_of_int !trait_survived_count /. float_of_int num_lines);
  let best_id, best_tier, best_potency = !best_line in
  Printf.printf "Best line: #%d, final tier %d, trait potency %.4f\n" best_id best_tier best_potency