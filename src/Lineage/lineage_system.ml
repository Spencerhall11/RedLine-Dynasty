
module TraitMap = Map.Make(String)


let prune_threshold = 0.05

(*merge lines *)
let merge_lineages (p1 : lineage) (p2 : lineage) : lineage =
    (*combine parents and boost common while decaying unique*)
    let merge_func _key v1 v2 =
    match v1, v2 with
    | Some t1, Some t2 -> 
        (* Reinforce common traits: Max of both + 10% boost *)
        Some { potency = Float.max t1.potency t2.potency *. 1.1 }
    | Some t1, None -> 
        (* Decay unique traits from p1 *)
        Some { potency = t1.potency *. 0.5 }
    | None, Some t2 -> 
        (* Decay unique traits from p2 *)
        Some { potency = t2.potency *. 0.5 }
    | None, None -> None
    in

  let combined = TraitMap.merge merge_func p1 p2 in

  (*prune below threshold*)
  TraitMap.filter (fun _ t -> t.potency >= prune_threshold) combined

(*convert back to list for UI*)
let to_list (l : lineage) = 
  TraitMap.bindings l |> List.map (fun (name, data) -> (name, data.potency))
