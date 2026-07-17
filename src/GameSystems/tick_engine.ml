
module type SimulationRegistry = sig
    type entity
    val all_entities : entity list
    val update_all : entity list -> entity list
end

(*headless engine*)
let rec run_turn (entities : 'a list)(tick_func : 'a -> 'a option)(turn_count : int) = 
    (*batch process all entities*)
    let next_entities = 
        List.filter_map tick_func entities 
    in
  
    Printf.printf "Turn %d: %d entities alive.\n" turn_count (List.length next_entities);
  
    run_turn next_entities tick_func (turn_count + 1)