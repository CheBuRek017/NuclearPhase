/mob/living/simple_animal/mushroom
	name = "walking mushroom"
	desc = "It's a massive mushroom... with legs?"
	icon = 'icons/mob/simple_animal/mushroom.dmi'
	mob_size = MOB_SIZE_SMALL
	speak_chance = 0
	turns_per_move = 1
	health = 5
	maxHealth = 5
	harm_intent_damage = 5
	pass_flags = PASS_FLAG_TABLE

	meat_type = /obj/item/chems/food/hugemushroomslice
	bone_material = null
	bone_amount =   0
	skin_material = null
	skin_amount =   null

	var/datum/seed/seed
	var/harvest_time
	var/min_explode_time = 1200
	var/static/total_mushrooms = 0

/mob/living/simple_animal/mushroom/Initialize()
	. = ..()
	harvest_time = world.time
	total_mushrooms++

/mob/living/simple_animal/mushroom/verb/spawn_spores()

	set name = "Explode"
	set category = "Abilities"
	set desc = "Spread your spores!"
	set src = usr

	if(stat == 2)
		to_chat(usr, "<span class='danger'>You are dead; it is too late for that.</span>")
		return

	if(!seed)
		to_chat(usr, "<span class='danger'>You are sterile!</span>")
		return

	if(world.time < harvest_time + min_explode_time)
		to_chat(usr, "<span class='danger'>You are not mature enough for that.</span>")
		return

	spore_explode()

/mob/living/simple_animal/mushroom/death(gibbed, deathmessage, show_dead_message)
	. = ..(gibbed, deathmessage, show_dead_message)
	if(.)
		total_mushrooms--
		if(total_mushrooms < get_config_value(/decl/config/num/maximum_mushrooms) && prob(30))
			spore_explode()

/mob/living/simple_animal/mushroom/proc/spore_explode()
	if(!seed)
		return
	if(world.time < harvest_time + min_explode_time)
		return
	for(var/turf/simulated/target_turf in orange(1,src))
		if(prob(60) && !target_turf.density && src.Adjacent(target_turf))
			new /obj/machinery/portable_atmospherics/hydroponics/soil/invisible(target_turf,seed)
	death(0)
	seed.thrown_at(src,get_turf(src),1)
	if(src)
		qdel(src)