#define SKILL_NONE     1
#define SKILL_BASIC    2
#define SKILL_ADEPT    3
#define SKILL_EXPERT   4
#define SKILL_PROF     5
#define HAS_PERK       SKILL_NONE + 1

#define SKILL_MIN      1 // Min skill value selectable
#define SKILL_MAX      5 // Max skill value selectable
#define SKILL_DEFAULT  4 //most mobs will default to this

#define SKILL_EASY     1
#define SKILL_AVERAGE  2
#define SKILL_HARD     4

#define SKILL_LITERACY      /decl/hierarchy/skill/organizational/literacy
#define SKILL_FINANCE       /decl/hierarchy/skill/organizational/finance
#define SKILL_EVA           /decl/hierarchy/skill/general/eva
#define SKILL_MECH          /decl/hierarchy/skill/general/eva/mech
#define SKILL_PILOT         /decl/hierarchy/skill/general/pilot
#define SKILL_AGILITY		/decl/hierarchy/skill/health/agility
#define SKILL_STRENGTH		/decl/hierarchy/skill/health/strength
#define SKILL_FITNESS		/decl/hierarchy/skill/health/fitness
#define SKILL_COMPUTER      /decl/hierarchy/skill/general/computer
#define SKILL_BOTANY        /decl/hierarchy/skill/service/botany
#define SKILL_COOKING       /decl/hierarchy/skill/service/cooking
#define SKILL_COMBAT        /decl/hierarchy/skill/security/combat
#define SKILL_WEAPONS       /decl/hierarchy/skill/security/weapons
#define SKILL_FORENSICS     /decl/hierarchy/skill/security/forensics
#define SKILL_CONSTRUCTION  /decl/hierarchy/skill/engineering/construction
#define SKILL_ELECTRICAL    /decl/hierarchy/skill/engineering/electrical
#define SKILL_ATMOS         /decl/hierarchy/skill/engineering/atmos
#define SKILL_ENGINES       /decl/hierarchy/skill/engineering/engines
#define SKILL_DEVICES       /decl/hierarchy/skill/research/devices
#define SKILL_SCIENCE       /decl/hierarchy/skill/research/science
#define SKILL_MEDICAL       /decl/hierarchy/skill/medical/medical
#define SKILL_ANATOMY       /decl/hierarchy/skill/medical/anatomy
#define SKILL_CHEMISTRY     /decl/hierarchy/skill/medical/chemistry

//Modifiers for attack cooldowns.
#define SKILL_COMBAT_ATTACK_COOLDOWN_NONE	 1.1
#define SKILL_COMBAT_ATTACK_COOLDOWN_BASIC	 1
#define SKILL_COMBAT_ATTACK_COOLDOWN_ADEPT	 0.9
#define SKILL_COMBAT_ATTACK_COOLDOWN_EXPERT  0.75
#define SKILL_COMBAT_ATTACK_COOLDOWN_PROF	 0.6