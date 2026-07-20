open Raylib
open Core.Types
open Cultivation

(* Tactical Palette Adjustments *)
let color_bg = Color.create 10 2 2 255
let color_text_cyan = Color.create 0 220 220 255
let color_panel_bg = Color.create 0 0 0 200

(* Maps structural terrain types to thematic luminescent colors *)
let color_of_cell = function
  | Forest_Cell -> Color.create 15 50 20 255
  | Plains_Cell -> Color.create 35 45 15 255
  | Desert_Cell -> Color.create 70 50 15 255
  | Mountain_Cell -> Color.create 40 35 35 255
  | Glacial_Cell | Ice_Cell -> Color.create 20 55 75 255
  | Coastal_Cell -> Color.create 15 35 60 255
  | Industrial_Cell -> Color.create 50 25 20 255
  | Mountain_Peak_Cell -> Color.create 75 70 70 255
  | Ocean_Cell -> Color.create 5 15 35 255
  | Blood_Stained_Battlefield_Cell -> Color.create 90 10 15 255
  | Technical_Citadel_Cell -> Color.create 25 70 80 255

let map_width = 40
let map_height = 30
let tile_size = 24.0

(* Generates geography mapping directly to your types *)
let build_world_grid () =
  Array.init map_width (fun x ->
    Array.init map_height (fun y ->
      let d = (sin (float_of_int x *. 0.1) *. cos (float_of_int y *. 0.1) +. 1.0) /. 2.0 in
      let cell = 
        if d > 0.85 then Technical_Citadel_Cell
        else if d > 0.70 then Mountain_Peak_Cell
        else if d > 0.55 then Forest_Cell
        else if d > 0.35 then Plains_Cell
        else Desert_Cell
      in
      { tile_id = Printf.sprintf "T_%d_%d" x y;
        province_id = Printf.sprintf "P_%d" (x / 5);
        cell_type = cell;
        latitude = float_of_int y;
        longitude = float_of_int x; }
    )
  )

let rec draw_loop grid mock_affinities =
  if window_should_close () then ()
  else begin
    let mouse_pos = get_mouse_position () in
    let mx = int_of_float (Vector2.x mouse_pos) / int_of_float tile_size in
    let my = int_of_float (Vector2.y mouse_pos) / int_of_float tile_size in

    begin_drawing ();
    clear_background color_bg;

    (* Draw base telemetry grid layout *)
    for x = 0 to map_width - 1 do
      for y = 0 to map_height - 1 do
        let tile = grid.(x).(y) in
        let px = x * int_of_float tile_size in
        let py = y * int_of_float tile_size in
        
        (* Highlight current hovered cell chassis *)
        let base_color = color_of_cell tile.cell_type in
        let draw_color = 
          if x = mx && y = my then Color.create (Color.r base_color + 40) (Color.g base_color + 40) (Color.b base_color + 40) 255
          else base_color
        in
        draw_rectangle px py (int_of_float tile_size - 1) (int_of_float tile_size - 1) draw_color;
      done
    done;

    (* Overlay Telemetry Panel *)
    draw_rectangle 10 10 320 220 color_panel_bg;
    draw_text "SYS_INTERFACE: RADAR_RAD" 20 20 16 color_text_cyan;
    
    if mx >= 0 && mx < map_width && my >= 0 && my < map_height then begin
      let target_tile = grid.(mx).(my) in
      let cell_name = match target_tile.cell_type with
        | Forest_Cell -> "Forest Node"
        | Plains_Cell -> "Plains Matrix"
        | Desert_Cell -> "Desert Wastes"
        | Mountain_Peak_Cell -> "High Peak Spire"
        | Technical_Citadel_Cell -> "Citadel Server Core"
        | _ -> "Unknown Grid Sector"
      in
      draw_text (Printf.sprintf "SECTOR: %s" cell_name) 20 50 13 color_text_cyan;
      draw_text (Printf.sprintf "COORD: X:%d Y:%d" mx my) 20 70 12 color_text_cyan;
    end;

    (* Render live character affinity multipliers parsed out from your module *)
    draw_text "DISCIPLE PRIMORDIAL AFFINITIES:" 20 105 12 color_text_cyan;
    Array.iteri (fun i multiplier ->
      let y_offset = 125 + (i * 15) in
      if y_offset < 220 then
        draw_text (Printf.sprintf "  ELEMENT [%d] MULTIPLIER: %.1fx" i multiplier) 20 y_offset 11 color_text_cyan
    ) mock_affinities;

    end_drawing ();
    draw_loop grid mock_affinities
  end

let () =
  init_window 1024 768 "REDLINE-DYNASTY // SYSTEM_MAP";
  set_target_fps 60;

  let grid = build_world_grid () in
  let total_elements = 5 in
  let overrides = [
    { qi_id = 0; tier = SSS };
    { qi_id = 2; tier = B }
  ] in
  let multipliers = Qi_ranks.compile_individual_affinities total_elements overrides in

  draw_loop grid multipliers;
  close_window ()