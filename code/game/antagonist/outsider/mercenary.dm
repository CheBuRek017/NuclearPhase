/decl/special_role/mercenary
	name = "Raider"
	antag_indicator = "hudsyndicate"
	name_plural = "Raiders"
	landmark_id = "Raider-Spawn"
	leader_welcome_text = "You are the leader of the mercenary strikeforce; hail to the chief. Use :t to speak to your underlings."
	welcome_text = "To speak on the strike team's private channel use :t."
	flags = ANTAG_VOTABLE | ANTAG_OVERRIDE_JOB | ANTAG_OVERRIDE_MOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_CHOOSE_NAME | ANTAG_HAS_NUKE | ANTAG_SET_APPEARANCE | ANTAG_HAS_LEADER
	antaghud_indicator = "hudoperative"

	hard_cap = 4
	hard_cap_round = 8
	initial_spawn_req = 4
	initial_spawn_target = 6
	min_player_age = 14

	faction = "raiders"

	base_to_load = "Raider Base"
	default_outfit = /decl/hierarchy/outfit/mercenary

/decl/special_role/mercenary/create_global_objectives()
	if(!..())
		return 0
	global_objectives = list()
	global_objectives |= new /datum/objective/nuclear
	return 1