open Core.Types

let string_of_affinity = function
  | E   -> "E"
  | D   -> "D"
  | C   -> "C"
  | B   -> "B"
  | A   -> "A"
  | S   -> "S"
  | SS  -> "SS"
  | SSS -> "SSS"

let affinity_of_string = function
  | "E"   | "e"   -> Some E
  | "D"   | "d"   -> Some D
  | "C"   | "c"   -> Some C
  | "B"   | "b"   -> Some B
  | "A"   | "a"   -> Some A
  | "S"   | "s"   -> Some S
  | "SS"  | "ss"  -> Some SS
  | "SSS" | "sss" -> Some SSS
  | _             -> None

let affinity_multiplier = function
  | E   -> 0.5   (* Trash Talent: Clogged meridians, massive Qi dispersion *)
  | D   -> 0.8   (* Mediocre: Can slowly accumulate energy *)
  | C   -> 1.0   (* Ordinary: The baseline norm for common cultivators *)
  | B   -> 1.4   (* Inner Sect Potential: Noticeably faster cycling *)
  | A   -> 2.0   (* Core Disciple Genius: Natural resonance with elements *)
  | S   -> 3.5   (* Chosen Heavenly Body: Inherited laws, rapid insight *)
  | SS  -> 6.0   (* Mythical Asura / Ancient Reincarnation *)
  | SSS -> 12.0  (* Primordial Chaos Monarch: Complete absolute authority *)

let compile_individual_affinities (total_elements : int) (overrides : qi_affinity list) : float array =
  (* Default unlisted elements to baseline E-Tier *)
  let lookup_table = Array.make total_elements (affinity_multiplier E) in
  
  List.iter (fun (aff : qi_affinity) ->
    if aff.qi_id >= 0 && aff.qi_id < total_elements then
      lookup_table.(aff.qi_id) <- affinity_multiplier aff.tier
  ) overrides;
  
  lookup_table

let breakthrough_success_modifier = function
  | E   -> -0.15 (* Hard bottleneck *)
  | D   -> -0.05
  | C   -> 0.0
  | B   -> 0.05
  | A   -> 0.15
  | S   -> 0.35  (* Breakthroughs are trivial breakthroughs *)
  | SS  -> 0.60
  | SSS -> 1.00  (* Smooth sailing across the board *)