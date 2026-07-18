open Core.Types

let mutate (env : environmental_data) (lineage : lineage) : lineage =
  (* Baseline Drift (Entropy) 
     We map over the existing traits and apply a small random delta to potency. *)
  let drifted = 
    TraitMap.filter_map (fun _trait_name trait_info ->
      let roll = Random.float 1.0 in
      if roll < 0.05 then 
        (* 5% chance: Trait decays slightly *)
        let new_potency = trait_info.potency -. 0.05 in
        if new_potency <= 0.01 then None (* Trait drifts into extinction *)
        else Some { potency = new_potency }
      else if roll < 0.08 then 
        (* 3% chance: Trait intensifies naturally *)
        let new_potency = Float.min 1.0 (trait_info.potency +. 0.03) in
        Some { potency = new_potency }
      else
        (* 92% chance: Trait remains stable *)
        Some trait_info
    ) lineage
  in

  (* Environmental Injection: Force an affinity mutation *)
  (* If concentration is 0.9, there's a 90% chance to inject/reinforce the local element *)
  if Random.float 1.0 < env.qi_concentration then
    let affinity_trait = env.element_affinity ^ "_Affinity" in
    let updated_lineage = TraitMap.update affinity_trait (fun existing -> 
      match existing with
      | Some trait_info -> 
          (* Reinforce existing affinity up to a cap *)
          Some { potency = Float.min 1.0 (trait_info.potency +. 0.1) }
      | None -> 
          (* Manifest brand new affinity trait due to high environmental exposure. *)
          Some { potency = 0.1 } 
    ) drifted in
    updated_lineage
  else
    drifted