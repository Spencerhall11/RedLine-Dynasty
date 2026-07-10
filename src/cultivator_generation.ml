(*cultivator generator*)

type stats = {
  strength: int;
  stamina: int;
  speed: int;
  intelligence: int;
  wisdom: int;
  creativity: int;
  restraint: int;
}

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