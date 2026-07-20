open Core.Types

module Qi_ranks = Qi_ranks

(* Mathematical lookups wrapping the rank_value integer primitives *)
let get_tier (rank : rank_value) : int = ((rank - 1) / 3) + 1
let get_stage_idx (rank : rank_value) : int = (rank - 1) mod 3

(* This binds your engine lookup directly to your static data registry module *)
let qi_types = Qi_types.qi_types