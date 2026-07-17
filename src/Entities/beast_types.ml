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



let blood_drinker_lion : species_template =
  {
    species_name = "Blood-Drinker Lion";
    max_strength = 100;
    max_stamina = 65;
    max_speed = 75;
    max_intelligence = 60;
    max_wisdom = 30;
    max_creativity = 90;
    max_restraint = 35;
    mutation_tolerance = 0.75;
    core_crash_chance = 0.008;
    core_crash_max_bonus = 50;
    perfect_specimen_max_bonus = 20;
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
            ("Standard Blood Qi", 24.5);
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
        ( Blood_Stained_Battlefield_Cell,
          [
            ("Standard Blood Qi", 80.0);
            ("Standard Metal Qi", 9.5);
            ("Standard Death Qi", 9.5);
            ("Random Qi Variant", 1.0);
          ] );
        ( Technical_Citadel_Cell,
          [
            ("Standard Lightning Qi", 50.0);
            ("Standard Metal Qi", 24.5);
            ("Standard Earth Qi", 24.5);
            ("Random Qi Variant", 1.0);
          ] );
      ];
    synergy_table =
      [
        {
          stat_name = "creativity";
          synergy_element = "Standard Blood Qi";
          synergy_name = "Sanguine Sculptor";
          synergy_desc =
            "Dynamically rearranges target's physical chassis into non-functional shapes. \
             Permanently reduces target entity's movement speed and inventory capacity by 50% until repaired.";
        };
        {
          stat_name = "strength";
          synergy_element = "Standard Fire Qi";
          synergy_name = "Living Flare-Core";
          synergy_desc =
            "Converts excess blood-heat into a blinding, aura-based thermal emitter. Units within 3 hexes \
             take continuous thermal-burn damage. Spikes damage output matching growth of thermal variables.";
        };
        {
          stat_name = "speed";
          synergy_element = "Standard Lightning Qi";
          synergy_name = "Volt-Claw Fencer";
          synergy_desc =
            "Overclocks predatory reflex subroutines to sub-millisecond execution speeds via high-frequency shell. \
             Forces a First_Strike_Guarantee; bypasses defensive postures to target internal Qi-vein registers.";
        };
        {
          stat_name = "strength";
          synergy_element = "Standard Metal Qi";
          synergy_name = "Gilded Guillotine";
          synergy_desc =
            "Crystallizes claw-assemblies into self-sharpening alloys for maximum armor-piercing. Kinetic impacts \
             completely ignore player energy shield items and permanently fracture gear durability.";
        };
        {
          stat_name = "restraint";
          synergy_element = "Standard Earth Qi";
          synergy_name = "Tectonic Tap-Root";
          synergy_desc =
            "Drives beast's mass deep into subterranean grid. Stays entirely stationary on hex node, blocking narrow \
             valley passes or canyon bottlenecks while leeching leyline resources from adjacent cells.";
        };
        {
          stat_name = "stamina";
          synergy_element = "Standard Wood Qi";
          synergy_name = "Over-growth Loop";
          synergy_desc =
            "Cell regeneration scripts enter an infinite loop. Consumes all available organic resources on tile to \
             feed runaway mass, blocking borders and caravan transit with thick iron-root rows.";
        };
        {
          stat_name = "speed";
          synergy_element = "Standard Wind Qi";
          synergy_name = "Vortex Engine";
          synergy_desc =
            "Generates localized micro-barometric vacuum scripts around the lion's lung array. Spirals across map nodes, \
             aggressively vacuuming up loose map drops and resource items into inventory container storage.";
        };
        {
          stat_name = "restraint";
          synergy_element = "Standard Ice Qi";
          synergy_name = "Cryo-Stasis Core";
          synergy_desc =
            "Absolute zero energy conversion. Drops all regional atomic vibration vectors during strike contact, forcing \
             a 3-turn Clock_Lock on targeted turn processing unless overwritten by high-tier Fire elements.";
        };
      ];
    transformation_reqs =
      Some
        {
          min_qi_tier = 7;
          min_intelligence = 55;
          min_memory_depth = 4;
          required_skill = "Human-Form Compilation";
          min_mastery = 0.9;
          base_success_chance = 0.03;
        };
  }



let tectonic_iron_bear : species_template =
  {
    species_name = "Tectonic Iron-Bear";
    max_strength = 110;
    max_stamina = 120;
    max_speed = 35;
    max_intelligence = 65;
    max_wisdom = 85;
    max_creativity = 30;
    max_restraint = 90;
    mutation_tolerance = 0.50;
    core_crash_chance = 0.004;
    core_crash_max_bonus = 45;
    perfect_specimen_max_bonus = 35;
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
            ("Standard Earth Qi", 60.0);
            ("Standard Wind Qi", 19.5);
            ("Standard Lightning Qi", 19.5);
            ("Random Qi Variant", 1.0);
          ] );
        ( Mountain_Peak_Cell,
          [
            ("Standard Earth Qi", 50.0);
            ("Standard Lightning Qi", 37.0);
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
          min_intelligence = 55;
          min_memory_depth = 4;
          required_skill = "Human-Form Compilation";
          min_mastery = 0.9;
          base_success_chance = 0.03;
        };
  }



