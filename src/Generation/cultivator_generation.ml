(* cultivator generator *)
open Core.Types
open Cultivation.Qi_ranks

(* Simplified using a normal distribution *)
let generate_stats (seed: int) : stats =
  let rng = Random.State.make [|seed|] in
  
  (* keep stats in a reasonable range*)
  let roll_stat () = 
    (* Roll 3 dice and sum them for a bell curve distribution *)
    (Random.State.int rng 33 + Random.State.int rng 33 + Random.State.int rng 34)
  in
  
  {
    strength = roll_stat ();
    stamina = roll_stat ();
    speed = roll_stat ();
    intelligence = roll_stat ();
    wisdom = roll_stat ();
    creativity = roll_stat ();
    restraint = roll_stat ();
  }

(** Weighted distribution to determine an individual element's talent tier.
    Uses an explicit internal pool from 0 to 9999 to balance standard versus rare entities. *)
let roll_affinity_tier (rng : Random.State.t) : affinity_tier =
  let roll = Random.State.int rng 10000 in
  if roll < 6000 then E        (* 60.0% Clogged meridians / Untalented *)
  else if roll < 8500 then D   (* 25.0% Low-grade mortal baseline *)
  else if roll < 9500 then C   (* 10.0% Ordinary common cultivator *)
  else if roll < 9850 then B   (*  3.5% Outer sect core disciple *)
  else if roll < 9960 then A   (*  1.1% Inner sect genius talent *)
  else if roll < 9990 then S   (*  0.3% Heavenly Dao spirit root *)
  else if roll < 9998 then SS  (*  0.08% Transcendent lineage anomaly *)
  else SSS                     (*  0.02% Primordial sovereign reincarnation *)

(** Iterates over every valid Qi element ID globally present in the world configuration,
    independently mapping each to a rolled raw affinity structure. *)
let generate_raw_talents (rng : Random.State.t) (total_elements : int) : qi_affinity list =
  List.init total_elements (fun id ->
    { qi_id = id; tier = roll_affinity_tier rng }
  )

(** Generates a complete cultivator entity profile using a single deterministic seed value.
    Returns: (Physical Stats, List of raw structural talents, Compiled runtime multiplier lookup array) *)
let generate_cultivator (seed : int) (total_elements : int) : stats * qi_affinity list * float array =
  let rng = Random.State.make [| seed |] in
  
  (* Threading the initialized RNG instance handles sequential evaluation cleanly *)
  let stats = 
    let roll_stat () = 
      (Random.State.int rng 33 + Random.State.int rng 33 + Random.State.int rng 34)
    in
    {
      strength = roll_stat ();
      stamina = roll_stat ();
      speed = roll_stat ();
      intelligence = roll_stat ();
      wisdom = roll_stat ();
      creativity = roll_stat ();
      restraint = roll_stat ();
    }
  in
  
  let raw_talents = generate_raw_talents rng total_elements in
  let runtime_multipliers = Cultivation.Qi_ranks.compile_individual_affinities total_elements raw_talents in
  
  (stats, raw_talents, runtime_multipliers)