(*define environment influence*)
type environmental_data = {
  element_affinity: string; (* e.g., "Ice" *)
  qi_concentration: float;  (* 0.0 to 1.0 scale *)
}

let mutate (env : environmental_data) (lineage : Lineage.lineage) : Lineage.lineage =
    (* Baseline Drift (Entropy) *)
  let drifted = ... (* your existing drift logic *) in

  (* Environmental Injection: Force an affinity mutation *)
  (* If concentration is 0.9, there's a 90% chance to inject/reinforce the local element *)
  if Random.float 1.0 < env.qi_concentration then
    let affinity_trait = env.element_affinity ^ "_Affinity" in
    let updated_lineage = Lineage.TraitMap.update affinity_trait (fun _ -> 
      Some { potency = 1.0 } (* Guaranteed or heavily reinforced *)
    ) drifted in
    updated_lineage
  else
    drifted