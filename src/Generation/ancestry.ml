(* src/Generation/ancestry.ml *)
open Core.Types

let derive_child_ancestry (parent1 : ancestry) (parent2 : ancestry) : ancestry =
  match parent1, parent2 with
  (* 1. Sovereign Override: Absolute dominance over all other drivers *)
  | Sovereign_Flesh, _ | _, Sovereign_Flesh -> Sovereign_Flesh

  (* 2. Inhuman Overrides: Inhuman entities enforce their firmware/corruption index *)
  | Inhuman data, _ -> Inhuman({ data with corruption_idx = data.corruption_idx +. 0.05 })
  | _, Inhuman data -> Inhuman({ data with corruption_idx = data.corruption_idx +. 0.05 })

  (* 3. Standard Inheritance: Baseline biological compatibility *)
  | Human, Human -> Human
  | Human, Hybrid(phylum, sub) | Hybrid(phylum, sub), Human -> Hybrid(phylum, sub)

  (* 4. Complex Fusion: Combining Beast Stability Drivers *)
  | Hybrid(p1, s1), Hybrid(p2, s2) ->
      (* If phyla match, stabilize the driver; otherwise, create a volatile hybrid *)
      if p1 = p2 then 
        Hybrid(p1, (s1 +. s2) /. 2.0) 
      else 
        Hybrid(p1, (s1 +. s2) /. 3.0) (* Complexity penalty for mismatched hardware *)

  (* 5. Safety catch-all *)
  | _, _ -> parent1