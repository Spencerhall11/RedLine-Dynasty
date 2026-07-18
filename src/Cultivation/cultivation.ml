open Core.Types


let rank = Qi_rank
let get_tier (rank : rank_value) : int = ((rank - 1) / 3) + 1
let get_stage_idx (rank : rank_value) : int = (rank - 1) mod 3

let qi_types = Qi_types.qi_types