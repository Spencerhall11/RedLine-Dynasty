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


let void_stalker_wolf : species_template =
  {
    species_name = "Void-Stalker Wolf";
    max_strength = 60;
    max_stamina = 80;
    max_speed = 120;
    max_intelligence = 85;
    max_wisdom = 50;
    max_creativity = 60;
    max_restraint = 40;
    mutation_tolerance = 0.85;
    core_crash_chance = 0.012;
    core_crash_max_bonus = 30;
    perfect_specimen_max_bonus = 40;
    spawn_weights =
      [
        ( Forest_Cell,
          [
            ("Standard Wind Qi", 60.0);
            ("Standard Wood Qi", 20.0);
            ("Standard Shadow Qi", 19.0);
            ("Random Qi Variant", 1.0);
          ] );
        ( Plains_Cell,
          [
            ("Standard Wind Qi", 50.0);
            ("Standard Earth Qi", 25.0);
            ("Standard Shadow Qi", 24.0);
            ("Random Qi Variant", 1.0);
          ] );
        ( Mountain_Cell,
          [
            ("Standard Wind Qi", 40.0);
            ("Standard Shadow Qi", 40.0);
            ("Standard Lightning Qi", 19.0);
            ("Random Qi Variant", 1.0);
          ] );
      ];
    synergy_table =
      [
        {
          stat_name = "speed";
          synergy_element = "Standard Shadow Qi";
          synergy_name = "Phase-Shift Pounce";
          synergy_desc =
            "Integrates local spatial coordinates into movement vector. Bypasses \
             all solid map objects during charge.";
        };
        {
          stat_name = "intelligence";
          synergy_element = "Standard Wind Qi";
          synergy_name = "Pack-Signal Relay";
          synergy_desc =
            "Broadcasts target telemetry to all allied units within 10 hexes. \
             Provides a global accuracy boost for all pack members.";
        };
        {
          stat_name = "stamina";
          synergy_element = "Standard Wood Qi";
          synergy_name = "Forest-Phantom Camouflage";
          synergy_desc =
            "Synchronizes biological heat signature with environmental biomass. \
             Removes unit from active enemy target-list while stationary.";
        };
        {
          stat_name = "strength";
          synergy_element = "Standard Lightning Qi";
          synergy_name = "Static-Surge Fang";
          synergy_desc =
            "Bites inject high-voltage discharge directly into the target's \
             internal meridians, disrupting active technique sequences.";
        };
        {
          stat_name = "restraint";
          synergy_element = "Standard Metal Qi";
          synergy_name = "Shrapnel-Howl";
          synergy_desc =
            "Acoustic vibration shatters nearby metal-based debris into \
             directional projectiles. Forces morale check on nearby squads.";
        };
        {
          stat_name = "speed";
          synergy_element = "Standard Void Qi";
          synergy_name = "Dimensional Drift";
          synergy_desc =
            "Darts through local reality seams. Exits combat and teleports to \
             the nearest low-population map tile.";
        };
        {
          stat_name = "wisdom";
          synergy_element = "Standard Water Qi";
          synergy_name = "Flow-State Scent";
          synergy_desc =
            "Tracks target through aquatic or vapor-heavy terrain. Reduces \
             evasion chance of target by 40%.";
        };
        {
          stat_name = "creativity";
          synergy_element = "Standard Fire Qi";
          synergy_name = "Ignition-Pack Hunter";
          synergy_desc =
            "Coats claws in hyper-heated Qi. Leaving 'Fire-Trail' on nodes \
             traversed, causing area-of-effect burn damage to pursuing units.";
        };
      ];
    transformation_reqs =
      Some
        {
          min_qi_tier = 5;
          min_intelligence = 60;
          min_memory_depth = 3;
          required_skill = "Human-Form Compilation";
          min_mastery = 0.75;
          base_success_chance = 0.05;
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
            ("Standard Wind Qi", 49.0);
            ("Random Qi Variant", 1.0);
          ] );
        ( Mountain_Cell,
          [
            ("Standard Shadow Qi", 60.0);
            ("Standard Void Qi", 39.0);
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