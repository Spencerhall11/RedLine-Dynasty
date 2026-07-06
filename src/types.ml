(* ==========================================================
   RedLine Dynasty — Core Types
   ========================================================== *)

(* definition of Qi element *)
type element_id = string

(* 2+1 rule: tracks base and unlocked evolved *)
type affinity_set = {
    base_affinities : element_id list; (* limit of 2 *)
    evolved_affinity : element_id option; (* 3rd slot, starts blank *)
}

(* Foundation: base stats *)
type ancestry = {
    id : string;
    res_multiplies : (element_id * float) list;
    core_trait : string;
    stability_penalty : float; (* e.g. Void-Touched pays a stability tax *)
    affinity_unlock : bool;    (* bypasses standard training protocols *)
}

(* Environment: early game enhancements *)
type nationality = {
    id : string;
    firmware_locks : element_id list;
    growth_bonus : float;
}

(* Culture: Social protocols *)
type ethnicity = {
    id : string;
    social_scripts : string list;
}

(* Kernel: geographical energy state and source *)
type kernel_state = {
    elements : element_id list;
    stability : float;
    entropy : float;
    hosted_by : string option; (* beast_id of a living Reality_Anchor, if any *)
}

(* Disposition: shared temperament model — drives beast interface
   compatibility checks AND autonomous cultivator decision-making *)
type disposition =
  | Scheming
  | Proud
  | Docile
  | Feral
  | Calculating
  | Ambitious
  | Loyal
  | Cautious
  | Reckless

(* ==========================================================
   Beast subsystem: stochastic stats, sentience, reality anchors
   ========================================================== *)

(* Rolled/clamped attributes — 7 stats. Intelligence remains the
   load-bearing stat for sentience_tier; wisdom/creativity/restraint
   feed the Synergy Overclock system below. *)
type beast_attributes = {
    strength : int;
    stamina : int;
    speed : int;
    intelligence : int;
    wisdom : int;
    creativity : int;
    restraint : int;
}

let stat_by_name (a : beast_attributes) (name : string) : int =
  match name with
  | "strength" -> a.strength
  | "stamina" -> a.stamina
  | "speed" -> a.speed
  | "intelligence" -> a.intelligence
  | "wisdom" -> a.wisdom
  | "creativity" -> a.creativity
  | "restraint" -> a.restraint
  | _ -> 0

