/mob/living/simple_animal/hostile/hivebot
	name = "hivebot"
	desc = "A junky looking robot with four spiky legs."
	icon = 'icons/mob/simple_animal/hivebot.dmi'
	health = 55
	maxHealth = 55
	natural_weapon = /obj/item/natural_weapon/drone_slicer
	projectilesound = 'sound/weapons/gunshot/gunshot_pistol.ogg'
	projectiletype = /obj/item/projectile/beam/smalllaser
	faction = "hivebot"
	min_gas = null
	max_gas = null
	minbodytemp = 0
	speed = 4
	natural_armor = list(
		melee = ARMOR_MELEE_KNIVES
		)
	bleed_colour = SYNTH_BLOOD_COLOR
	gene_damage = -1

	meat_type =     null
	meat_amount =   0
	bone_material = null
	bone_amount =   0
	skin_material = null
	skin_amount =   0

/mob/living/simple_animal/hostile/hivebot/range
	desc = "A junky looking robot with four spiky legs. It's equipped with some kind of small-bore gun."
	ranged = 1
	speed = 7

/mob/living/simple_animal/hostile/hivebot/rapid
	ranged = 1
	rapid = 1

/mob/living/simple_animal/hostile/hivebot/strong
	desc = "A junky looking robot with four spiky legs - this one has thick armour plating."
	health = 120
	maxHealth = 120
	ranged = 1
	can_escape = 1
	natural_armor = list(
		melee = ARMOR_MELEE_RESISTANT
		)

/mob/living/simple_animal/hostile/hivebot/death()
	..(null, "blows apart!")
	new /obj/effect/decal/cleanable/blood/gibs/robot(src.loc)
	spark_at(src, cardinal_only = TRUE)
	qdel(src)
	return

/*
Teleporter beacon, and its subtypes
*/
/mob/living/simple_animal/hostile/hivebot/tele // _why is this a mob_
	name = "beacon"
	desc = "Some odd beacon thing."
	icon = 'icons/obj/structures/hivebot_props.dmi'
	icon_state = "def_radar-off"
	health = 200
	maxHealth = 200
	status_flags = 0
	anchored = 1
	stop_automated_movement = 1

	var/bot_type = /mob/living/simple_animal/hostile/hivebot
	var/bot_amt = 10
	var/spawn_delay = 100
	var/spawn_time = 0

/mob/living/simple_animal/hostile/hivebot/tele/Initialize()
	. = ..()
	var/datum/effect/effect/system/smoke_spread/smoke = new /datum/effect/effect/system/smoke_spread()
	smoke.set_up(5, 0, src.loc)
	smoke.start()
	visible_message("<span class='danger'>\The [src] warps in!</span>")
	playsound(src.loc, 'sound/effects/EMPulse.ogg', 25, 1)

/mob/living/simple_animal/hostile/hivebot/tele/proc/warpbots()
	while(bot_amt > 0 && bot_type)
		bot_amt--
		var/mob/M = new bot_type(get_turf(src))
		M.faction = faction
	playsound(src.loc, 'sound/effects/teleport.ogg', 50, 1)
	qdel(src)
	return

/mob/living/simple_animal/hostile/hivebot/tele/FindTarget()
	if(..() && !spawn_time)
		spawn_time = world.time + spawn_delay
		visible_message("<span class='danger'>\The [src] turns on!</span>")
		icon_state = "def_radar"
	return null

/mob/living/simple_animal/hostile/hivebot/tele/Life()
	. = ..()
	if(. && spawn_time && spawn_time <= world.time)
		warpbots()

/mob/living/simple_animal/hostile/hivebot/tele/strong
	bot_type = /mob/living/simple_animal/hostile/hivebot/strong

/mob/living/simple_animal/hostile/hivebot/tele/range
	bot_type = /mob/living/simple_animal/hostile/hivebot/range

/mob/living/simple_animal/hostile/hivebot/tele/rapid
	bot_type = /mob/living/simple_animal/hostile/hivebot/rapid

/*
Special projectiles
*/
/obj/item/projectile/bullet/gyro/megabot
	name = "microrocket"
	distance_falloff = 1.3
	fire_sound = 'sound/effects/Explosion1.ogg'
	var/gyro_devastation = -1
	var/gyro_heavy_impact = 0
	var/gyro_light_impact = 1

/obj/item/projectile/bullet/gyro/megabot/on_hit(var/atom/target, var/blocked = 0)
	if(isturf(target))
		explosion(target, gyro_devastation, gyro_heavy_impact, gyro_light_impact)
	..()

/obj/item/projectile/beam/megabot
	damage = 45
	distance_falloff = 0.5

/*
The megabot
*/
#define ATTACK_MODE_MELEE    "melee"
#define ATTACK_MODE_LASER    "laser"
#define ATTACK_MODE_ROCKET   "rocket"

