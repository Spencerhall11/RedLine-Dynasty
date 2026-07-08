
(*Define outcome of the ability*)
type effect = 
    | Damage of float
    | StatusEffect of string * int
    | Overclock of float (*what it does to the caster*)

(*Each technique has pre-requisites*)
type technique ={
    name : string;
    cost : float; (*Qi cost*)
    execution_logic : unit -> effect; (*what to run*)
}

(*validate against pool then execute*)