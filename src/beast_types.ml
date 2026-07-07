open Types

let iron_flesh_tiger : species_template =
  {
    species_name = "Iron-Flesh Tiger";
    max_strength = 85;
    max_stamina = 95;
    max_speed = 55;
    max_intelligence = 80;
    max_wisdom = 50;
    max_creativity = 40;
    max_restraint = 75;
    mutation_tolerance = 0.55;
    core_crash_chance = 0.005;
    core_crash_max_bonus = 40;
    perfect_specimen_max_bonus = 30;
    spawn_weights =
      [
        ( Forest_Cell,
          [
            ("Standard Wood Qi", 50.0);
            ("Standard Earth Qi", 24.5);
            ("Standard Water Qi", 24.5);
            ("Random Qi Variant", 1.0);
          ] );
        ( Industrial_Cell,
          [
            ("Standard Metal Qi", 50.0);
            ("Standard Earth Qi", 24.5);
            ("Standard Lightning Qi", 24.5);
            ("Random Qi Variant", 1.0);
          ] );
        ( Coastal_Cell,
          [
            ("Standard Water Qi", 50.0);
            ("Standard Earth Qi", 24.5);
            ("Standard Wind Qi", 24.5);
            ("Random Qi Variant", 1.0);
          ] );
        ( Desert_Cell,
          [
            ("Standard Fire Qi", 50.0);
            ("Standard Earth Qi", 24.5);
            ("Standard Wind Qi", 24.5);
            ("Random Qi Variant", 1.0);
          ] );
        ( Plains_Cell,
          [
            ("Standard Earth Qi", 50.0);
            ("Standard Wind Qi", 24.5);
            ("Standard Water Qi", 24.5);
            ("Random Qi Variant", 1.0);
          ] );
        ( Mountain_Cell,
          [
            ("Standard Wind Qi", 50.0);
            ("Standard Earth Qi", 24.5);
            ("Standard Lightning Qi", 24.5);
            ("Random Qi Variant", 1.0);
          ] );
        ( Mountain_Peak_Cell,
          [
            ("Standard Lightning Qi", 75.0);
            ("Standard Earth Qi", 12.0);
            ("Standard Wind Qi", 12.0);
            ("Random Qi Variant", 1.0);
          ] );
      ];
    synergy_table =
      [
        {
          stat_name = "stamina";
          synergy_element = "Standard Wood Qi";
          synergy_name = "Over-growth Loop";
          synergy_desc =
            "Anchors on tile, strips territory to fuel growth, raises an \
             impenetrable iron-root wall blocking borders and roads.";
        };
        {
          stat_name = "speed";
          synergy_element = "Standard Fire Qi";
          synergy_name = "Burning Heart";
          synergy_desc =
            "Speed far exceeds normal limits; surrounding environment steadily \
             heats, risking melt-related hazards.";
        };
        {
          stat_name = "strength";
          synergy_element = "Standard Metal Qi";
          synergy_name = "Gilded Guillotine";
          synergy_desc =
            "Claws crystallize into self-sharpening alloy; ignores armor \
             layers, shreds high-defense targets and gear durability.";
        };
        {
          stat_name = "restraint";
          synergy_element = "Standard Earth Qi";
          synergy_name = "Tectonic Tap-Root";
          synergy_desc =
            "Immovable anchor at a chokepoint; absorbs tactical spells and \
             traps army movement until erased.";
        };
        {
          stat_name = "wisdom";
          synergy_element = "Standard Water Qi";
          synergy_name = "Saturated Reservoir";
          synergy_desc =
            "Automated hazard filter; purifies zone crises, gains +10% max \
             health per hazard neutralized.";
        };
        {
          stat_name = "speed";
          synergy_element = "Standard Lightning Qi";
          synergy_name = "Volt-Flash Stalker";
          synergy_desc =
            "Bypasses terrestrial friction at avian velocity; blitzes borders \
             and backline logistics, drops aggro instantly.";
        };
        {
          stat_name = "creativity";
          synergy_element = "Standard Wind Qi";
          synergy_name = "Vortex Engine";
          synergy_desc =
            "Spiraling vortex route vacuums loose loot and resources; becomes \
             a high-value target for factional raids.";
        };
        {
          stat_name = "restraint";
          synergy_element = "Standard Ice Qi";
          synergy_name = "Cryo-Stasis Core";
          synergy_desc =
            "Localized clock-freeze zone; freezes units on the tile for 3 \
             macro-turns unless overwritten by a high-tier Fire artifact.";
        };
      ];
    transformation_reqs =
      Some
        {
          min_qi_tier = 7;
          min_intelligence = 75;
          min_memory_depth = 4;
          required_skill = "Human-Form Compilation";
          min_mastery = 0.9;
          base_success_chance = 0.03;
        };
  }