/mob/living/simple_animal/hostile/hivebot/mega
	name = "hivemind"
	desc = "A huge quadruped robot equipped with a myriad of weaponry."
	icon = 'icons/mob/simple_animal/megabot.dmi'
	health = 440
	maxHealth = 440
	natural_weapon = /obj/item/natural_weapon/circular_saw
	speed = 0
	natural_armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_PISTOL
		)
	can_escape = TRUE
	armor_type = /datum/extension/armor/toggle
	ability_cooldown = 3 MINUTES

	pixel_x = -32
	default_pixel_x = -32

	var/attack_mode = ATTACK_MODE_MELEE
	var/num_shots
	var/deactivated

/obj/item/natural_weapon/circular_saw
	name = "giant circular saw"
	attack_verb = list("sawed", "ripped")
	force = 15
	sharp = TRUE
	edge = TRUE

/mob/living/simple_animal/hostile/hivebot/mega/Initialize()
	. = ..()
	switch_mode(ATTACK_MODE_ROCKET)

/mob/living/simple_animal/hostile/hivebot/mega/Life()
	. = ..()
	if(!.)
		return

	if(time_last_used_ability < world.time)
		switch_mode(ATTACK_MODE_ROCKET)

/mob/living/simple_animal/hostile/hivebot/mega/emp_act(severity)
	. = ..()
	if(severity >= 1)
		deactivate()

/mob/living/simple_animal/hostile/hivebot/mega/on_update_icon()
	..()
	if(stat != DEAD)
		if(deactivated)
			add_overlay("[icon_state]-standby")
			return
		add_overlay("[icon_state]-active")
		switch(attack_mode)
			if(ATTACK_MODE_MELEE)
				add_overlay("[icon_state]-melee")
			if(ATTACK_MODE_LASER)
				add_overlay("[icon_state]-laser")
			if(ATTACK_MODE_ROCKET)
				add_overlay("[icon_state]-rocket")

/mob/living/simple_animal/hostile/hivebot/mega/proc/switch_mode(var/new_mode)
	if(!new_mode || new_mode == attack_mode)
		return

	switch(new_mode)
		if(ATTACK_MODE_MELEE)
			attack_mode = ATTACK_MODE_MELEE
			ranged = FALSE
			projectilesound = null
			projectiletype = null
			num_shots = 0
			visible_message(SPAN_MFAUNA("\The [src]'s circular saw spins up!"))
			deactivate()
		if(ATTACK_MODE_LASER)
			attack_mode = ATTACK_MODE_LASER
			ranged = TRUE
			projectilesound = 'sound/weapons/Laser.ogg'
			projectiletype = /obj/item/projectile/beam/megabot
			num_shots = 12
			fire_desc = "fires a laser"
			visible_message(SPAN_MFAUNA("\The [src]'s laser cannon whines!"))
		if(ATTACK_MODE_ROCKET)
			attack_mode = ATTACK_MODE_ROCKET
			ranged = TRUE
			projectilesound = 'sound/effects/Explosion1.ogg'
			projectiletype = /obj/item/projectile/bullet/gyro/megabot
			num_shots = 4
			cooldown_ability(ability_cooldown)
			fire_desc = "launches a microrocket"
			visible_message(SPAN_MFAUNA("\The [src]'s missile pod rumbles!"))

	update_icon()

/mob/living/simple_animal/hostile/hivebot/mega/proc/deactivate()
	stop_automation = TRUE
	deactivated = TRUE
	visible_message(SPAN_MFAUNA("\The [src] clicks loudly as its lights fade and its motors grind to a halt!"))
	update_icon()
	var/datum/extension/armor/toggle/armor = get_extension(src, /datum/extension/armor)
	if(armor)
		armor.toggle(FALSE)
	addtimer(CALLBACK(src, PROC_REF(reactivate)), 4 SECONDS)

/mob/living/simple_animal/hostile/hivebot/mega/proc/reactivate()
	stop_automation = FALSE
	deactivated = FALSE
	visible_message(SPAN_MFAUNA("\The [src] whirs back to life!"))
	var/datum/extension/armor/toggle/armor = get_extension(src, /datum/extension/armor)
	if(armor)
		armor.toggle(TRUE)
	update_icon()

/mob/living/simple_animal/hostile/hivebot/mega/OpenFire(target_mob)
	if(num_shots <= 0)
		if(attack_mode == ATTACK_MODE_ROCKET)
			switch_mode(ATTACK_MODE_LASER)
		else
			switch_mode(ATTACK_MODE_MELEE)
		return
	..()

/mob/living/simple_animal/hostile/hivebot/mega/Shoot(target, start, user, bullet)
	..()
	num_shots--

#undef ATTACK_MODE_MELEE
#undef ATTACK_MODE_LASER
#undef ATTACK_MODE_ROCKET