let tectonic_iron_bear : species_template =
  {
    species_name = "Tectonic Iron-Bear";
    max_strength = 110;
    max_stamina = 120;
    max_speed = 35;
    max_intelligence = 65;
    max_wisdom = 85;
    max_creativity = 30;
    max_restraint = 90;
    mutation_tolerance = 0.50;
    core_crash_chance = 0.004;
    core_crash_max_bonus = 45;
    perfect_specimen_max_bonus = 35;
    spawn_weights =
      [
        ( Forest_Cell,
          [
            ("Standard Wood Qi", 50.0);
            ("Standard Earth Qi", 24.5);
            ("Standard Water Qi", 24.5);
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
            ("Standard Earth Qi", 60.0);
            ("Standard Wind Qi", 19.5);
            ("Standard Lightning Qi", 19.5);
            ("Random Qi Variant", 1.0);
          ] );
        ( Mountain_Peak_Cell,
          [
            ("Standard Earth Qi", 50.0);
            ("Standard Lightning Qi", 37.0);
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
          min_intelligence = 55;
          min_memory_depth = 4;
          required_skill = "Human-Form Compilation";
          min_mastery = 0.9;
          base_success_chance = 0.03;
        };
  }

let void_shimmer_fox : species_template =
  {
    species_name = "Void-Shimmer Fox";
    max_strength = 50;
    max_stamina = 70;
    max_speed = 130;
    max_intelligence = 70;
    max_wisdom = 60;
    max_creativity = 40;
    max_restraint = 30;
    mutation_tolerance = 0.80;
    core_crash_chance = 0.008;
    core_crash_max_bonus = 25;
    perfect_specimen_max_bonus = 30;
    spawn_weights =
      [
        ( Forest_Cell,
          [
            ("Standard Shadow Qi", 50.0);
            ("Standard Wind Qi", 24.5);
            ("Standard Wood Qi", 24.5);
            ("Random Qi Variant", 1.0);
          ] );
        ( Mountain_Cell,
          [
            ("Standard Shadow Qi", 60.0);
            ("Standard Void Qi", 24.5);
            ("Standard Earth Qi", 14.5);
            ("Random Qi Variant", 1.0);
          ] );
        ( Plains_Cell,
          [
            ("Standard Wind Qi", 50.0);
            ("Standard Shadow Qi", 24.5);
            ("Standard Earth Qi", 24.5);
            ("Random Qi Variant", 1.0);
          ] );
        ( Industrial_Cell,
          [
            ("Standard Metal Qi", 40.0);
            ("Standard Shadow Qi", 35.0);
            ("Standard Lightning Qi", 24.0);
            ("Random Qi Variant", 1.0);
          ] );
        ( Coastal_Cell,
          [
            ("Standard Water Qi", 50.0);
            ("Standard Shadow Qi", 24.5);
            ("Standard Wind Qi", 24.5);
            ("Random Qi Variant", 1.0);
          ] );
        ( Desert_Cell,
          [
            ("Standard Fire Qi", 50.0);
            ("Standard Wind Qi", 24.5);
            ("Standard Shadow Qi", 24.5);
            ("Random Qi Variant", 1.0);
          ] );
        ( Mountain_Peak_Cell,
          [
            ("Standard Void Qi", 50.0);
            ("Standard Shadow Qi", 25.0);
            ("Standard Lightning Qi", 24.0);
            ("Random Qi Variant", 1.0);
          ] );
        ( Blood_Stained_Battlefield_Cell,
          [
            ("Standard Death Qi", 45.0);
            ("Standard Shadow Qi", 40.0);
            ("Standard Blood Qi", 14.0);
            ("Random Qi Variant", 1.0);
          ] );
      ];
    synergy_table =
      [
        {
          stat_name = "speed";
          synergy_element = "Standard Shadow Qi";
          synergy_name = "Depth-Blur Stalk";
          synergy_desc =
            "Distorts visual depth perception. Targets perceive the fox as being \
             further away than it actually is, causing ranged attacks to miscalculate.";
        };
        {
          stat_name = "strength";
          synergy_element = "Standard Wind Qi";
          synergy_name = "Vacuum-Claw Ambush";
          synergy_desc =
            "Focuses air pressure into razor-sharp focal points on the claws. \
             Strikes ignore non-magical armor plating.";
        };
        {
          stat_name = "intelligence";
          synergy_element = "Standard Void Qi";
          synergy_name = "Sensory Damping Field";
          synergy_desc =
            "Passive suppression of auditory and olfactory data for all units in \
             a 3-hex radius. Prevents detection until within striking range.";
        };
        {
          stat_name = "speed";
          synergy_element = "Standard Lightning Qi";
          synergy_name = "After-Image Blitz";
          synergy_desc =
            "Leaves behind a lingering, static-charged silhouette when moving. \
             Draws aggro and consumes reactionary abilities of enemy units.";
        };
        {
          stat_name = "stamina";
          synergy_element = "Standard Earth Qi";
          synergy_name = "Sub-Surface Prowl";
          synergy_desc =
            "Allows the fox to move through loose soil or brush without \
             leaving tracks or breaking line-of-sight concealment.";
        };
        {
          stat_name = "wisdom";
          synergy_element = "Standard Blood Qi";
          synergy_name = "Predatory Lock-on";
          synergy_desc =
            "Analyzes the target's circulation rhythm. If the target has low \
             stamina, the fox gains a 50% critical strike bonus.";
        };
      ];
    transformation_reqs =
      Some
        {
          min_qi_tier = 5;
          min_intelligence = 50;
          min_memory_depth = 3;
          required_skill = "Human-Form Compilation";
          min_mastery = 0.70;
          base_success_chance = 0.05;
        };
  }

let tectonic_iron_ox : species_template =
  {
    species_name = "Tectonic Iron-Ox";
    max_strength = 120;
    max_stamina = 150;
    max_speed = 20;
    max_intelligence = 40;
    max_wisdom = 90;
    max_creativity = 20;
    max_restraint = 120;
    mutation_tolerance = 0.40;
    core_crash_chance = 0.002;
    core_crash_max_bonus = 20;
    perfect_specimen_max_bonus = 50;
    spawn_weights =
      [
        ( Forest_Cell,
          [
            ("Standard Earth Qi", 50.0);
            ("Standard Wood Qi", 35.0);
            ("Standard Metal Qi", 14.0);
            ("Random Qi Variant", 1.0);
          ] );
        ( Mountain_Cell,
          [
            ("Standard Earth Qi", 50.0);
            ("Standard Metal Qi", 49.0);
            ("Random Qi Variant", 1.0);
          ] );
        ( Plains_Cell,
          [
            ("Standard Earth Qi", 60.0);
            ("Standard Metal Qi", 20.0);
            ("Standard Wind Qi", 19.0);
            ("Random Qi Variant", 1.0);
          ] );
        ( Industrial_Cell,
          [
            ("Standard Metal Qi", 60.0);
            ("Standard Earth Qi", 24.5);
            ("Standard Lightning Qi", 14.5);
            ("Random Qi Variant", 1.0);
          ] );
        ( Coastal_Cell,
          [
            ("Standard Earth Qi", 45.0);
            ("Standard Water Qi", 35.0);
            ("Standard Metal Qi", 19.0);
            ("Random Qi Variant", 1.0);
          ] );
        ( Desert_Cell,
          [
            ("Standard Earth Qi", 50.0);
            ("Standard Fire Qi", 35.0);
            ("Standard Metal Qi", 14.0);
            ("Random Qi Variant", 1.0);
          ] );
        ( Mountain_Peak_Cell,
          [
            ("Standard Metal Qi", 50.0);
            ("Standard Earth Qi", 35.0);
            ("Standard Lightning Qi", 14.0);
            ("Random Qi Variant", 1.0);
          ] );
        ( Blood_Stained_Battlefield_Cell,
          [
            ("Standard Earth Qi", 40.0);
            ("Standard Metal Qi", 40.0);
            ("Standard Death Qi", 19.0);
            ("Random Qi Variant", 1.0);
          ] );
      ];
    synergy_table =
      [
        {
          stat_name = "restraint";
          synergy_element = "Standard Earth Qi";
          synergy_name = "Geomantic Anchor";
          synergy_desc =
            "Locks the tile's stability index at 100%. Prevents Qi contamination \
             or fallout from neighboring tile events.";
        };
        {
          stat_name = "stamina";
          synergy_element = "Standard Metal Qi";
          synergy_name = "Sovereign Plating";
          synergy_desc =
            "Reflects 50% of incoming kinetic damage back to attacker. \
             Massively increases resistance to 'Stillborn' system errors.";
        };
        {
          stat_name = "wisdom";
          synergy_element = "Standard Water Qi";
          synergy_name = "Reservoir Routing";
          synergy_desc =
            "Acts as a conduit, piping Qi from adjacent nodes to the player's sect. \
             Increases total Spirit Vein collection rate of the sect by 15%.";
        };
      ];
    transformation_reqs =
      Some
        {
          min_qi_tier = 5;
          min_intelligence = 40;
          min_memory_depth = 2;
          required_skill = "Human-Form Compilation";
          min_mastery = 0.95;
          base_success_chance = 0.01;
        };
  }

let phantom_stride_steed : species_template =
  {
    species_name = "Phantom-Stride Steed";
    max_strength = 60;
    max_stamina = 110;
    max_speed = 150;
    max_intelligence = 60;
    max_wisdom = 70;
    max_creativity = 40;
    max_restraint = 50;
    mutation_tolerance = 0.65;
    core_crash_chance = 0.015;
    core_crash_max_bonus = 20;
    perfect_specimen_max_bonus = 60;
    spawn_weights =
      [
        ( Forest_Cell,
          [
            ("Standard Wind Qi", 50.0);
            ("Standard Wood Qi", 35.0);
            ("Standard Water Qi", 14.0);
            ("Random Qi Variant", 1.0);
          ] );
        ( Mountain_Cell,
          [
            ("Standard Wind Qi", 50.0);
            ("Standard Earth Qi", 35.0);
            ("Standard Lightning Qi", 14.0);
            ("Random Qi Variant", 1.0);
          ] );
        ( Plains_Cell,
          [
            ("Standard Wind Qi", 70.0);
            ("Standard Lightning Qi", 20.0);
            ("Standard Earth Qi", 9.0);
            ("Random Qi Variant", 1.0);
          ] );
        ( Industrial_Cell,
          [
            ("Standard Lightning Qi", 50.0);
            ("Standard Metal Qi", 35.0);
            ("Standard Wind Qi", 14.0);
            ("Random Qi Variant", 1.0);
          ] );
        ( Coastal_Cell,
          [
            ("Standard Wind Qi", 50.0);
            ("Standard Water Qi", 35.0);
            ("Standard Earth Qi", 14.0);
            ("Random Qi Variant", 1.0);
          ] );
        ( Desert_Cell,
          [
            ("Standard Wind Qi", 50.0);
            ("Standard Fire Qi", 35.0);
            ("Standard Earth Qi", 14.0);
            ("Random Qi Variant", 1.0);
          ] );
        ( Mountain_Peak_Cell,
          [
            ("Standard Wind Qi", 80.0);
            ("Standard Void Qi", 14.0);
            ("Standard Lightning Qi", 5.0);
            ("Random Qi Variant", 1.0);
          ] );
        ( Blood_Stained_Battlefield_Cell,
          [
            ("Standard Wind Qi", 45.0);
            ("Standard Blood Qi", 30.0);
            ("Standard Death Qi", 24.0);
            ("Random Qi Variant", 1.0);
          ] );
      ];
    synergy_table =
      [
        {
          stat_name = "speed";
          synergy_element = "Standard Wind Qi";
          synergy_name = "Asynchronous Stream";
          synergy_desc =
            "Buffers map transit movement. Allows the rider to traverse across \
             multiple map nodes in a single tick without triggering patrol aggro.";
        };
        {
          stat_name = "wisdom";
          synergy_element = "Standard Lightning Qi";
          synergy_name = "Signal Repeater";
          synergy_desc =
            "Boosts the range of sect-wide telemetric monitoring by 3 hexes. \
             Speeds up communication between distant map sectors.";
        };
        {
          stat_name = "stamina";
          synergy_element = "Standard Void Qi";
          synergy_name = "Zero-Latency Gallop";
          synergy_desc =
            "Instantly teleports the unit across any water or mountain barrier. \
             Uses massive stamina cost; high chance of core_crash on arrival.";
        };
      ];
    transformation_reqs =
      Some
        {
          min_qi_tier = 6;
          min_intelligence = 50;
          min_memory_depth = 5;
          required_skill = "Dimensional-Shift Compilation";
          min_mastery = 0.95;
          base_success_chance = 0.02;
        };
  }


let star_glance_deer : species_template =
  {
    species_name = "Star-Glance Deer";
    max_strength = 30;
    max_stamina = 60;
    max_speed = 100;
    max_intelligence = 110;
    max_wisdom = 120;
    max_creativity = 50;
    max_restraint = 40;
    mutation_tolerance = 0.90;
    core_crash_chance = 0.01;
    core_crash_max_bonus = 15;
    perfect_specimen_max_bonus = 60;
    spawn_weights =
      [
        ( Forest_Cell,
          [
            ("Standard Wind Qi", 50.0);
            ("Standard Star Qi", 24.5);
            ("Standard Wood Qi", 24.5);
            ("Random Qi Variant", 1.0);
          ] );
        ( Mountain_Cell,
          [
            ("Standard Star Qi", 50.0);
            ("Standard Earth Qi", 24.5);
            ("Standard Wind Qi", 24.5);
            ("Random Qi Variant", 1.0);
          ] );
        ( Plains_Cell,
          [
            ("Standard Wind Qi", 50.0);
            ("Standard Star Qi", 24.5);
            ("Standard Earth Qi", 24.5);
            ("Random Qi Variant", 1.0);
          ] );
        ( Industrial_Cell,
          [
            ("Standard Metal Qi", 40.0);
            ("Standard Star Qi", 35.0);
            ("Standard Lightning Qi", 24.0);
            ("Random Qi Variant", 1.0);
          ] );
        ( Coastal_Cell,
          [
            ("Standard Water Qi", 50.0);
            ("Standard Star Qi", 24.5);
            ("Standard Wind Qi", 24.5);
            ("Random Qi Variant", 1.0);
          ] );
        ( Desert_Cell,
          [
            ("Standard Fire Qi", 50.0);
            ("Standard Star Qi", 24.5);
            ("Standard Wind Qi", 24.5);
            ("Random Qi Variant", 1.0);
          ] );
        ( Mountain_Peak_Cell,
          [
            ("Standard Star Qi", 70.0);
            ("Standard Light Qi", 19.0);
            ("Standard Wind Qi", 10.0);
            ("Random Qi Variant", 1.0);
          ] );
        ( Blood_Stained_Battlefield_Cell,
          [
            ("Standard Death Qi", 45.0);
            ("Standard Star Qi", 40.0);
            ("Standard Blood Qi", 14.0);
            ("Random Qi Variant", 1.0);
          ] );
      ];
    synergy_table =
      [
        {
          stat_name = "wisdom";
          synergy_element = "Standard Star Qi";
          synergy_name = "Celestial Scrying";
          synergy_desc =
            "Pings all tiles within 5 hexes. Reveals troop counts, building \
             progress, and hidden beast spawns as raw data entries.";
        };
        {
          stat_name = "intelligence";
          synergy_element = "Standard Wind Qi";
          synergy_name = "Subliminal Transmission";
          synergy_desc =
            "Intercepts incoming intelligence packets from enemy units within \
             its radius. Reveals the 'True Name' of opposing Sect founders.";
        };
        {
          stat_name = "speed";
          synergy_element = "Standard Light Qi";
          synergy_name = "Luminous Trail";
          synergy_desc =
            "Leaves a trail of 'Light Data' on map nodes. Allied units gain \
             +20% movement speed when traversing tiles touched by this beast.";
        };
      ];
    transformation_reqs =
      Some
        {
          min_qi_tier = 4;
          min_intelligence = 90;
          min_memory_depth = 6;
          required_skill = "Astral-Navigation Compilation";
          min_mastery = 0.85;
          base_success_chance = 0.04;
        };
  }


let steel_bristle_boar : species_template =
  {
    species_name = "Steel-Bristle Boar";
    max_strength = 110;
    max_stamina = 130;
    max_speed = 45;
    max_intelligence = 45;
    max_wisdom = 55;
    max_creativity = 30;
    max_restraint = 80;
    mutation_tolerance = 0.65;
    core_crash_chance = 0.003;
    core_crash_max_bonus = 35;
    perfect_specimen_max_bonus = 35;
    spawn_weights =
      [
        ( Forest_Cell,
          [
            ("Standard Wood Qi", 50.0);
            ("Standard Earth Qi", 24.5);
            ("Standard Metal Qi", 24.5);
            ("Random Qi Variant", 1.0);
          ] );
        ( Mountain_Cell,
          [
            ("Standard Earth Qi", 50.0);
            ("Standard Metal Qi", 24.5);
            ("Standard Lightning Qi", 24.5);
            ("Random Qi Variant", 1.0);
          ] );
        ( Plains_Cell,
          [
            ("Standard Earth Qi", 50.0);
            ("Standard Wind Qi", 24.5);
            ("Standard Wood Qi", 24.5);
            ("Random Qi Variant", 1.0);
          ] );
        ( Industrial_Cell,
          [
            ("Standard Metal Qi", 60.0);
            ("Standard Earth Qi", 24.5);
            ("Standard Fire Qi", 14.5);
            ("Random Qi Variant", 1.0);
          ] );
        ( Coastal_Cell,
          [
            ("Standard Water Qi", 40.0);
            ("Standard Earth Qi", 30.0);
            ("Standard Wood Qi", 29.0);
            ("Random Qi Variant", 1.0);
          ] );
        ( Desert_Cell,
          [
            ("Standard Fire Qi", 45.0);
            ("Standard Earth Qi", 35.0);
            ("Standard Wind Qi", 19.0);
            ("Random Qi Variant", 1.0);
          ] );
        ( Mountain_Peak_Cell,
          [
            ("Standard Lightning Qi", 50.0);
            ("Standard Earth Qi", 35.0);
            ("Standard Metal Qi", 14.0);
            ("Random Qi Variant", 1.0);
          ] );
        ( Blood_Stained_Battlefield_Cell,
          [
            ("Standard Blood Qi", 45.0);
            ("Standard Death Qi", 40.0);
            ("Standard Metal Qi", 14.0);
            ("Random Qi Variant", 1.0);
          ] );
      ];
    synergy_table =
      [
        {
          stat_name = "strength";
          synergy_element = "Standard Metal Qi";
          synergy_name = "Chassis Ramrod";
          synergy_desc =
            "Converts forward movement speed into absolute kinetic penetrator data. \
             Collisions shatter lower-tier defensive barrier installations entirely.";
        };
        {
          stat_name = "stamina";
          synergy_element = "Standard Earth Qi";
          synergy_name = "Subterranean Rooter";
          synergy_desc =
            "Tears through local hex layout grid data while moving. Uproots and \
             harvests buried regional resource nodes automatically during transit.";
        };
        {
          stat_name = "restraint";
          synergy_element = "Standard Wood Qi";
          synergy_name = "Thickhide Vitality";
          synergy_desc =
            "Overclocks regeneration variables whenever structural stability drops. \
             Negates minor micro-turn status ailments and ticks.";
        };
      ];
    transformation_reqs =
      Some
        {
          min_qi_tier = 6;
          min_intelligence = 45;
          min_memory_depth = 3;
          required_skill = "Human-Form Compilation";
          min_mastery = 0.80;
          base_success_chance = 0.04;
        };
  }



let jade_pulse_rabbit : species_template =
  {
    species_name = "Jade-Pulse Rabbit";
    max_strength = 25;
    max_stamina = 55;
    max_speed = 120;
    max_intelligence = 95;
    max_wisdom = 95;
    max_creativity = 85;
    max_restraint = 40;
    mutation_tolerance = 0.85;
    core_crash_chance = 0.009;
    core_crash_max_bonus = 20;
    perfect_specimen_max_bonus = 45;
    spawn_weights =
      [
        ( Forest_Cell,
          [
            ("Standard Wood Qi", 50.0);
            ("Standard Yin Qi", 24.5);
            ("Standard Earth Qi", 24.5);
            ("Random Qi Variant", 1.0);
          ] );
        ( Mountain_Cell,
          [
            ("Standard Earth Qi", 50.0);
            ("Standard Yin Qi", 24.5);
            ("Standard Wind Qi", 24.5);
            ("Random Qi Variant", 1.0);
          ] );
        ( Plains_Cell,
          [
            ("Standard Wind Qi", 50.0);
            ("Standard Wood Qi", 24.5);
            ("Standard Earth Qi", 24.5);
            ("Random Qi Variant", 1.0);
          ] );
        ( Industrial_Cell,
          [
            ("Standard Metal Qi", 40.0);
            ("Standard Lightning Qi", 35.0);
            ("Standard Yin Qi", 24.0);
            ("Random Qi Variant", 1.0);
          ] );
        ( Coastal_Cell,
          [
            ("Standard Water Qi", 50.0);
            ("Standard Yin Qi", 24.5);
            ("Standard Wind Qi", 24.5);
            ("Random Qi Variant", 1.0);
          ] );
        ( Desert_Cell,
          [
            ("Standard Fire Qi", 45.0);
            ("Standard Yin Qi", 30.0);
            ("Standard Wind Qi", 24.0);
            ("Random Qi Variant", 1.0);
          ] );
        ( Mountain_Peak_Cell,
          [
            ("Standard Wind Qi", 50.0);
            ("Standard Yin Qi", 35.0);
            ("Standard Lightning Qi", 14.0);
            ("Random Qi Variant", 1.0);
          ] );
        ( Blood_Stained_Battlefield_Cell,
          [
            ("Standard Death Qi", 45.0);
            ("Standard Yin Qi", 30.0);
            ("Standard Blood Qi", 24.0);
            ("Random Qi Variant", 1.0);
          ] );
      ];
    synergy_table =
      [
        {
          stat_name = "creativity";
          synergy_element = "Standard Yin Qi";
          synergy_name = "Lunar Medicine Sieve";
          synergy_desc =
            "Accelerates localized alchemy and pill compilation subroutines. \
             Reduces recipe component degradation risks across all macro-turns.";
        };
        {
          stat_name = "speed";
          synergy_element = "Standard Wind Qi";
          synergy_name = "Sub-Space Burrow";
          synergy_desc =
            "Darts into a brief local grid offset to completely ignore terrain modifiers \
             and borders, cleanly dropping aggregate unit tracking.";
        };
        {
          stat_name = "intelligence";
          synergy_element = "Standard Lightning Qi";
          synergy_name = "Frequency Jumper";
          synergy_desc =
            "Disrupts telemetry on targeted nodes by flickering silhouette arrays, \
             causing enemy surveillance scripts to temporarily drop tracking profiles.";
        };
      ];
    transformation_reqs =
      Some
        {
          min_qi_tier = 4;
          min_intelligence = 70;
          min_memory_depth = 4;
          required_skill = "Human-Form Compilation";
          min_mastery = 0.80;
          base_success_chance = 0.05;
        };
  }



let monolith_core_elephant : species_template =
  {
    species_name = "Monolith-Core Elephant";
    max_strength = 140;
    max_stamina = 160;
    max_speed = 25;
    max_intelligence = 85;
    max_wisdom = 100;
    max_creativity = 40;
    max_restraint = 110;
    mutation_tolerance = 0.45;
    core_crash_chance = 0.003;
    core_crash_max_bonus = 30;
    perfect_specimen_max_bonus = 45;
    spawn_weights =
      [
        ( Forest_Cell,
          [
            ("Standard Wood Qi", 50.0);
            ("Standard Earth Qi", 24.5);
            ("Standard Metal Qi", 24.5);
            ("Random Qi Variant", 1.0);
          ] );
        ( Mountain_Cell,
          [
            ("Standard Earth Qi", 50.0);
            ("Standard Metal Qi", 24.5);
            ("Standard Gravity Qi", 24.5);
            ("Random Qi Variant", 1.0);
          ] );
        ( Plains_Cell,
          [
            ("Standard Earth Qi", 60.0);
            ("Standard Wind Qi", 24.5);
            ("Standard Wood Qi", 14.5);
            ("Random Qi Variant", 1.0);
          ] );
        ( Industrial_Cell,
          [
            ("Standard Metal Qi", 50.0);
            ("Standard Earth Qi", 24.5);
            ("Standard Nuclear Qi", 24.5);
            ("Random Qi Variant", 1.0);
          ] );
        ( Coastal_Cell,
          [
            ("Standard Water Qi", 45.0);
            ("Standard Earth Qi", 30.0);
            ("Standard Wood Qi", 24.0);
            ("Random Qi Variant", 1.0);
          ] );
        ( Desert_Cell,
          [
            ("Standard Earth Qi", 50.0);
            ("Standard Fire Qi", 24.5);
            ("Standard Wind Qi", 24.5);
            ("Random Qi Variant", 1.0);
          ] );
        ( Mountain_Peak_Cell,
          [
            ("Standard Gravity Qi", 50.0);
            ("Standard Earth Qi", 25.0);
            ("Standard Lightning Qi", 24.0);
            ("Random Qi Variant", 1.0);
          ] );
        ( Blood_Stained_Battlefield_Cell,
          [
            ("Standard Death Qi", 40.0);
            ("Standard Earth Qi", 40.0);
            ("Standard Blood Qi", 19.0);
            ("Random Qi Variant", 1.0);
          ] );
      ];
    synergy_table =
      [
        {
          stat_name = "strength";
          synergy_element = "Standard Gravity Qi";
          synergy_name = "Spatial Crusher";
          synergy_desc =
            "Crushes the localized coordinate grid with footsteps. Alters movement \
             costs for all adjacent hex cells, causing trailing enemies severe lag.";
        };
        {
          stat_name = "wisdom";
          synergy_element = "Standard Earth Qi";
          synergy_name = "Leyline Memory Cache";
          synergy_desc =
            "Maintains local terrain parameters. Completely immunizes allied units \
             standing on the same tile from hostile elemental fallout or tile flips.";
        };
      ];
    transformation_reqs =
      Some
        {
          min_qi_tier = 6;
          min_intelligence = 80;
          min_memory_depth = 6;
          required_skill = "Sovereign Array Preservation";
          min_mastery = 0.90;
          base_success_chance = 0.02;
        };
  }



let ram_driver_rhinoceros : species_template =
  {
    species_name = "Ram-Driver Rhinoceros";
    max_strength = 130;
    max_stamina = 120;
    max_speed = 50;
    max_intelligence = 50;
    max_wisdom = 60;
    max_creativity = 30;
    max_restraint = 95;
    mutation_tolerance = 0.50;
    core_crash_chance = 0.005;
    core_crash_max_bonus = 35;
    perfect_specimen_max_bonus = 40;
    spawn_weights =
      [
        ( Forest_Cell,
          [
            ("Standard Wood Qi", 40.0);
            ("Standard Earth Qi", 35.0);
            ("Standard Metal Qi", 24.0);
            ("Random Qi Variant", 1.0);
          ] );
        ( Mountain_Cell,
          [
            ("Standard Earth Qi", 50.0);
            ("Standard Metal Qi", 35.0);
            ("Standard Lightning Qi", 14.0);
            ("Random Qi Variant", 1.0);
          ] );
        ( Plains_Cell,
          [
            ("Standard Earth Qi", 50.0);
            ("Standard Fire Qi", 25.0);
            ("Standard Wind Qi", 24.0);
            ("Random Qi Variant", 1.0);
          ] );
        ( Industrial_Cell,
          [
            ("Standard Metal Qi", 60.0);
            ("Standard Fire Qi", 24.5);
            ("Standard Lightning Qi", 14.5);
            ("Random Qi Variant", 1.0);
          ] );
        ( Coastal_Cell,
          [
            ("Standard Water Qi", 45.0);
            ("Standard Earth Qi", 30.0);
            ("Standard Metal Qi", 24.0);
            ("Random Qi Variant", 1.0);
          ] );
        ( Desert_Cell,
          [
            ("Standard Fire Qi", 50.0);
            ("Standard Earth Qi", 35.0);
            ("Standard Metal Qi", 14.0);
            ("Random Qi Variant", 1.0);
          ] );
        ( Mountain_Peak_Cell,
          [
            ("Standard Metal Qi", 50.0);
            ("Standard Lightning Qi", 35.0);
            ("Standard Earth Qi", 14.0);
            ("Random Qi Variant", 1.0);
          ] );
        ( Blood_Stained_Battlefield_Cell,
          [
            ("Standard Blood Qi", 45.0);
            ("Standard Metal Qi", 40.0);
            ("Standard Death Qi", 14.0);
            ("Random Qi Variant", 1.0);
          ] );
      ];
    synergy_table =
      [
        {
          stat_name = "strength";
          synergy_element = "Standard Metal Qi";
          synergy_name = "Hardcoded Boring-Tool";
          synergy_desc =
            "The horn acts as a literal hardware-level compiler breach. Ignores \
             structural defense multipliers when striking sect walls or outposts.";
        };
        {
          stat_name = "restraint";
          synergy_element = "Standard Earth Qi";
          synergy_name = "Tectonic Firewall";
          synergy_desc =
            "Roots physical mass into the hex vector. Forces a collision block \
             preventing enemy army objects from parsing transit logic through this tile.";
        };
      ];
    transformation_reqs =
      Some
        {
          min_qi_tier = 5;
          min_intelligence = 50;
          min_memory_depth = 3;
          required_skill = "Human-Form Compilation";
          min_mastery = 0.85;
          base_success_chance = 0.03;
        };
  }



let chroma_blur_leopard : species_template =
  {
    species_name = "Chroma-Blur Leopard";
    max_strength = 75;
    max_stamina = 80;
    max_speed = 145;
    max_intelligence = 80;
    max_wisdom = 60;
    max_creativity = 65;
    max_restraint = 45;
    mutation_tolerance = 0.80;
    core_crash_chance = 0.010;
    core_crash_max_bonus = 30;
    perfect_specimen_max_bonus = 50;
    spawn_weights =
      [
        ( Forest_Cell,
          [
            ("Standard Wood Qi", 40.0);
            ("Standard Shadow Qi", 35.0);
            ("Standard Wind Qi", 24.0);
            ("Random Qi Variant", 1.0);
          ] );
        ( Mountain_Cell,
          [
            ("Standard Wind Qi", 45.0);
            ("Standard Shadow Qi", 35.0);
            ("Standard Lightning Qi", 19.0);
            ("Random Qi Variant", 1.0);
          ] );
        ( Plains_Cell,
          [
            ("Standard Wind Qi", 50.0);
            ("Standard Lightning Qi", 24.5);
            ("Standard Shadow Qi", 24.5);
            ("Random Qi Variant", 1.0);
          ] );
        ( Industrial_Cell,
          [
            ("Standard Lightning Qi", 50.0);
            ("Standard Metal Qi", 25.0);
            ("Standard Shadow Qi", 24.0);
            ("Random Qi Variant", 1.0);
          ] );
        ( Coastal_Cell,
          [
            ("Standard Water Qi", 45.0);
            ("Standard Wind Qi", 30.0);
            ("Standard Shadow Qi", 24.0);
            ("Random Qi Variant", 1.0);
          ] );
        ( Desert_Cell,
          [
            ("Standard Fire Qi", 45.0);
            ("Standard Wind Qi", 35.0);
            ("Standard Shadow Qi", 19.0);
            ("Random Qi Variant", 1.0);
          ] );
        ( Mountain_Peak_Cell,
          [
            ("Standard Lightning Qi", 60.0);
            ("Standard Wind Qi", 25.0);
            ("Standard Void Qi", 14.0);
            ("Random Qi Variant", 1.0);
          ] );
        ( Blood_Stained_Battlefield_Cell,
          [
            ("Standard Shadow Qi", 50.0);
            ("Standard Blood Qi", 35.0);
            ("Standard Death Qi", 14.0);
            ("Random Qi Variant", 1.0);
          ] );
      ];
    synergy_table =
      [
        {
          stat_name = "speed";
          synergy_element = "Standard Lightning Qi";
          synergy_name = "Execution Trace Strike";
          synergy_desc =
            "Bypasses frontline security lines using raw velocity registers, \
             blitzing high-value logistical targets or commanders directly.";
        };
        {
          stat_name = "creativity";
          synergy_element = "Standard Shadow Qi";
          synergy_name = "Masked Execution Profile";
          synergy_desc =
            "Spoofs local threat tables when attacking. Striking an entity does \
             not flag this unit as aggressive on faction monitoring grids.";
        };
      ];
    transformation_reqs =
      Some
        {
          min_qi_tier = 6;
          min_intelligence = 75;
          min_memory_depth = 4;
          required_skill = "Asynchronous Ambush Logic";
          min_mastery = 0.90;
          base_success_chance = 0.04;
        };
  }


let hyper_clock_cheetah : species_template =
  {
    species_name = "Hyper-Clock Cheetah";
    max_strength = 65;
    max_stamina = 70;
    max_speed = 160; (* Highest velocity tier *)
    max_intelligence = 75;
    max_wisdom = 50;
    max_creativity = 60;
    max_restraint = 35;
    mutation_tolerance = 0.75;
    core_crash_chance = 0.018; (* Volatile at max cycle rates *)
    core_crash_max_bonus = 25;
    perfect_specimen_max_bonus = 55;
    spawn_weights =
      [
        ( Forest_Cell, [ ("Standard Wind Qi", 50.0); ("Standard Lightning Qi", 24.5); ("Standard Wood Qi", 24.5); ("Random Qi Variant", 1.0); ] );
        ( Mountain_Cell, [ ("Standard Wind Qi", 45.0); ("Standard Lightning Qi", 30.0); ("Standard Earth Qi", 24.0); ("Random Qi Variant", 1.0); ] );
        ( Plains_Cell, [ ("Standard Wind Qi", 65.0); ("Standard Lightning Qi", 24.5); ("Standard Kinetic Qi", 9.5); ("Random Qi Variant", 1.0); ] );
        ( Industrial_Cell, [ ("Standard Lightning Qi", 50.0); ("Standard Metal Qi", 25.0); ("Standard Kinetic Qi", 24.0); ("Random Qi Variant", 1.0); ] );
        ( Coastal_Cell, [ ("Standard Wind Qi", 50.0); ("Standard Water Qi", 24.5); ("Standard Light Qi", 24.5); ("Random Qi Variant", 1.0); ] );
        ( Desert_Cell, [ ("Standard Wind Qi", 50.0); ("Standard Fire Qi", 35.0); ("Standard Heat Qi", 14.0); ("Random Qi Variant", 1.0); ] );
        ( Mountain_Peak_Cell, [ ("Standard Lightning Qi", 60.0); ("Standard Wind Qi", 25.0); ("Standard Void Qi", 14.0); ("Random Qi Variant", 1.0); ] );
        ( Blood_Stained_Battlefield_Cell, [ ("Standard Kinetic Qi", 45.0); ("Standard Blood Qi", 30.0); ("Standard Death Qi", 24.0); ("Random Qi Variant", 1.0); ] );
      ];
    synergy_table =
      [
        {
          stat_name = "speed";
          synergy_element = "Standard Wind Qi";
          synergy_name = "Clock Interrupter";
          synergy_desc = "Forcefully inserts an asynchronous move transaction into the execution queue before neighboring ticks map out.";
        };
      ];
    transformation_reqs = Some { min_qi_tier = 6; min_intelligence = 70; min_memory_depth = 4; required_skill = "Asynchronous Core Overclocking"; min_mastery = 0.90; base_success_chance = 0.03; };
  }

let scavenging_scum_hyena : species_template =
  {
    species_name = "Scavenging Scum Hyena";
    max_strength = 80;
    max_stamina = 95;
    max_speed = 90;
    max_intelligence = 65;
    max_wisdom = 45;
    max_creativity = 75;
    max_restraint = 40;
    mutation_tolerance = 0.85;
    core_crash_chance = 0.012;
    core_crash_max_bonus = 35;
    perfect_specimen_max_bonus = 25;
    spawn_weights =
      [
        ( Forest_Cell, [ ("Standard Shadow Qi", 40.0); ("Standard Wood Qi", 35.0); ("Standard Toxin Qi", 24.0); ("Random Qi Variant", 1.0); ] );
        ( Mountain_Cell, [ ("Standard Earth Qi", 45.0); ("Standard Shadow Qi", 35.0); ("Standard Death Qi", 19.0); ("Random Qi Variant", 1.0); ] );
        ( Plains_Cell, [ ("Standard Wind Qi", 45.0); ("Standard Earth Qi", 30.0); ("Standard Blood Qi", 24.0); ("Random Qi Variant", 1.0); ] );
        ( Industrial_Cell, [ ("Standard Metal Qi", 45.0); ("Standard Death Qi", 35.0); ("Standard Toxin Qi", 19.0); ("Random Qi Variant", 1.0); ] );
        ( Coastal_Cell, [ ("Standard Water Qi", 40.0); ("Standard Shadow Qi", 35.0); ("Standard Rotten Qi", 24.0); ("Random Qi Variant", 1.0); ] );
        ( Desert_Cell, [ ("Standard Fire Qi", 40.0); ("Standard Wind Qi", 35.0); ("Standard Death Qi", 24.0); ("Random Qi Variant", 1.0); ] );
        ( Mountain_Peak_Cell, [ ("Standard Shadow Qi", 50.0); ("Standard Wind Qi", 35.0); ("Standard Void Qi", 14.0); ("Random Qi Variant", 1.0); ] );
        ( Blood_Stained_Battlefield_Cell, [ ("Standard Blood Qi", 40.0); ("Standard Death Qi", 40.0); ("Standard Sanguine Qi", 19.0); ("Random Qi Variant", 1.0); ] );
      ];
    synergy_table =
      [
        {
          stat_name = "creativity";
          synergy_element = "Standard Death Qi";
          synergy_name = "Debris Garbage Collector";
          synergy_desc = "Automatically parses killed entity allocations on the current cell, siphoning remaining buffer states into inventory.";
        };
      ];
    transformation_reqs = Some { min_qi_tier = 5; min_intelligence = 60; min_memory_depth = 3; required_skill = "Human-Form Compilation"; min_mastery = 0.75; base_success_chance = 0.05; };
  }

let core_breaker_badger : species_template =
  {
    species_name = "Core-Breaker Badger";
    max_strength = 95;
    max_stamina = 115;
    max_speed = 60;
    max_intelligence = 55;
    max_wisdom = 75;
    max_creativity = 40;
    max_restraint = 90;
    mutation_tolerance = 0.60;
    core_crash_chance = 0.004;
    core_crash_max_bonus = 45;
    perfect_specimen_max_bonus = 35;
    spawn_weights =
      [
        ( Forest_Cell, [ ("Standard Earth Qi", 45.0); ("Standard Wood Qi", 45.0); ("Standard Toxin Qi", 9.0); ("Random Qi Variant", 1.0); ] );
        ( Mountain_Cell, [ ("Standard Earth Qi", 55.0); ("Standard Metal Qi", 35.0); ("Standard Static Qi", 9.0); ("Random Qi Variant", 1.0); ] );
        ( Plains_Cell, [ ("Standard Earth Qi", 50.0); ("Standard Wind Qi", 35.0); ("Standard Vitality Qi", 14.0); ("Random Qi Variant", 1.0); ] );
        ( Industrial_Cell, [ ("Standard Metal Qi", 50.0); ("Standard Earth Qi", 35.0); ("Standard Acid Qi", 14.0); ("Random Qi Variant", 1.0); ] );
        ( Coastal_Cell, [ ("Standard Earth Qi", 45.0); ("Standard Water Qi", 35.0); ("Standard Wood Qi", 19.0); ("Random Qi Variant", 1.0); ] );
        ( Desert_Cell, [ ("Standard Earth Qi", 50.0); ("Standard Fire Qi", 35.0); ("Standard Potential Qi", 14.0); ("Random Qi Variant", 1.0); ] );
        ( Mountain_Peak_Cell, [ ("Standard Earth Qi", 50.0); ("Standard Lightning Qi", 35.0); ("Standard Metal Qi", 14.0); ("Random Qi Variant", 1.0); ] );
        ( Blood_Stained_Battlefield_Cell, [ ("Standard Earth Qi", 45.0); ("Standard Death Qi", 35.0); ("Standard Metal Qi", 19.0); ("Random Qi Variant", 1.0); ] );
      ];
    synergy_table =
      [
        {
          stat_name = "restraint";
          synergy_element = "Standard Earth Qi";
          synergy_name = "Thread Exception Refusal";
          synergy_desc = "Gains total immunity against logic manipulation or forced interrupt subroutines from higher tier threats.";
        };
      ];
    transformation_reqs = Some { min_qi_tier = 5; min_intelligence = 50; min_memory_depth = 4; required_skill = "Subterranean Node Hardening"; min_mastery = 0.85; base_success_chance = 0.04; };
  }

let grid_tunnel_mole : species_template =
  {
    species_name = "Grid-Tunnel Mole";
    max_strength = 50;
    max_stamina = 100;
    max_speed = 40;
    max_intelligence = 70;
    max_wisdom = 95;
    max_creativity = 50;
    max_restraint = 105;
    mutation_tolerance = 0.55;
    core_crash_chance = 0.002;
    core_crash_max_bonus = 30;
    perfect_specimen_max_bonus = 40;
    spawn_weights =
      [
        ( Forest_Cell, [ ("Standard Earth Qi", 60.0); ("Standard Wood Qi", 24.5); ("Standard Potential Qi", 14.5); ("Random Qi Variant", 1.0); ] );
        ( Mountain_Cell, [ ("Standard Earth Qi", 60.0); ("Standard Metal Qi", 24.5); ("Standard Pressure Qi", 14.5); ("Random Qi Variant", 1.0); ] );
        ( Plains_Cell, [ ("Standard Earth Qi", 70.0); ("Standard Wind Qi", 19.5); ("Standard Moisture Qi", 9.5); ("Random Qi Variant", 1.0); ] );
        ( Industrial_Cell, [ ("Standard Earth Qi", 50.0); ("Standard Metal Qi", 35.0); ("Standard Acid Qi", 14.0); ("Random Qi Variant", 1.0); ] );
        ( Coastal_Cell, [ ("Standard Earth Qi", 50.0); ("Standard Water Qi", 35.0); ("Standard Silt Qi", 14.0); ("Random Qi Variant", 1.0); ] );
        ( Desert_Cell, [ ("Standard Earth Qi", 60.0); ("Standard Sand Qi", 25.0); ("Standard Thermal Qi", 14.0); ("Random Qi Variant", 1.0); ] );
        ( Mountain_Peak_Cell, [ ("Standard Earth Qi", 50.0); ("Standard Pressure Qi", 35.0); ("Standard Lightning Qi", 14.0); ("Random Qi Variant", 1.0); ] );
        ( Blood_Stained_Battlefield_Cell, [ ("Standard Earth Qi", 50.0); ("Standard Death Qi", 35.0); ("Standard Bone Qi", 14.0); ("Random Qi Variant", 1.0); ] );
      ];
    synergy_table =
      [
        {
          stat_name = "restraint";
          synergy_element = "Standard Earth Qi";
          synergy_name = "Topology Bypass Routing";
          synergy_desc = "Tunnels directly beneath active boundary code blocking cells, writing local underground shortcuts into the map layout.";
        };
      ];
    transformation_reqs = Some { min_qi_tier = 4; min_intelligence = 65; min_memory_depth = 3; required_skill = "Human-Form Compilation"; min_mastery = 0.80; base_success_chance = 0.05; };
  }

let signal_spike_hedgehog : species_template =
  {
    species_name = "Signal-Spike Hedgehog";
    max_strength = 45;
    max_stamina = 90;
    max_speed = 55;
    max_intelligence = 65;
    max_wisdom = 85;
    max_creativity = 55;
    max_restraint = 110;
    mutation_tolerance = 0.65;
    core_crash_chance = 0.005;
    core_crash_max_bonus = 20;
    perfect_specimen_max_bonus = 45;
    spawn_weights =
      [
        ( Forest_Cell, [ ("Standard Earth Qi", 40.0); ("Standard Wood Qi", 35.0); ("Standard Static Qi", 24.0); ("Random Qi Variant", 1.0); ] );
        ( Mountain_Cell, [ ("Standard Earth Qi", 45.0); ("Standard Metal Qi", 35.0); ("Standard Oscillatory Qi", 19.0); ("Random Qi Variant", 1.0); ] );
        ( Plains_Cell, [ ("Standard Earth Qi", 50.0); ("Standard Wind Qi", 25.0); ("Standard Electric Qi", 24.0); ("Random Qi Variant", 1.0); ] );
        ( Industrial_Cell, [ ("Standard Metal Qi", 45.0); ("Standard Electric Qi", 35.0); ("Standard Magnetic Qi", 19.0); ("Random Qi Variant", 1.0); ] );
        ( Coastal_Cell, [ ("Standard Earth Qi", 45.0); ("Standard Water Qi", 35.0); ("Standard Oscillatory Qi", 19.0); ("Random Qi Variant", 1.0); ] );
        ( Desert_Cell, [ ("Standard Earth Qi", 45.0); ("Standard Fire Qi", 35.0); ("Standard Static Qi", 19.0); ("Random Qi Variant", 1.0); ] );
        ( Mountain_Peak_Cell, [ ("Standard Lightning Qi", 50.0); ("Standard Oscillatory Qi", 35.0); ("Standard Magnetic Qi", 14.0); ("Random Qi Variant", 1.0); ] );
        ( Blood_Stained_Battlefield_Cell, [ ("Standard Death Qi", 45.0); ("Standard Metal Qi", 35.0); ("Standard Sanguine Qi", 19.0); ("Random Qi Variant", 1.0); ] );
      ];
    synergy_table =
      [
        {
          stat_name = "restraint";
          synergy_element = "Standard Electric Qi";
          synergy_name = "Data Line Reflector";
          synergy_desc = "Converts physical damage into an immediate high-frequency electromagnetic noise blast across all adjacent hex nodes.";
        };
      ];
    transformation_reqs = Some { min_qi_tier = 4; min_intelligence = 60; min_memory_depth = 4; required_skill = "Human-Form Compilation"; min_mastery = 0.80; base_success_chance = 0.05; };
  }

let logic_leak_weasel : species_template =
  {
    species_name = "Logic-Leak Weasel";
    max_strength = 40;
    max_stamina = 65;
    max_speed = 135;
    max_intelligence = 100;
    max_wisdom = 70;
    max_creativity = 95;
    max_restraint = 35;
    mutation_tolerance = 0.85;
    core_crash_chance = 0.015;
    core_crash_max_bonus = 30;
    perfect_specimen_max_bonus = 50;
    spawn_weights =
      [
        ( Forest_Cell, [ ("Standard Shadow Qi", 45.0); ("Standard Wood Qi", 35.0); ("Standard Wind Qi", 19.0); ("Random Qi Variant", 1.0); ] );
        ( Mountain_Cell, [ ("Standard Wind Qi", 45.0); ("Standard Shadow Qi", 35.0); ("Standard Ethereal Qi", 19.0); ("Random Qi Variant", 1.0); ] );
        ( Plains_Cell, [ ("Standard Wind Qi", 50.0); ("Standard Shadow Qi", 25.0); ("Standard Neural Qi", 24.0); ("Random Qi Variant", 1.0); ] );
        ( Industrial_Cell, [ ("Standard Metal Qi", 40.0); ("Standard Lightning Qi", 35.0); ("Standard Shadow Qi", 24.0); ("Random Qi Variant", 1.0); ] );
        ( Coastal_Cell, [ ("Standard Water Qi", 45.0); ("Standard Wind Qi", 35.0); ("Standard Shadow Qi", 19.0); ("Random Qi Variant", 1.0); ] );
        ( Desert_Cell, [ ("Standard Wind Qi", 45.0); ("Standard Fire Qi", 35.0); ("Standard Shadow Qi", 19.0); ("Random Qi Variant", 1.0); ] );
        ( Mountain_Peak_Cell, [ ("Standard Wind Qi", 50.0); ("Standard Lightning Qi", 35.0); ("Standard Void Qi", 14.0); ("Random Qi Variant", 1.0); ] );
        ( Blood_Stained_Battlefield_Cell, [ ("Standard Shadow Qi", 45.0); ("Standard Death Qi", 35.0); ("Standard Blood Qi", 19.0); ("Random Qi Variant", 1.0); ] );
      ];
    synergy_table =
      [
        {
          stat_name = "creativity";
          synergy_element = "Standard Shadow Qi";
          synergy_name = "Cache Injection Subversion";
          synergy_desc = "Injects corrupted logic loops into enemy perimeter buffers, leaking their supply network parameters back to user.";
        };
      ];
    transformation_reqs = Some { min_qi_tier = 5; min_intelligence = 80; min_memory_depth = 5; required_skill = "Malicious Code Injection"; min_mastery = 0.90; base_success_chance = 0.04; };
  }

let cache_hoarder_squirrel : species_template =
  {
    species_name = "Cache-Hoarder Squirrel";
    max_strength = 35;
    max_stamina = 75;
    max_speed = 115;
    max_intelligence = 90;
    max_wisdom = 80;
    max_creativity = 100;
    max_restraint = 55;
    mutation_tolerance = 0.80;
    core_crash_chance = 0.007;
    core_crash_max_bonus = 20;
    perfect_specimen_max_bonus = 40;
    spawn_weights =
      [
        ( Forest_Cell, [ ("Standard Wood Qi", 55.0); ("Standard Wind Qi", 24.5); ("Standard Storage Qi", 19.5); ("Random Qi Variant", 1.0); ] );
        ( Mountain_Cell, [ ("Standard Wood Qi", 45.0); ("Standard Earth Qi", 35.0); ("Standard Storage Qi", 19.0); ("Random Qi Variant", 1.0); ] );
        ( Plains_Cell, [ ("Standard Wind Qi", 45.0); ("Standard Wood Qi", 35.0); ("Standard Storage Qi", 19.0); ("Random Qi Variant", 1.0); ] );
        ( Industrial_Cell, [ ("Standard Metal Qi", 45.0); ("Standard Wood Qi", 35.0); ("Standard Storage Qi", 19.0); ("Random Qi Variant", 1.0); ] );
        ( Coastal_Cell, [ ("Standard Water Qi", 45.0); ("Standard Wood Qi", 35.0); ("Standard Storage Qi", 19.0); ("Random Qi Variant", 1.0); ] );
        ( Desert_Cell, [ ("Standard Fire Qi", 45.0); ("Standard Wood Qi", 35.0); ("Standard Storage Qi", 19.0); ("Random Qi Variant", 1.0); ] );
        ( Mountain_Peak_Cell, [ ("Standard Wind Qi", 50.0); ("Standard Wood Qi", 35.0); ("Standard Storage Qi", 14.0); ("Random Qi Variant", 1.0); ] );
        ( Blood_Stained_Battlefield_Cell, [ ("Standard Death Qi", 45.0); ("Standard Wood Qi", 35.0); ("Standard Storage Qi", 19.0); ("Random Qi Variant", 1.0); ] );
      ];
    synergy_table =
      [
        {
          stat_name = "creativity";
          synergy_element = "Standard Wood Qi";
          synergy_name = "Resource Data Buffer";
          synergy_desc = "Allocates a dedicated offline memory segment, completely protecting stored resources from enemy taxation rules.";
        };
      ];
    transformation_reqs = Some { min_qi_tier = 4; min_intelligence = 75; min_memory_depth = 5; required_skill = "Human-Form Compilation"; min_mastery = 0.80; base_success_chance = 0.05; };
  }