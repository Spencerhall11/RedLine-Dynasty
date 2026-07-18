open Types
(* Open the primitive translation combinators *)
open Ppx_yojson_conv_lib.Yojson_conv.Primitives

let presets_path = "data/presets.json"

(** Reads data/presets.json and parses elements into a native preset_character array *)
let load_presets () : preset_character array =
  try
    let json_tree = Yojson.Safe.from_file presets_path in
    (* Use the list combinator to wrap the base type parser *)
    let instances_list = list_of_yojson Types.preset_character_of_yojson json_tree in
    Array.of_list instances_list
  with
  | Sys_error msg ->
      Printf.eprintf "[ERROR] Presets asset target missing at %s: %s\n" presets_path msg;
      [||]
  | Yojson.Json_error msg ->
      Printf.eprintf "[ERROR] Presets data syntax mismatch: %s\n" msg;
      [||]
  | e ->
      Printf.eprintf "[ERROR] Failed processing preset configuration payload: %s\n" (Printexc.to_string e);
      [||]