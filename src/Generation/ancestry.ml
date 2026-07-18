open Core.Types

let derive_child_ancestry (parent1 : ancestry) (parent2 : ancestry) : ancestry =
  match parent1, parent2 with
  (* Baseline: Standard Inheritance *)
  | Human, Human -> Human
  | Human, Hybrid(phylum, sub) -> Hybrid(phylum, sub)
  | Hybrid(phylum, sub), Human -> Hybrid(phylum, sub)

  (* Complex Fusion: Combining Beast *)
  | Hybrid(p1, s1), Hybrid(p2, s2) ->
      (* Logic: If phyla match, stabilize the driver; otherwise, create a volatile hybrid *)
      if p1 = p2 then 
        Hybrid(p1, (s1 +. s2) /. 2.0) 
      else 
        Hybrid(p1, (s1 +. s2) /. 3.0) (* Complexity penalty *)

  (* Sovereign Overrides: High-tier takes priority *)
  | Sovereign_Flesh, _ -> Sovereign_Flesh
  | _, Sovereign_Flesh -> Sovereign_Flesh

  (* 4. Safety catch-all *)
  | _, _ -> parent1