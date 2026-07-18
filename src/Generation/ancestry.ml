open Core.Types

let derive_child_ancestry (parent1 : ancestry) (parent2 : ancestry) : ancestry =
    (* Logic for combining phyla or flesh-types *)
    match parent1, parent2 with
    | Human, Human -> Human
    | Human, Hybrid(p, s) -> Hybrid(p, s)
    | Hybrid(p1, s1), Hybrid(p2, s2) -> 
        
        Hybrid(p1, s1) 
    | _, _ -> (* Handle Sovereign_Flesh overrides *)
        parent1