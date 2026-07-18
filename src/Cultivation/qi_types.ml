(*types of Qi*)
open Core.Types

(*full list of the types based on category*)
let qi_types = [
  {id = 1; name = "Fire"; category = Foundational; stability_base = 0.8; spawn_weight = 1.0};
  {id = 2; name = "Water"; category = Foundational; stability_base = 0.8; spawn_weight = 1.0};
  {id = 3; name = "Earth"; category = Foundational; stability_base = 0.8; spawn_weight = 1.0};
  {id = 4; name = "Wood"; category = Foundational; stability_base = 0.8; spawn_weight = 1.0};
  {id = 5; name = "Metal"; category = Foundational; stability_base = 0.8; spawn_weight = 1.0};
  {id = 6; name = "Lightning"; category = Foundational; stability_base = 0.8; spawn_weight = 1.0};
  {id = 7; name = "Wind"; category = Foundational; stability_base = 0.8; spawn_weight = 1.0};
  {id = 8; name = "Ice"; category = Foundational; stability_base = 0.8; spawn_weight = 1.0};
  {id = 9; name = "Spear"; category = Abstract; stability_base = 0.8; spawn_weight = 1.0}; 
  {id = 10; name = "Poison"; category = Foundational; stability_base = 0.8; spawn_weight = 1.0};
  {id = 11; name = "Magma"; category = Foundational; stability_base = 0.8; spawn_weight = 1.0};
  {id = 12; name = "Blood"; category = Biological; stability_base = 0.8; spawn_weight = 1.0};
  {id = 13; name = "Yin"; category = Esoteric; stability_base = 0.8; spawn_weight = 1.0};
  {id = 14; name = "Yang"; category = Esoteric; stability_base = 0.8; spawn_weight = 1.0};
  {id = 15; name = "Life"; category = Biological; stability_base = 0.8; spawn_weight = 1.0};
  {id = 16; name = "Death"; category = Biological; stability_base = 0.8; spawn_weight = 1.0};
  {id = 17; name = "Karma"; category = Esoteric; stability_base = 0.8; spawn_weight = 1.0};
  {id = 18; name = "Space"; category = Esoteric; stability_base = 0.8; spawn_weight = 1.0};
  {id = 19; name = "Time"; category = Esoteric; stability_base = 0.8; spawn_weight = 1.0};
  {id = 20; name = "Fate"; category = Esoteric; stability_base = 0.8; spawn_weight = 1.0};
  {id = 21; name = "Beast"; category = Biological; stability_base = 0.8; spawn_weight = 1.0};
  {id = 22; name = "Deviant/Demonic"; category = Biological; stability_base = 0.8; spawn_weight = 1.0};
  {id = 23; name = "Sword"; category = Abstract; stability_base = 0.8; spawn_weight = 1.0};
  {id = 24; name = "Blade"; category = Abstract; stability_base = 0.8; spawn_weight = 1.0};
  {id = 25; name = "Immortal"; category = Abstract; stability_base = 0.8; spawn_weight = 1.0};
  {id = 26; name = "Solar"; category = Abstract; stability_base = 0.8; spawn_weight = 1.0};
  {id = 27; name = "Sound"; category = Abstract; stability_base = 0.8; spawn_weight = 1.0};
  {id = 28; name = "Star"; category = Abstract; stability_base = 0.8; spawn_weight = 1.0};
  {id = 29; name = "Myriad Illusion"; category = Abstract; stability_base = 0.8; spawn_weight = 1.0};
  {id = 30; name = "Spiritual"; category = Abstract; stability_base = 0.8; spawn_weight = 1.0};
]