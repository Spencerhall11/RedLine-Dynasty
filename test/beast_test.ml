open Types
open Logic

let tiger = beast_types.iron_flesh_tiger

(* Your real assets folder. Backslashes need doubling in an OCaml string. *)
let assets_folder =
  "C:\\Users\\spenc\\OneDrive\\Documents\\GitHub\\CS350\\RedLine-Dynasty\\assets\\beasts\\"

(* Short token used in asset filenames, per element. Extend as needed. *)
let short_name (element : element_id) : string =
  match element with
  | "Standard Wood Qi" -> "Wood"
  | "Standard Water Qi" -> "Water"
  | "Standard Fire Qi" -> "Fire"
  | "Standard Earth Qi" -> "Earth"
  | "Standard Metal Qi" -> "Metal"
  | "Standard Wind Qi" -> "Wind"
  | "Standard Lightning Qi" -> "Lightning"
  | other -> other (* fallback: use the raw element string *)

let asset_filename_for (species_name : string) (primary : element_id)
    (secondary : element_id option) : string =
  match secondary with
  | Some sec -> Printf.sprintf "%s-%s_%s.png" (short_name primary) (short_name sec) species_name
  | None -> Printf.sprintf "%s_%s.png" (short_name primary) species_name

(* Forces BOTH elements instead of rolling from a biome -- bypasses
   roll_injected_element entirely, just for this test. The real
   generation pipeline (generate_beast/attempt_spawn) is untouched;
   secondary_element stays None there until a real roll mechanism
   for it is designed. *)
let assemble_forced (id : string) (t : species_template) (disp : disposition)
    (location : string) (primary : element_id) (secondary : element_id option)
    (stats : beast_attributes) : beast =
  {
    beast_id = id;
    species = t;
    personality = disp;
    stats;
    injected_element = primary;
    secondary_element = secondary;
    active_synergy = find_synergy t stats primary;
    sentience = derive_sentience stats;
    role = Transient_Wildlife;
    is_sentient = true;
    qi_tier = 0;
    skill_library = [];
    sustenance = Predation;
    hunger = 0.0;
    location;
    sex = (if Random.bool () then Male else Female);
    reproductive_status = Not_Pregnant;
  }

let () =
  Random.self_init ();
  let stats = resolve_stats tiger in
  if not (is_viable stats) then
    print_endline "Forced tiger was stillborn (a stat rolled 0) -- no asset assigned, as designed."
  else begin
    let b =
      assemble_forced "forced-wood-water" tiger Calculating "region-1"
        "Standard Wood Qi" (Some "Standard Water Qi") stats
    in
    Printf.printf "STR=%d STA=%d SPD=%d INT=%d WIS=%d CRE=%d RES=%d\n"
      b.stats.strength b.stats.stamina b.stats.speed b.stats.intelligence
      b.stats.wisdom b.stats.creativity b.stats.restraint;
    Printf.printf "Primary element: %s\n" b.injected_element;
    Printf.printf "Secondary element: %s\n"
      (match b.secondary_element with Some e -> e | None -> "(none)");
    (match b.active_synergy with
     | Some s -> Printf.printf "Synergy: %s\n" s.synergy_name
     | None -> print_endline "Synergy: none");
    let filename = asset_filename_for b.species.species_name b.injected_element b.secondary_element in
    let full_path = assets_folder ^ filename in
    Printf.printf "Asset path: %s\n" full_path;
    Printf.printf "File exists on this machine: %b\n" (Sys.file_exists full_path)
  end