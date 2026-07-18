open Core.Types

let registry_array = Array.of_list Qi_types.qi_types 

let registry_map = 
  let h = Hashtbl.create 32 in
  List.iter (fun q -> Hashtbl.add h q.name q) Qi_types.qi_types;
  h

let get_by_name name = Hashtbl.find_opt registry_map name