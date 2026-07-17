let bg_color = Color.create 15 15 20 255      (* Dark "Terminal" Background *)
let accent_red = Color.create 180 30 30 255    (* Deep Red for Land *)
let accent_blue = Color.create 20 30 70 255    (* Bruised Navy for Water *)

let init_ui () =
  init_window 1280 720 "RedLine Dynasty - System Terminal";
  set_target_fps 60

let draw_frame () =
  begin_drawing ();
  clear_background bg_color;
  
  (* map tile logic will go here *)
  draw_text "SYSTEM READY: AWAITING WORLD_STATE" 20 20 20 Color.white;
  
  end_drawing ()

