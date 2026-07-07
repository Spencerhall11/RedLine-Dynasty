open Types

(* ==========================================================
   Affinity system (2+1 rule)
   ========================================================== *)

let make_affinity_set (base : element_id list) : (affinity_set, string) result =
  if List.length base <> 2 then
    Error "Base affinities must be exactly 2 (2+1 rule violation)"
  else
    Ok { base_affinities = base; evolved_affinity = None }

let fusion_lookup (a : element_id) (b : element_id) : element_id option =
  match List.sort compare [ a; b ] with
  | [ "Fire"; "Water" ] -> Some "Scorching Steam Qi"
  | [ "Fire"; "Earth" ] -> Some "Magma Core Qi"
  | [ "Ice"; "Water" ] -> Some "Glacial Abyss Qi"
  | [ "Water"; "Wood" ] -> Some "Abyssal Miasma Qi"
  | [ "Metal"; "Poison" ] -> Some "Metal Plague Qi"
  | _ -> None

let attempt_evolution (a : affinity_set) : (affinity_set, string) result =
  match a.evolved_affinity with
  | Some _ -> Error "Evolution slot already filled"
  | None -> (
      match a.base_affinities with
      | [ x; y ] -> (
          match fusion_lookup x y with
          | Some fused -> Ok { a with evolved_affinity = Some fused }
          | None -> Error "No fusion recipe found for these base affinities")
      | _ -> Error "Invalid affinity set")

(* ==========================================================
   Kernel-Merge Engine
   ========================================================== *)

let merge_kernels (k1 : kernel_state) (k2 : kernel_state) : kernel_state =
  let elements = List.sort_uniq compare (k1.elements @ k2.elements) in
  let avg_stability = (k1.stability +. k2.stability) /. 2.0 in
  let element_count_penalty = float_of_int (List.length elements) *. 0.05 in
  let stability = Float.max 0.0 (avg_stability -. element_count_penalty) in
  let entropy = k1.entropy +. k2.entropy +. ((1.0 -. stability) *. 10.0) in
  { elements; stability; entropy; hosted_by = None }

(* ==========================================================
   Qi Tier progression constants (see Qi_System.md) — shared by
   both cultivator and beast breakthrough mechanics.
   ========================================================== *)

let tier_cap = 10 (* Immortal *)
let crossing_calamity_tier = 9 (* worst failure severity lives here *)

(* ==========================================================
   Species firmware clamping + Stochastic Boundary Overflow
   ========================================================== *)

let cap_by_name (t : species_template) (name : string) : int =
  match name with
  | "strength" -> t.max_strength
  | "stamina" -> t.max_stamina
  | "speed" -> t.max_speed
  | "intelligence" -> t.max_intelligence
  | "wisdom" -> t.max_wisdom
  | "creativity" -> t.max_creativity
  | "restraint" -> t.max_restraint
  | _ -> 0

let set_stat (a : beast_attributes) (name : string) (v : int) : beast_attributes =
  match name with
  | "strength" -> { a with strength = v }
  | "stamina" -> { a with stamina = v }
  | "speed" -> { a with speed = v }
  | "intelligence" -> { a with intelligence = v }
  | "wisdom" -> { a with wisdom = v }
  | "creativity" -> { a with creativity = v }
  | "restraint" -> { a with restraint = v }
  | _ -> a

let stat_names =
  [ "strength"; "stamina"; "speed"; "intelligence"; "wisdom"; "creativity"; "restraint" ]

(* Roll each stat 0..cap inclusive, clamped to the species template. *)
let roll_base_stats (t : species_template) : beast_attributes =
  {
    strength = Random.int (t.max_strength + 1);
    stamina = Random.int (t.max_stamina + 1);
    speed = Random.int (t.max_speed + 1);
    intelligence = Random.int (t.max_intelligence + 1);
    wisdom = Random.int (t.max_wisdom + 1);
    creativity = Random.int (t.max_creativity + 1);
    restraint = Random.int (t.max_restraint + 1);
  }

(* Vector 2 [Perfect Specimen Overclock]: any stat that rolled exactly
   its cap fractures the governor and spills +Random(0..bonus). Runs
   over every stat independently — multiple can trigger at once. *)
let apply_perfect_specimen (t : species_template) (stats : beast_attributes) :
    beast_attributes =
  List.fold_left
    (fun acc name ->
      let cap = cap_by_name t name in
      let v = stat_by_name acc name in
      if v = cap && cap > 0 then
        set_stat acc name (v + Random.int (t.perfect_specimen_max_bonus + 1))
      else acc)
    stats stat_names

(* Vector 1 [Core Crash Lottery]: rare (species-defined) chance to pick
   ONE random stat and force an un-throttled injection beyond cap.
   Returns whether it fired, since callers may need to know (see
   resolve_stats_with_diagnostics). *)
