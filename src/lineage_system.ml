
(*define heritable traits*)
type trait ={
    name : string
    potency : float;
}

(*baseline inheritance is from both parents and prune below threshold*)
let prune_threshold = 0.05

let merge_traits (p1_traits : trait list) (p2_traits : trait list) : trait list = 
    (*reinforce common traits*)
    let process_trait (t : trait) (other_traits : trait list) : trait =
    match List.find_opt (fun x -> x.name = t.name) other_traits with
    | Some match_trait ->
        (*reinforce, take max then add slight boost*)
        { name = t.name; potency = Float.max t.potency match_trait.potency *. 1.1}
    | None ->
        (*decay unique traits*)
        { t with potency = t.potency *. 0.5}
in

(*process for both parents*)
let p1_processed = List.map (fun t-> process_trait t p2_traits) p1_traits in
let p2_processed = List.map (fun t-> process_trait t p1_traits) p2_traits in

(*combine and filter pruned*)
let comined = p1_processed @ p2_processed in

let unique = List.fold_left (fun acc t ->
    match List.find_opt (fun x -> x.name = t.name) acc with
    | Some existing -> 
        if t.potency > existing.potency then
          t :: List.filter (fun x -> x.name <> t.name) acc
        else acc
    | None -> t :: acc
  ) [] combined in

List.filter (fun t -> t.potency >= prune_threshold) unique