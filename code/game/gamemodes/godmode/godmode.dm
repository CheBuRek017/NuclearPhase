/decl/game_mode/godmode
	name = "Deity"
	round_description = "An otherworldly beast has turned its attention to you and your fellow cremembers."
	extended_round_description = "The station has been infiltrated by a fanatical group of death-cultists! They will use powers from beyond your comprehension to subvert you to their cause and ultimately please their gods through sacrificial summons and physical immolation! Try to survive!"
	uid = "god"
	required_players = 10
	required_enemies = 3
	end_on_antag_death = FALSE
	associated_antags = list(
		/decl/special_role/deity,
		/decl/special_role/godcultist
	)
	votable = FALSE