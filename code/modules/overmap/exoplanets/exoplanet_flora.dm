//Generates initial generic alien plants
/obj/effect/overmap/visitable/sector/exoplanet/proc/generate_flora()

	var/datum/level_data/level_data = zlevels[1]
	var/temperature = level_data?.exterior_atmosphere?.temperature || T20C

	for(var/i = 1 to flora_diversity)
		var/datum/seed/S = new()
		S.randomize(temperature)
		var/planticon = "alien[rand(1,4)]"
		S.set_trait(TRAIT_PRODUCT_ICON,planticon)
		S.set_trait(TRAIT_PLANT_ICON,planticon)
		var/color = pick(plant_colors)
		if(color == "RANDOM")
			color = get_random_colour(0,75,190)
		S.set_trait(TRAIT_PLANT_COLOUR,color)
		var/carnivore_prob = rand(100)
		if(carnivore_prob < 10)
			S.set_trait(TRAIT_CARNIVOROUS,2)
			S.set_trait(TRAIT_SPREAD,1)
		else if(carnivore_prob < 20)
			S.set_trait(TRAIT_CARNIVOROUS,1)
		adapt_seed(S)
		small_flora_types += S
	if(has_trees)
		var/tree_diversity = max(1,flora_diversity/2)
		for(var/i = 1 to tree_diversity)
			var/datum/seed/S = new()
			S.randomize(temperature)
			S.set_trait(TRAIT_PRODUCT_ICON,"alien[rand(1,5)]")
			S.set_trait(TRAIT_PLANT_ICON,"tree")
			S.set_trait(TRAIT_SPREAD,0)
			S.set_trait(TRAIT_HARVEST_REPEAT,1)
			S.set_trait(TRAIT_LARGE,1)
			var/color = pick(plant_colors)
			if(color == "RANDOM")
				color = get_random_colour(0,75,190)
			S.set_trait(TRAIT_LEAVES_COLOUR,color)
			S.chems[/decl/material/solid/wood] = 1
			adapt_seed(S)
			big_flora_types += S

//Adapts seeds to this planet's atmopshere. Any special planet-speicific adaptations should go here too
/obj/effect/overmap/visitable/sector/exoplanet/proc/adapt_seed(var/datum/seed/S)

	var/datum/level_data/level_data = zlevels[1]
	var/datum/gas_mixture/atmosphere = level_data?.exterior_atmosphere
	var/atmosphere_temperature = atmosphere?.temperature || T20C
	var/atmosphere_pressure = atmosphere?.return_pressure() || 0

	S.set_trait(TRAIT_IDEAL_HEAT,          atmosphere_temperature + rand(-5,5),800,70)
	S.set_trait(TRAIT_HEAT_TOLERANCE,      S.get_trait(TRAIT_HEAT_TOLERANCE) + rand(-5,5),800,70)
	S.set_trait(TRAIT_LOWKPA_TOLERANCE,    atmosphere_pressure + rand(-5,-50),80,0)
	S.set_trait(TRAIT_HIGHKPA_TOLERANCE,   atmosphere_pressure + rand(5,50),500,110)
	if(S.exude_gasses)
		S.exude_gasses -= badgas
	if(length(atmosphere?.gas))
		if(S.consume_gasses)
			S.consume_gasses = list(pick(atmosphere.gas)) // ensure that if the plant consumes a gas, the atmosphere will have it
		for(var/g in atmosphere.gas)
			var/decl/material/mat = GET_DECL(g)
			if(mat.gas_flags & XGM_GAS_CONTAMINANT)
				S.set_trait(TRAIT_TOXINS_TOLERANCE, rand(10,15))
	if(prob(50))
		var/chem_type = SSmaterials.get_random_chem(TRUE, atmosphere?.temperature || T0C)
		if(chem_type)
			var/nutriment = S.chems[/decl/material/liquid/nutriment]
			S.chems.Cut()
			S.chems[/decl/material/liquid/nutriment] = nutriment
			S.chems[chem_type] = list(rand(1,10),rand(10,20))

// Landmarks placed by random map generator
/obj/abstract/landmark/exoplanet_spawn/plant
	name = "spawn exoplanet plant"

/obj/abstract/landmark/exoplanet_spawn/plant/do_spawn(var/obj/effect/overmap/visitable/sector/exoplanet/planet)
	return

/obj/abstract/landmark/exoplanet_spawn/large_plant
	name = "spawn exoplanet large plant"

/obj/abstract/landmark/exoplanet_spawn/large_plant/do_spawn(var/obj/effect/overmap/visitable/sector/exoplanet/planet)
	return