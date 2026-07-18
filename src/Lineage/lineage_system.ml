open Core.Types

let merge (l1 : lineage) (l2 : lineage) : lineage =
  TraitMap.merge (fun _trait_name opt_t1 opt_t2 ->
    match opt_t1, opt_t2 with
    | Some t1, Some t2 ->
        (* Both lineages have the trait: average out their potency with a slight boost *)
        let new_potency = Float.min 1.0 ((t1.potency +. t2.potency) /. 2.0 +. 0.05) in
        Some { potency = new_potency }
    | Some t1, None ->
        (* Dilute trait potency if only one parent passes it on *)
        Some { potency = t1.potency *. 0.5 }
    | None, Some t2 ->
        (* Dilute trait potency if only one parent passes it on *)
        Some { potency = t2.potency *. 0.5 }
    | None, None -> 
        None
  ) l1 l2

let prune_extinct (l : lineage) : lineage =
  TraitMap.filter (fun _trait_name trait_info ->
    trait_info.potency > 0.01
  ) l