let apply_core_crash (t : species_template) (stats : beast_attributes) :
    beast_attributes * bool =
  if Random.float 1.0 < t.core_crash_chance then
    let name = List.nth stat_names (Random.int (List.length stat_names)) in
    let v = stat_by_name stats name in
    (set_stat stats name (v + Random.int (t.core_crash_max_bonus + 1)), true)
  else (stats, false)

(* Full clamp + overflow pipeline for a freshly rolled stat block. *)
let resolve_stats (t : species_template) : beast_attributes =
  let stats = roll_base_stats t |> apply_perfect_specimen t in
  let final, _fired = apply_core_crash t stats in
  final

(* ==========================================================
   Diagnostic variants -- same two vectors, but report WHICH
   stats fired instead of just returning final numbers. Used by
   beast_test.ml; the real generation pipeline above is untouched.
   ========================================================== *)

type stat_roll_diagnostics = {
    perfect_specimen_hits : string list; (* stat names that hit exact cap (Vector 2) *)
    core_crash_stat : string option;     (* stat name hit by Vector 1, if it fired *)
}

let apply_perfect_specimen_diag (t : species_template) (stats : beast_attributes) :
    beast_attributes * string list =
  List.fold_left
    (fun (acc, hits) name ->
      let cap = cap_by_name t name in
      let v = stat_by_name acc name in
      if v = cap && cap > 0 then
        (set_stat acc name (v + Random.int (t.perfect_specimen_max_bonus + 1)), name :: hits)
      else (acc, hits))
    (stats, []) stat_names

let apply_core_crash_diag (t : species_template) (stats : beast_attributes) :
    beast_attributes * string option =
  if Random.float 1.0 < t.core_crash_chance then
    let name = List.nth stat_names (Random.int (List.length stat_names)) in
    let v = stat_by_name stats name in
    (set_stat stats name (v + Random.int (t.core_crash_max_bonus + 1)), Some name)
  else (stats, None)

let resolve_stats_diagnostic (t : species_template) : beast_attributes * stat_roll_diagnostics =
  let base = roll_base_stats t in
  let after_specimen, hits = apply_perfect_specimen_diag t base in
  let final, crash_stat = apply_core_crash_diag t after_specimen in
  (final, { perfect_specimen_hits = hits; core_crash_stat = crash_stat })

let is_overloaded (t : species_template) (stats : beast_attributes) (name : string) :
    bool =
  stat_by_name stats name >= cap_by_name t name

(* ==========================================================
   Biome-weighted element injection
   ========================================================== *)

let pick_weighted (options : (element_id * float) list) : element_id =
  let total = List.fold_left (fun acc (_, w) -> acc +. w) 0.0 options in
  let roll = Random.float total in
  let rec go acc = function
    | [] -> fst (List.hd options) (* fallback, should not hit *)
    | (elem, w) :: rest ->
        let acc' = acc +. w in
        if roll <= acc' then elem else go acc' rest
  in
  go 0.0 options

(* "Random Qi Variant" slots resolve into an esoteric/mutated element
   pool rather than a plain typal one. *)
let exotic_variant_pool =
  [ "Whiteflame Qi"; "Glacial Abyss Qi"; "Metal Plague Qi"; "Abyssal Miasma Qi" ]

let roll_injected_element (t : species_template) (b : biome) : element_id =
  match List.assoc_opt b t.spawn_weights with
  | None -> "Standard Earth Qi" (* fallback for an unmapped biome *)
  | Some weights -> (
      match pick_weighted weights with
      | "Random Qi Variant" ->
          List.nth exotic_variant_pool (Random.int (List.length exotic_variant_pool))
      | elem -> elem)

(* ==========================================================
   Synergy Overclocks: overloaded stat x injected element
   ========================================================== *)

let find_synergy (t : species_template) (stats : beast_attributes)
    (injected : element_id) : synergy_entry option =
  List.find_opt
    (fun s -> s.synergy_element = injected && is_overloaded t stats s.stat_name)
    t.synergy_table

(* ==========================================================
   Sentience (derived from clamped+overflowed intelligence)
   ========================================================== *)

let derive_sentience (stats : beast_attributes) : sentience_tier =
  if stats.intelligence >= 80 then
    Heuristic { memory_depth = max 1 (stats.intelligence / 20) }
  else Instinct

(* ==========================================================
   Beast generation (full pipeline)
   ========================================================== *)

