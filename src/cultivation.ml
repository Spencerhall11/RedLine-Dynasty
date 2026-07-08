open Types


type rank_value = int

let get_tier (rank : rank_value) : int = ((rank - 1)/3 ) + 1
let get_stage_idx (rank : rank_int) : int = (rank - 1) mod 3