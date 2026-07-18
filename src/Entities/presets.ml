open Core.Types


let selection_presets : preset_character array = [|
  {
    input_name = "Miku Hatsune";
    starting_rank = 5;
    forced_stats = {
      strength = 140; stamina = 450; speed = 560; 
      intelligence = 650; wisdom = 400; creativity = 650; restraint = 350;
    };
    qi_setup = {
      custom_technique_name = "Song of Divine Creation Sound Qi";
      { qi_id = 27; tier = SSS }; (* Peak Sound Law Affinity *)
      { qi_id = 6;  tier = S   }; (* Transcendent Lightning Root *)
    };
  }
  {

  }
|]