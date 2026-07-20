open Raylib
open Core.Types

(* --- AESTHETIC TELEMETRY CONFIGURATION --- *)
let color_bg = Color.create 10 2 2 255          (* Velvet Tactical Blackout *)
let color_text_cyan = Color.create 0 200 200 255 (* Terminal Telemetry Cyan *)
let color_text_dim = Color.create 0 130 130 255  (* Muted Data Telemetry *)
let color_highlight = Color.create 255 255 255 100

let get_cell_color = function
  | Forest_Cell -> Color.create 15 80 45 255
  | Plains_Cell -> Color.create 110 95 35 255
  | Desert_Cell -> Color.create 140 70 20 255
  | Mountain_Cell -> Color.create 75 75 85 255
  | Mountain_Peak_Cell -> Color.create 120 120 135 255
  | Glacial_Cell -> Color.create 40 110 140 255
  | Ice_Cell -> Color.create 160 210 230 255
  | Coastal_Cell -> Color.create 25 65 95 255
  | Ocean_Cell -> Color.create 10 30 60 255
  | Industrial_Cell -> Color.create 90 40 40 255
  | Technical_Citadel_Cell -> Color.create 0 100 120 255
  | Blood_Stained_Battlefield_Cell -> Color.create 150 10 20 255

let string_of_cell_type = function
  | Forest_Cell -> "Forest"
  | Plains_Cell -> "Plains"
  | Desert_Cell -> "Desert"
  | Mountain_Cell -> "Mountain"
  | Mountain_Peak_Cell -> "Mountain Peak"
  | Glacial_Cell -> "Glacial"
  | Ice_Cell -> "Ice Shelf"
  | Coastal_Cell -> "Coastline"
  | Ocean_Cell -> "Deep Ocean"
  | Industrial_Cell -> "Industrial Sector"
  | Technical_Citadel_Cell -> "Technical Citadel"
  | Blood_Stained_Battlefield_Cell -> "Crimson Battlefield"