(* Which biome cell a spawn/sustenance check is happening on. Extend
   as your world's biome list grows. *)
type biome =
  | Forest_Cell
  | Industrial_Cell
  | Coastal_Cell
  | Desert_Cell
  | Plains_Cell
  | Mountain_Cell
  | Mountain_Peak_Cell
  | Ice_Cell
  | Glacial_Cell

(* A synergy fires when a specific stat is "overloaded" (rolled at/near
   its cap, or blew past it via Stochastic Boundary Overflow) while the
   beast carries a matching injected element. *)
type synergy_entry = {
    stat_name : string;       (* matches a beast_attributes field name *)
    synergy_element : element_id;
    synergy_name : string;
    synergy_desc : string;    (* short macro-behavior summary *)
}

(* Prerequisites for a beast attempting Hua Xing (beast-to-human
   transformation). Meeting these is necessary but NOT sufficient —
   see attempt_beast_transformation in logic.ml, which still rolls
   against base_success_chance on top. *)
type transformation_requirements = {
    min_qi_tier : int;
    min_intelligence : int;
    min_memory_depth : int;   (* requires Heuristic sentience at this depth *)
    required_skill : string;
    min_mastery : float;
    base_success_chance : float; (* deliberately low — this is meant to be rare *)
}

(* Species firmware template: hard ceilings a beast's rolled stats are
   clamped against (before Stochastic Boundary Overflow may break
   them), plus the data that drives spawn injection and synergies. *)
type species_template = {
    species_name : string;
    max_strength : int;
    max_stamina : int;
    max_speed : int;
    max_intelligence : int;
    max_wisdom : int;
    max_creativity : int;
    max_restraint : int;
    mutation_tolerance : float;
    (* Stochastic Boundary Overflow config *)
    core_crash_chance : float;       (* e.g. 0.005 *)
    core_crash_max_bonus : int;      (* e.g. 40 *)
    perfect_specimen_max_bonus : int; (* e.g. 30 *)
    (* Per-biome element injection weights: (element_id * weight) list,
       weights need not sum to 1.0 — treated as relative shares. *)
    spawn_weights : (biome * (element_id * float) list) list;
    synergy_table : synergy_entry list;
    transformation_reqs : transformation_requirements option; (* None = species cannot undergo Hua Xing *)
}

(* Sentience tier is DERIVED from clamped intelligence, not asserted
   directly, so it can't be set inconsistently with stats. *)
type sentience_tier =
  | Instinct                          (* Tier 0: deterministic fight/flight *)
  | Heuristic of { memory_depth : int } (* Tier 1: tracks and adapts to the player *)

(* Whether a beast is just transient wildlife or capable of anchoring
   a Spirit Realm override on a region. Only Heuristic beasts may be
   a Reality_Anchor — enforced at construction time in logic.ml. *)
type beast_role =
  | Transient_Wildlife
  | Reality_Anchor of { zone_radius : int }

(* A learned heuristic/skill. Unused skills decay in mastery but are
   archived (dormant), never deleted — avoids both unbounded growth
   and the "Perfect Build" problem of skills being free to relearn
   at full strength. *)
type managed_skill = {
    skill_name : string;
    mastery : float;   (* 0.0 - 1.0 *)
    dormant : bool;
}

(* Biological sex — shared by cultivators and beasts. Needed for the
   art-pool lookup system, for gating natural cultivator reproduction
   in spawn_child, and for beast pregnancy/territorial behavior. *)
type sex = Male | Female

(* Pregnancy is state, not just a bool, since duration matters for
   how long territorial-defense behavior should persist. *)
type reproductive_state =
  | Not_Pregnant
  | Pregnant of { turns_remaining : int }

(* Sustenance: predation is the baseline; Qi-siphon is the fallback
   when local organic food is exhausted, and it drains the tile. *)
type sustenance_mode =
  | Predation
  | Qi_Siphon

(* Beast: driver-interface target for hybridization *)
type beast = {
    beast_id : string;
    species : species_template;
    personality : disposition;
    stats : beast_attributes;          (* post-clamp, may exceed caps via overflow *)
    injected_element : element_id;     (* rolled from spawn_weights at spawn *)
    secondary_element : element_id option; (* a beast can carry two elements at once -- None in the real spawn pipeline for now; how this gets rolled naturally is still open *)
    active_synergy : synergy_entry option; (* set if an overload+element match fired *)
    sentience : sentience_tier;
    role : beast_role;
    is_sentient : bool;                (* flips false if it dies / is subdued *)
    qi_tier : int;                     (* 0 (Base) - 10 (Immortal) — see Qi_System.md *)
    skill_library : managed_skill list;
    sustenance : sustenance_mode;
    hunger : float;                    (* 0.0 (fed) - 1.0 (starving) *)
    location : string;                 (* region_id, matches kernel_state keys in world_state.regions *)
    sex : sex;
    reproductive_status : reproductive_state;
}

(* Each stat has its own failure mode at 0 -- a stillbirth isn't generic,
   it's a specific developmental catastrophe. Strength/Intelligence/
   Restraint flavors are settled; Speed/Wisdom/Creativity are proposed
   defaults, not final calls -- adjust freely. Stamina isn't a
   MISSING case: it's just handled as Cardiac_Failure below, same idea
   as the others. *)
type stillbirth_cause =
  | Structural_Frailty  (* strength = 0: too weak to survive birth *)
  | Cardiac_Failure     (* stamina = 0: no cardiovascular baseline *)
  | Motor_Collapse      (* speed = 0: body cannot coordinate movement at all *)
  | Nonfunctional_Brain (* intelligence = 0: no cognitive function *)
  | Instinctless_Void   (* wisdom = 0: no perceptual/judgment baseline to act on *)
  | Behavioral_Rigidity (* creativity = 0: cannot adapt, fails to thrive *)
  | Structural_Rupture  (* restraint = 0: body has no containment, tears itself apart *)

(* Result of a spawn attempt. A beast can fail to form a viable body
   at all (Stillborn) -- no beast record, no art asset, just a logged
   "born and died here" event carrying which specific cause(s) fired.
   A list, not a single cause, since more than one stat can roll 0
   at once. See logic.ml's stillbirth_causes / attempt_spawn. *)
type spawn_outcome =
  | Stillborn of beast_attributes * stillbirth_cause list
  | Viable of beast

(* Who decides this character's action each turn *)
type control_mode =
  | PlayerPiloted   (* player supplies the action explicitly this turn *)
  | Autonomous      (* engine decides via decide_action, based on disposition *)

(* A heritable trait, either rolled from ancestry or seeded by a
   beast transformation. potency dilutes across generations unless
   reinforced (e.g. by cultivation, or a second parent carrying the
   same trait_name). *)
type lineage_trait = {
    trait_name : string;
    potency : float;      (* 0.0 - 1.0 *)
    trait_source : string; (* species/ancestor id this trait came from *)
}

(* The Character: The character node *)
type cultivator = {
    id : string;
    ancestry : ancestry;
    nationality : nationality;
    ethnicity : ethnicity;
    sex : sex;
    affinities : affinity_set; (* This enforces the 2+1 rule *)
    morality_stain : float;
    stability : float;         (* character's own stability index *)
    mental_bandwidth : float;  (* ceiling for Qi Event decompression checks *)
    is_sentient : bool;        (* flips false on Kernel Panic *)
    is_renegade : bool;        (* flagged after overriding a firmware lock *)
    disposition : disposition; (* drives autonomous decision-making *)
    control : control_mode;
    lineage_traits : lineage_trait list; (* inherited from parents / a beast origin *)
    parent_ids : string list;            (* 0, 1 (beast-born), or 2 entries *)
    generation : int;
    qi_tier : int; (* 0 (Base) - 10 (Immortal) — see Qi_System.md *)
}

(* Three genuinely different outcomes, not two -- Not_Ready costs
   nothing (you never actually attempted), but Failed_Attempt means
   the beast rolled and lost: it comes back weakened, not unchanged.
   See logic.ml's attempt_beast_transformation / weaken_from_failed_transformation. *)
type transformation_result =
  | Transformed of cultivator
  | Not_Ready of string
  | Failed_Attempt of beast * string

(* World State *)
type world_state = {
    year : int;
    regions : (string * kernel_state) list;
    population : cultivator list;
    beasts : beast list;
    archive_logs : string list;
}

(* ==========================================================
   Turn/Action model — 1 action per turn per character
   ========================================================== *)
type action =
  | Cultivate
  | MergeKernels of string * string        (* region_id, region_id *)
  | AttemptEvolution
  | InterfaceBeast of beast
  | EnterQiEvent of float                  (* realm depth *)
  | OverrideFirmwareLock of element_id
  | AttemptBreakthrough                    (* advance qi_tier by 1 *)