let assemble_beast (id : string) (t : species_template) (disp : disposition)
    (b : biome) (location : string) (stats : beast_attributes) : beast =
  let injected_element = roll_injected_element t b in
  let active_synergy = find_synergy t stats injected_element in
  {
    beast_id = id;
    species = t;
    personality = disp;
    stats;
    injected_element;
    secondary_element = None;
    active_synergy;
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

let generate_beast (id : string) (t : species_template) (disp : disposition)
    (b : biome) (location : string) : beast =
  assemble_beast id t disp b location (resolve_stats t)

(* Viability gate: ANY stat hitting exactly 0 is its own distinct
   failure mode -- see stillbirth_cause_for_stat below. A beast is
   only viable if every stat cleared zero. *)
let is_viable (stats : beast_attributes) : bool =
  List.for_all (fun name -> stat_by_name stats name > 0) stat_names

let stillbirth_cause_for_stat (stat_name : string) : stillbirth_cause option =
  match stat_name with
  | "strength" -> Some Structural_Frailty
  | "stamina" -> Some Cardiac_Failure
  | "speed" -> Some Motor_Collapse
  | "intelligence" -> Some Nonfunctional_Brain
  | "wisdom" -> Some Instinctless_Void
  | "creativity" -> Some Behavioral_Rigidity
  | "restraint" -> Some Structural_Rupture
  | _ -> None

(* A beast can fail on more than one stat at once (each stat rolls
   independently) -- this returns ALL causes, not just the first. *)
let stillbirth_causes (stats : beast_attributes) : stillbirth_cause list =
  stat_names
  |> List.filter (fun name -> stat_by_name stats name = 0)
  |> List.filter_map stillbirth_cause_for_stat

let describe_stillbirth_cause = function
  | Structural_Frailty -> "too weak to survive birth"
  | Cardiac_Failure -> "no cardiovascular baseline -- the heart never starts"
  | Motor_Collapse -> "body cannot coordinate movement at all"
  | Nonfunctional_Brain -> "non-functional brain"
  | Instinctless_Void -> "no perceptual/judgment baseline to act on"
  | Behavioral_Rigidity -> "cannot adapt, fails to thrive"
  | Structural_Rupture -> "body has no containment, tears itself apart"

let attempt_spawn (id : string) (t : species_template) (disp : disposition)
    (b : biome) (location : string) : spawn_outcome =
  let stats = resolve_stats t in
  if is_viable stats then Viable (assemble_beast id t disp b location stats)
  else Stillborn (stats, stillbirth_causes stats)

(* Only Heuristic beasts may host a region override — an Instinct-tier
   animal lacks the architecture to sustain it. *)
let promote_to_reality_anchor (b : beast) (radius : int) : (beast, string) result =
  match b.sentience with
  | Instinct ->
      Error
        (Printf.sprintf
           "%s cannot host a reality override: Instinct-tier beasts lack the \
            heuristic architecture to sustain it."
           b.beast_id)
  | Heuristic _ when b.qi_tier < 8 ->
      Error
        (Printf.sprintf
           "%s is Heuristic but only Tier %d — Form Synthesis (Tier 8) is \
            required to sustain a region override."
           b.beast_id b.qi_tier)
  | Heuristic _ -> Ok { b with role = Reality_Anchor { zone_radius = radius } }

(* ==========================================================
   Beast Qi Tier progression + Pack Resonance
   (see Qi_System.md — beasts use hunger as their readiness
   gate instead of stability/mental_bandwidth; formula/numbers
   below are defaults, freely tunable.)
   ========================================================== *)

(* Higher tiers demand a better-fed beast — the ceiling tightens
   as target tier rises. *)
let beast_hunger_ceiling (target_tier : int) : float =
  Float.max 0.05 (0.5 -. (0.04 *. float_of_int target_tier))

let attempt_beast_breakthrough (b : beast) : beast * string =
  if b.qi_tier >= tier_cap then
    (b, Printf.sprintf "%s is already Tier %d (Immortal) — the cap." b.beast_id tier_cap)
  else
    let target = b.qi_tier + 1 in
    let ceiling = beast_hunger_ceiling target in
    if b.hunger > ceiling then
      ( b,
        Printf.sprintf
          "%s is too famished (hunger %.2f > %.2f) to attempt Tier %d." b.beast_id
          b.hunger ceiling target )
    else
      let tolerance_bonus = b.species.mutation_tolerance *. 0.15 in
      let tribulation_penalty = if target = crossing_calamity_tier then 0.25 else 0.0 in
      let success_chance =
        Float.max 0.05 (0.55 +. tolerance_bonus -. tribulation_penalty)
      in
      if Random.float 1.0 < success_chance then
        ( { b with qi_tier = target },
          Printf.sprintf "%s broke through to Tier %d!" b.beast_id target )
      else
        let severity = float_of_int target /. float_of_int tier_cap in
        if target = crossing_calamity_tier && Random.float 1.0 < 0.15 *. severity then
          ( { b with is_sentient = false },
            Printf.sprintf "%s failed to Cross the Calamity — critical failure."
              b.beast_id )
        else
          ( { b with hunger = Float.min 1.0 (b.hunger +. (0.15 *. severity)) },
            Printf.sprintf "%s failed the breakthrough to Tier %d." b.beast_id target )

(* Pack Resonance: a fraction of the alpha's species cap, added to
   each stat of a same-species/same-location pack member — "a
   stronger beast raises the level of the species." Tunable. *)
let pack_stat_bump_fraction = 0.05

let bump_toward_cap (v : int) (cap : int) : int =
  min cap (v + int_of_float (ceil (pack_stat_bump_fraction *. float_of_int cap)))

let empower_pack_member (alpha : beast) (member : beast) : beast * string =
  let t = member.species in
  let stats' =
    {
      strength = bump_toward_cap member.stats.strength t.max_strength;
      stamina = bump_toward_cap member.stats.stamina t.max_stamina;
      speed = bump_toward_cap member.stats.speed t.max_speed;
      intelligence = bump_toward_cap member.stats.intelligence t.max_intelligence;
      wisdom = bump_toward_cap member.stats.wisdom t.max_wisdom;
      creativity = bump_toward_cap member.stats.creativity t.max_creativity;
      restraint = bump_toward_cap member.stats.restraint t.max_restraint;
    }
  in
  let old_tier = member.qi_tier in
  (* Pulled up at most to one tier below the alpha — never leapfrogs
     the beast that caused the resonance. *)
  let new_tier = if old_tier < alpha.qi_tier - 1 then old_tier + 1 else old_tier in
  let tier_note =
    if new_tier <> old_tier then Printf.sprintf ", pulled up to Tier %d" new_tier
    else ""
  in
  ( { member with stats = stats'; qi_tier = new_tier },
    Printf.sprintf "%s feels %s's breakthrough resonate through the pack%s."
      member.beast_id alpha.beast_id tier_note )

(* Applies Pack Resonance to every OTHER beast of the same species in
   the same location. Only called after a confirmed successful
   breakthrough — a failed tribulation does not inspire the pack. *)
let apply_pack_resonance (world : world_state) (alpha : beast) : world_state * string list =
  let is_pack_member (b : beast) =
    b.beast_id <> alpha.beast_id
    && b.species.species_name = alpha.species.species_name
    && b.location = alpha.location
  in
  let updated_beasts, logs =
    List.fold_left
      (fun (acc, logs) b ->
        if is_pack_member b then
          let b', log = empower_pack_member alpha b in
          (b' :: acc, logs @ [ log ])
        else (b :: acc, logs))
      ([], []) world.beasts
  in
  ({ world with beasts = List.rev updated_beasts }, logs)

(* Full event: resolves the breakthrough attempt against the beast
   roster, and on success cascades Pack Resonance to nearby kin. *)
let beast_breakthrough_event (world : world_state) (beast_id : string) :
    world_state * string list =
  match List.find_opt (fun b -> b.beast_id = beast_id) world.beasts with
  | None -> (world, [ Printf.sprintf "Unknown beast id %s" beast_id ])
  | Some b ->
      let b', log = attempt_beast_breakthrough b in
      let beasts' = b' :: List.filter (fun x -> x.beast_id <> beast_id) world.beasts in
      let world' = { world with beasts = beasts' } in
      if b'.qi_tier > b.qi_tier then
        let world'', pack_logs = apply_pack_resonance world' b' in
        (world'', log :: pack_logs)
      else (world', [ log ])

(* ==========================================================
   Lineage: heritable trait inheritance across generations
   ========================================================== *)

let trait_prune_threshold = 0.05 (* traits fade out of the bloodline below this *)

let dilute_trait (t : lineage_trait) : lineage_trait = { t with potency = t.potency *. 0.5 }

(* Merges two parents' lineage_traits into a child's set. A trait
   carried by BOTH parents is reinforced (max potency, no dilution —
   this is how a bloodline trait "breeds true"). A trait unique to
   one parent is diluted by half, and pruned entirely if it falls
   below trait_prune_threshold. *)
let merge_lineage_traits (p1 : lineage_trait list) (p2 : lineage_trait list) :
    lineage_trait list =
  let shared_and_unique =
    List.map
      (fun t1 ->
        match List.find_opt (fun t2 -> t2.trait_name = t1.trait_name) p2 with
        | Some t2 -> { t1 with potency = Float.max t1.potency t2.potency }
        | None -> dilute_trait t1)
      p1
  in
  let p2_only =
    List.filter_map
      (fun t2 ->
        if List.exists (fun t1 -> t1.trait_name = t2.trait_name) p1 then None
        else Some (dilute_trait t2))
      p2
  in
  shared_and_unique @ p2_only |> List.filter (fun t -> t.potency >= trait_prune_threshold)

let string_of_sex = function Male -> "Male" | Female -> "Female"

(* Builds a child cultivator's lineage bookkeeping. Ancestry/nationality/
   ethnicity/disposition/starting vitals/child's own sex are still the
   caller's choice — this owns generation, parent_ids, trait inheritance,
   AND the biological gate: by default, natural conception requires one
   Male and one Female parent. Pass ~fertility_override:true only when a
   specific elixir/ability (once Qi_Abilities.md defines one) grants an
   exception — this function doesn't know about those yet, it just
   trusts the caller's flag. *)
let spawn_child ?(fertility_override = false) (id : string) (parent1 : cultivator)
    (parent2 : cultivator) (child_sex : sex) (ancestry : ancestry)
    (nationality : nationality) (ethnicity : ethnicity) (disposition : disposition)
    (affinities : affinity_set) : (cultivator, string) result =
  if (not fertility_override) && parent1.sex = parent2.sex then
    Error
      (Printf.sprintf
         "%s and %s are both %s — natural conception requires one Male and \
          one Female parent. Pass fertility_override:true if an elixir or \
          ability grants an exception."
         parent1.id parent2.id (string_of_sex parent1.sex))
  else
    Ok
      {
        id;
        ancestry;
        nationality;
        ethnicity;
        sex = child_sex;
        affinities;
        morality_stain = (parent1.morality_stain +. parent2.morality_stain) /. 2.0;
        stability = 0.7;
        mental_bandwidth = (parent1.mental_bandwidth +. parent2.mental_bandwidth) /. 2.0;
        is_sentient = true;
        is_renegade = false;
        disposition;
        control = Autonomous;
        lineage_traits = merge_lineage_traits parent1.lineage_traits parent2.lineage_traits;
        parent_ids = [ parent1.id; parent2.id ];
        generation = max parent1.generation parent2.generation + 1;
        qi_tier = 0;
      }

(* ==========================================================
   Hua Xing: beast-to-human transformation (rare, and meant to
   stay that way — meeting requirements is necessary, not
   sufficient; there is still a low stochastic roll on top).
   ========================================================== *)

let trait_from_beast (b : beast) : lineage_trait =
  let trait_name =
    match b.active_synergy with
    | Some s -> s.synergy_name
    | None -> b.species.species_name ^ " Heritage"
  in
  let potency = Float.min 1.0 (0.3 +. (0.07 *. float_of_int b.qi_tier)) in
  { trait_name; potency; trait_source = b.species.species_name }

(* Necessary-but-not-sufficient prerequisite check. Does NOT roll the
   stochastic success chance — that's attempt_beast_transformation's job. *)
let meets_transformation_reqs (b : beast) : bool =
  match b.species.transformation_reqs with
  | None -> false
  | Some req ->
      b.qi_tier >= req.min_qi_tier
      && b.stats.intelligence >= req.min_intelligence
      && (match b.sentience with
         | Heuristic { memory_depth } -> memory_depth >= req.min_memory_depth
         | Instinct -> false)
      && List.exists
           (fun s ->
             s.skill_name = req.required_skill
             && s.mastery >= req.min_mastery
             && not s.dormant)
           b.skill_library

(* A failed Hua Xing attempt is a real cost, not a free retry: the
   beast comes back with less energy and weaker combat stats (fed
   directly into beast_power, so this genuinely makes it easier to
   subdue/prey upon afterward -- not just flavor text). *)
let weaken_from_failed_transformation (b : beast) : beast =
  {
    b with
    hunger = Float.min 1.0 (b.hunger +. 0.4);
    stats =
      {
        b.stats with
        strength = max 1 (b.stats.strength * 7 / 10);
        stamina = max 1 (b.stats.stamina * 7 / 10);
        speed = max 1 (b.stats.speed * 7 / 10);
      };
  }

let attempt_beast_transformation (b : beast) (new_id : string) (new_sex : sex)
    (ancestry : ancestry) (nationality : nationality) (ethnicity : ethnicity) :
    transformation_result =
  match b.species.transformation_reqs with
  | None ->
      Not_Ready
        (Printf.sprintf
           "%s's species lacks the metaphysical architecture to ever undergo \
            Hua Xing."
           b.beast_id)
  | Some req ->
      if not (meets_transformation_reqs b) then
        Not_Ready
          (Printf.sprintf
             "%s does not meet Hua Xing prerequisites (needs Qi Tier >= %d, \
              INT >= %d, Heuristic memory depth >= %d, and '%s' mastered >= \
              %.2f)."
             b.beast_id req.min_qi_tier req.min_intelligence req.min_memory_depth
             req.required_skill req.min_mastery)
      else if Random.float 1.0 > req.base_success_chance then
        Failed_Attempt
          ( weaken_from_failed_transformation b,
            Printf.sprintf
              "%s attempted Hua Xing and FAILED — the transformation rejected \
               the beast's core. It survives, but leaves weakened and \
               famished, significantly more vulnerable than before."
              b.beast_id )
      else
        let trait = trait_from_beast b in
        Transformed
          {
            id = new_id;
            ancestry;
            nationality;
            ethnicity;
            sex = new_sex;
            affinities = { base_affinities = [ b.injected_element; "Beast" ]; evolved_affinity = None };
            morality_stain = 0.3;
            stability = 0.6;
            mental_bandwidth = float_of_int b.stats.wisdom /. 10.0;
            is_sentient = true;
            is_renegade = false;
            disposition = b.personality;
            control = Autonomous;
            lineage_traits = [ trait ];
            parent_ids = [];
            generation = 0;
            qi_tier = b.qi_tier;
          }



let sustenance_tick (b : beast) (region : kernel_state) (food_available : bool) :
    beast * kernel_state * string =
  if food_available then
    ( { b with sustenance = Predation; hunger = Float.max 0.0 (b.hunger -. 0.3) },
      region,
      Printf.sprintf "%s preys on local wildlife to stay stable." b.beast_id )
  else
    let region' =
      {
        region with
        entropy = region.entropy +. 2.0;
        stability = Float.max 0.0 (region.stability -. 0.05);
      }
    in
    ( { b with sustenance = Qi_Siphon; hunger = Float.max 0.0 (b.hunger -. 0.15) },
      region',
      Printf.sprintf
        "%s has no prey; siphons ambient %s from the tile, draining its \
         regional spirit reservoir."
        b.beast_id b.injected_element )

(* ==========================================================
   Qi Tier progression (see Qi_System.md — tuning defaults,
   not locked in: swap for a hand-authored table per tier if
   the formula curve doesn't feel right in playtesting).
   ========================================================== *)

let stability_floor (target_tier : int) : float = 0.08 *. float_of_int target_tier
let bandwidth_floor (target_tier : int) : float = 1.0 +. (0.6 *. float_of_int target_tier)

(* Breakthrough failure hurts more at higher tiers, and Crossing
   Calamity (9) is deliberately the harshest — true to the
   "heavenly tribulation" trope and the blueprint's "catastrophic
   cost of forcing a Redline breakthrough." *)
let breakthrough_failure_consequence (c : cultivator) (target_tier : int) :
    cultivator * string =
  let severity = float_of_int target_tier /. float_of_int tier_cap in
  if target_tier = crossing_calamity_tier && Random.float 1.0 < 0.15 *. severity then
    (* Worst case: the tribulation nearly kills them *)
    ( { c with is_sentient = false; stability = 0.0 },
      Printf.sprintf
        "%s failed to Cross the Calamity. The tribulation overwhelmed them — \
         critical failure."
        c.id )
  else
    ( {
        c with
        stability = Float.max 0.0 (c.stability -. (0.1 *. severity));
        ancestry =
          {
            c.ancestry with
            core_trait = c.ancestry.core_trait ^ " [OVERWRITTEN: Deviant Protocol]";
          };
      },
      Printf.sprintf
        "%s failed the breakthrough to Tier %d. Stability shaken, core trait \
         overwritten — Deviant Protocol acquired."
        c.id target_tier )

let attempt_breakthrough (c : cultivator) : cultivator * string =
  if c.qi_tier >= tier_cap then
    (c, Printf.sprintf "%s is already at Tier %d (Immortal) — the cap." c.id tier_cap)
  else
    let target = c.qi_tier + 1 in
    let s_floor = stability_floor target and b_floor = bandwidth_floor target in
    if c.stability < s_floor || c.mental_bandwidth < b_floor then
      ( c,
        Printf.sprintf
          "%s is not ready for Tier %d (needs stability >= %.2f [has %.2f], \
           mental_bandwidth >= %.2f [has %.2f])."
          c.id target s_floor c.stability b_floor c.mental_bandwidth )
    else
      let ancestry_bonus = if c.ancestry.affinity_unlock then 0.1 else 0.0 in
      let tribulation_penalty = if target = crossing_calamity_tier then 0.25 else 0.0 in
      let success_chance =
        Float.max 0.05 (0.6 +. ancestry_bonus -. tribulation_penalty)
      in
      if Random.float 1.0 < success_chance then
        ( { c with qi_tier = target },
          Printf.sprintf "%s broke through to Tier %d!" c.id target )
      else breakthrough_failure_consequence c target



let beast_power (b : beast) : float =
  float_of_int (b.stats.strength + b.stats.stamina + b.stats.speed) /. 3.0

(* A pregnant beast fights to defend territory far harder — this is
   deliberately a big penalty to the tamer's effective stability, not
   a small nudge, since "will defend territory" should mean something
   mechanically, not just flavor text. Tunable. *)
let pregnancy_defense_penalty (b : beast) : float =
  match b.reproductive_status with
  | Not_Pregnant -> 0.0
  | Pregnant _ -> 0.35

let personality_conflict (p : disposition) (morality_stain : float) : float =
  match p with
  | Scheming -> if morality_stain > 0.5 then -0.2 else 0.1
  | Proud -> if morality_stain < 0.2 then 0.15 else -0.15
  | Docile -> 0.2
  | Feral -> -0.3
  | Calculating -> if morality_stain > 0.7 then -0.25 else 0.05
  | Ambitious -> if morality_stain > 0.4 then -0.1 else 0.15
  | Loyal -> 0.25
  | Cautious -> 0.1
  | Reckless -> -0.2

let interface_beast (c : cultivator) (b : beast) : cultivator * beast * string =
  let conflict_mod = personality_conflict b.personality c.morality_stain in
  let effective_stability =
    c.stability +. conflict_mod -. (beast_power b *. 0.01) -. pregnancy_defense_penalty b
  in
  let pregnancy_note =
    match b.reproductive_status with
    | Pregnant _ -> " — it is pregnant and fighting to defend its territory"
    | Not_Pregnant -> ""
  in
  if effective_stability < 0.3 then
    ( { c with is_sentient = false; stability = effective_stability },
      b,
      Printf.sprintf
        "KERNEL PANIC: %s failed to interface with %s%s. Hybrid-Failure \
         triggered — character is now a hostile, non-sentient drain node."
        c.id b.beast_id pregnancy_note )
  else
    ( { c with stability = effective_stability },
      b,
      Printf.sprintf "%s successfully interfaced with %s%s (stability %.2f)" c.id
        b.beast_id pregnancy_note effective_stability )

(* ==========================================================
   Qi Events: Spiritual decompression
   ========================================================== *)

let decompression_check (c : cultivator) (realm_depth : float) : cultivator * string =
  let entropy_load = realm_depth *. 1.5 in
  if entropy_load > c.mental_bandwidth then
    ( {
        c with
        ancestry =
          {
            c.ancestry with
            core_trait = c.ancestry.core_trait ^ " [OVERWRITTEN: Deviant Protocol]";
          };
      },
      Printf.sprintf
        "%s exceeded mental bandwidth (%.2f > %.2f). Core trait overwritten — \
         Deviant Protocol acquired."
        c.id entropy_load c.mental_bandwidth )
  else
    (* Reward scales with danger RELATIVE TO THIS CHARACTER, not raw
       realm_depth -- the same depth is trivial for a high-bandwidth
       cultivator and near-fatal for a low-bandwidth one, and the
       reward should reflect what it cost THEM, not the map's number.
       relative_danger approaches 1.0 as the attempt nearly overwhelms
       them; a floor is added to both gains so even a trivial dangerous-
       area attempt beats staying home (Cultivate), just barely. *)
    let relative_danger = entropy_load /. c.mental_bandwidth in
    let stability_gain = 0.02 +. (0.15 *. relative_danger) in
    let bandwidth_gain = 0.05 +. (0.5 *. relative_danger) in
    ( {
        c with
        stability = Float.min 1.0 (c.stability +. stability_gain);
        mental_bandwidth = c.mental_bandwidth +. bandwidth_gain;
      },
      Printf.sprintf
        "%s survived decompression (%.2f / %.2f bandwidth, %.0f%% relative \
         danger) — stability +%.3f, mental_bandwidth +%.3f"
        c.id entropy_load c.mental_bandwidth (relative_danger *. 100.0)
        stability_gain bandwidth_gain )

(* ==========================================================
   Nationality firmware locks
   ========================================================== *)

let override_firmware_lock (c : cultivator) (elem : element_id) : cultivator * string =
  if List.mem elem c.nationality.firmware_locks then
    ( { c with is_renegade = true },
      Printf.sprintf "%s overrode firmware lock on %s. Flagged as RENEGADE." c.id elem )
  else
    (c, Printf.sprintf "%s attempted override on %s but no lock existed." c.id elem)

(* ==========================================================
   Reality Anchor tick
   ========================================================== *)

let apply_reality_override (region : kernel_state) (host : beast) : kernel_state =
  match host.role with
  | Reality_Anchor _ when host.is_sentient ->
      {
        region with
        stability = 0.1;
        entropy = region.entropy +. (beast_power host *. 0.5);
        hosted_by = Some host.beast_id;
      }
  | _ -> { region with hosted_by = None }

(* ==========================================================
   Autonomous decision-making (disposition-driven AI)
   ========================================================== *)

let decide_action (c : cultivator) : action =
  match c.disposition with
  | Docile | Loyal | Cautious -> Cultivate
  | Scheming | Calculating ->
      if c.qi_tier >= 5 && c.affinities.evolved_affinity = None then AttemptEvolution
      else AttemptBreakthrough
  | Ambitious ->
      if c.qi_tier >= 5 && c.affinities.evolved_affinity = None then AttemptEvolution
      else AttemptBreakthrough
  | Feral | Reckless -> EnterQiEvent 5.0
  | Proud -> (
      match c.nationality.firmware_locks with
      | elem :: _ -> OverrideFirmwareLock elem
      | [] -> AttemptBreakthrough)

(* ==========================================================
   Turn scheduler — 1 action per turn per character
   ========================================================== *)

let resolve_action (world : world_state) (c : cultivator) (act : action) :
    cultivator * world_state * string =
  match act with
  | Cultivate -> (c, world, Printf.sprintf "%s cultivates quietly." c.id)
  | AttemptEvolution ->
      if c.qi_tier < 5 then
        ( c,
          world,
          Printf.sprintf
            "%s cannot attempt evolution below Tier 5 (Nascent Soul) — currently \
             Tier %d."
            c.id c.qi_tier )
      else (
        match attempt_evolution c.affinities with
        | Ok new_aff ->
            ( { c with affinities = new_aff },
              world,
              Printf.sprintf "%s evolved a third affinity!" c.id )
        | Error msg -> (c, world, Printf.sprintf "%s evolution failed: %s" c.id msg))
  | InterfaceBeast b ->
      let c', _, log = interface_beast c b in
      (c', world, log)
  | EnterQiEvent depth ->
      let c', log = decompression_check c depth in
      (c', world, log)
  | OverrideFirmwareLock elem ->
      let c', log = override_firmware_lock c elem in
      (c', world, log)
  | AttemptBreakthrough ->
      let c', log = attempt_breakthrough c in
      (c', world, log)
  | MergeKernels (r1, r2) -> (
      match (List.assoc_opt r1 world.regions, List.assoc_opt r2 world.regions) with
      | Some k1, Some k2 ->
          let merged = merge_kernels k1 k2 in
          let regions' =
            (r1, merged) :: List.remove_assoc r1 (List.remove_assoc r2 world.regions)
          in
          ( c,
            { world with regions = regions' },
            Printf.sprintf
              "%s force-merged kernels %s+%s (stability %.2f, entropy %.2f)" c.id
              r1 r2 merged.stability merged.entropy )
      | _ -> (c, world, "Kernel merge failed: region not found"))

let plan_turn (world : world_state) (player_actions : (string * action) list) :
    (string * action) list =
  let planned =
    List.map
      (fun c ->
        match c.control with
        | PlayerPiloted -> (
            match List.assoc_opt c.id player_actions with
            | Some act -> (c.id, act)
            | None ->
                failwith
                  (Printf.sprintf
                     "Turn error: %s is PlayerPiloted but has no assigned \
                      action this turn."
                     c.id))
        | Autonomous -> (c.id, decide_action c))
      world.population
  in
  let ids = List.map fst planned in
  if List.length ids <> List.length (List.sort_uniq compare ids) then
    failwith
      "Turn violation: a character was assigned more than one action this \
       turn (1 action per turn per character)."
  else planned

let advance_turn (world : world_state) (actions : (string * action) list) :
    world_state * string list =
  List.fold_left
    (fun (w, logs) (cid, act) ->
      match List.find_opt (fun c -> c.id = cid) w.population with
      | None -> (w, logs @ [ Printf.sprintf "Unknown character id %s" cid ])
      | Some c ->
          let c', w', log = resolve_action w c act in
          let population' = c' :: List.filter (fun x -> x.id <> cid) w'.population in
          ({ w' with population = population' }, logs @ [ log ]))
    (world, []) actions

let step_turn (world : world_state) (player_actions : (string * action) list) :
    world_state =
  let actions = plan_turn world player_actions in
  let world', logs = advance_turn world actions in
  { world' with year = world'.year + 1; archive_logs = world'.archive_logs @ logs }

(* ==========================================================
   Asset pulling -- maps a beast's element(s) to the artist's
   actual PNG and opens it in the default viewer. Shared by any
   test/tool that needs to visually confirm a spawn.
   ========================================================== *)

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
   roll_injected_element entirely, for tests that need a specific,
   art-backed element pair. The real generation pipeline
   (generate_beast/attempt_spawn) is untouched; secondary_element
   stays None there until a real roll mechanism for it is designed. *)
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

(* Opens a beast's asset image in the default viewer if it exists.
   Windows-only ('start' is a Windows shell builtin). Returns whether
   the file was found, so callers can report success/failure. *)
let pull_and_show_image (b : beast) : bool =
  let filename = asset_filename_for b.species.species_name b.injected_element b.secondary_element in
  let full_path = assets_folder ^ filename in
  Printf.printf "Asset path: %s\n" full_path;
  if Sys.file_exists full_path then begin
    Printf.printf "File found -- opening in default viewer...\n";
    (* The empty "" is a required argument slot for 'start' (a window
       title) when the path itself is quoted -- omitting it breaks
       paths containing spaces, which yours has ("Iron-Flesh Tiger.png"). *)
    let command = Printf.sprintf "start \"\" \"%s\"" full_path in
    ignore (Sys.command command);
    true
  end
  else begin
    Printf.printf "File NOT found at that path -- check the filename/folder match exactly.\n";
    false
  end