(* --- MAIN INTERACTIVE LOOP --- *)
let rec main_loop tile_list tile_size camera_offset zoom =
  if window_should_close () then ()
  else begin
    (* 1. Fullscreen Runtime Toggle (F11) *)
    if is_key_pressed Key.F11 then toggle_fullscreen ();

    (* 2. Handle Zoom Inputs (Keyboard Q/E + Mouse Wheel) *)
    let zoom_speed = 1.04 in
    let kb_zoom = 
      if is_key_down Key.E then zoom *. zoom_speed
      else if is_key_down Key.Q then zoom /. zoom_speed
      else zoom
    in
    let wheel_move = get_mouse_wheel_move () in
    let next_zoom = 
      if wheel_move > 0.0 then kb_zoom *. 1.10
      else if wheel_move < 0.0 then kb_zoom /. 1.10
      else kb_zoom
    in
    let next_zoom = max 0.02 (min next_zoom 40.0) in

    (* 3. Handle Pan Inputs (Keyboard WASD/Arrows + Mouse Left Drag) *)
    let scroll_speed = int_of_float (16.0 /. next_zoom) in
    let (ox, oy) = camera_offset in
    
    let ox = if is_key_down Key.Left || is_key_down Key.A then ox + scroll_speed else ox in
    let ox = if is_key_down Key.Right || is_key_down Key.D then ox - scroll_speed else ox in
    let oy = if is_key_down Key.Up || is_key_down Key.W then oy + scroll_speed else oy in
    let oy = if is_key_down Key.Down || is_key_down Key.S then oy - scroll_speed else oy in
    
    let (final_ox, final_oy) = 
      if is_mouse_button_down MouseButton.Left then
        let delta = get_mouse_delta () in
        (ox + int_of_float (Vector2.x delta), oy + int_of_float (Vector2.y delta))
      else 
        (ox, oy)
    in
    let next_offset = (final_ox, final_oy) in

    (* --- RENDERING CYCLE --- *)
    begin_drawing ();
    clear_background color_bg;

    (* Dynamically pull display sizes to compute accurate equirectangular projections *)
    let sw = float_of_int (get_screen_width ()) in
    let sh = float_of_int (get_screen_height ()) in
    let mouse_pos = get_mouse_position () in
    let found_hover = ref None in

    (* Render H3 Registry Nodes *)
    List.iter (fun tile ->
      let norm_x = (tile.longitude +. 180.0) /. 360.0 in
      let norm_y = (90.0 -. tile.latitude) /. 180.0 in

      let px = int_of_float ((norm_x *. sw *. next_zoom) +. float_of_int final_ox) in
      let py = int_of_float ((norm_y *. sh *. next_zoom) +. float_of_int final_oy) in
      let sz = max 2 (int_of_float (float_of_int tile_size *. next_zoom)) in

      if px > -sz && px < get_screen_width () && py > -sz && py < get_screen_height () then begin
        let cell_color = get_cell_color tile.cell_type in
        draw_rectangle px py (sz - 1) (sz - 1) cell_color;

        let mx = int_of_float (Vector2.x mouse_pos) in
        let my = int_of_float (Vector2.y mouse_pos) in
        if mx >= px && mx < px + sz && my >= py && my < py + sz then
          found_hover := Some (tile, px, py, sz)
      end
    ) tile_list;

    (* Overlay HUD System Analytics *)
    begin match !found_hover with
    | Some (t, px, py, sz) ->
        draw_rectangle_lines px py sz sz color_highlight;
        
        draw_rectangle 10 10 440 165 (Color.create 5 1 1 230);
        draw_text "SYS_INTERFACE: REDLINE_GEOSPATIAL_H3" 20 20 14 color_text_cyan;
        draw_text (Printf.sprintf "HEX ID  : %s" t.tile_id) 20 45 12 color_text_cyan;
        draw_text (Printf.sprintf "PROVINCE: %s" t.province_id) 20 65 12 color_text_cyan;
        draw_text (Printf.sprintf "BIOME   : %s" (string_of_cell_type t.cell_type)) 20 85 12 color_text_cyan;
        draw_text (Printf.sprintf "GEO-LOC : LAT %.4f / LNG %.4f" t.latitude t.longitude) 20 105 12 color_text_cyan;
        
        let geo_context = 
          match Hashtbl.find_opt Geography.province_registry t.province_id with
          | Some prov -> Printf.sprintf "SOVEREIGN NID: %s (%.1f sq_km)" prov.nation_id prov.area_sq_km
          | None -> "SOVEREIGN NID: UNALIGNED_ZONE"
        in
        draw_text geo_context 20 130 12 color_text_dim
    | None ->
        draw_rectangle 10 10 440 65 (Color.create 5 1 1 230);
        draw_text "SYS_INTERFACE: REDLINE_GEOSPATIAL_H3" 20 20 14 color_text_cyan;
        draw_text "CONTROLS: WASD/Drag to Pan | Q/E/Wheel to Zoom | F11 Fullscreen" 20 40 11 color_text_dim
    end;

    let fps_text = Printf.sprintf "TERM_FPS: %d" (get_fps ()) in
    draw_text fps_text (get_screen_width () - 120) 20 12 color_text_cyan;

    end_drawing ();
    main_loop tile_list tile_size next_offset next_zoom
  end

let () =
  (* Configure window to allow normal OS resizing/maximizing without lockups *)
  set_config_flags ConfigFlags.window_resizable;

  (* Fire up a generous standard desktop window size (e.g., 1600x900 or 1280x720) *)
  init_window 1600 900 "REDLINE-DYNASTY // GLOBAL_STRATEGIC_VIEWER";
  set_target_fps 60;

  Printf.printf "[SYSTEM]: Parsing master datasets into global registries...\n%!";
  Geography.bootstrap_world_map 
    ~nations_path:"data/nations.csv"
    ~provinces_path:"data/provinces.csv"
    ~adjacency_path:"data/province_adjacency.csv"
    ~tiles_path:"data/tiles.csv"
    ~centers_path:"data/population_centers.csv";

  let registered_tiles = 
    Hashtbl.fold (fun _ tile acc -> tile :: acc) Geography.tile_registry [] 
  in
  Printf.printf "[SYSTEM]: Ingestion Complete. Rendering %d tiles.\n%!" (List.length registered_tiles);

  (* Launch loop. The projection math inside main_loop now safely recalculates 
     automatically if you maximize or manually pull the window borders! *)
  main_loop registered_tiles 6 (100, 100) 1.0;
  close_window ()