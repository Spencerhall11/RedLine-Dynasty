(*baseline potential for humans*)

type civilian_node = {
    population_Coint : int;
    latent_potential_index: float; (*chance of awakening as a cultivator for a random civi*)
}

type cultivator_entity = {
    id: int;
    base_stats: base_stats;
    techniques: subroutine_list;
    status: status_flag;
}

(*Instante only when needed*)
let recruit (node: civilian_node) : cultivator_entity option =
    if Random.float 1.0 < node.latent_potential_index then
        Some (instantiate_cultivator_from_seed node)
    else None
