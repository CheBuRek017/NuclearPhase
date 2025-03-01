/obj/machinery/optable
	name = "operating table"
	desc = "Used for advanced medical procedures."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "table2-idle"
	density = 1
	anchored = 1
	throwpass = 1
	idle_power_usage = 1
	active_power_usage = 5
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0

	var/mob/living/victim
	var/strapped = 0.0
	var/obj/machinery/computer/operating/computer = null

/obj/machinery/optable/Initialize()
	. = ..()
	for(dir in list(NORTH,EAST,SOUTH,WEST))
		computer = locate(/obj/machinery/computer/operating, get_step(src, dir))
		if (computer)
			computer.table = src
			break

/obj/machinery/optable/examine(mob/user)
	. = ..()

/obj/machinery/optable/attackby(var/obj/item/O, var/mob/user)
	if (istype(O, /obj/item/grab))
		var/obj/item/grab/G = O
		if(isliving(G.affecting) && check_table(G.affecting))
			take_victim(G.affecting,usr)
			qdel(O)
			return
	return ..()

/obj/machinery/optable/state_transition(var/decl/machine_construction/default/new_state)
	. = ..()
	if(istype(new_state))
		updateUsrDialog()

/obj/machinery/optable/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	. = (air_group || height == 0 || (istype(mover) && mover.checkpass(PASS_FLAG_TABLE)))

/obj/machinery/optable/receive_mouse_drop(atom/dropping, mob/user)
	. = ..()
	if(!.)
		if(istype(dropping, /obj/item) && user.get_active_hand() == dropping && user.unEquip(dropping, loc))
			return FALSE
		if(isliving(dropping) && check_table(dropping))
			take_victim(dropping, user)
			return FALSE

/obj/machinery/optable/proc/check_victim()
	if(!victim || !victim.lying || victim.loc != loc)
		victim = null
		for(var/mob/living/carbon/human/H in loc)
			if(H.lying)
				victim = H
				break
	. = !!victim
	update_icon()

/obj/machinery/optable/on_update_icon()
	icon_state = "table2-idle"
	if(ishuman(victim))
		var/mob/living/carbon/human/H = victim
		if(H.pulse())
			icon_state = "table2-active"

/obj/machinery/optable/Process()
	check_victim()

/obj/machinery/optable/proc/take_victim(mob/living/target, mob/living/user)
	if (target == user)
		user.visible_message( \
		SPAN_NOTICE("\The [user] climbs on \the [src]."), \
		SPAN_NOTICE("You climb on \the [src]."))
	else
		visible_message(SPAN_NOTICE("\The [target] has been laid on \the [src] by \the [user]."))
	target.resting = 1
	target.dropInto(loc)
	add_fingerprint(user)
	update_icon()

/obj/machinery/optable/climb_on()
	if(usr.stat || !ishuman(usr) || usr.restrained() || !check_table(usr))
		return
	take_victim(usr,usr)

/obj/machinery/optable/proc/check_table(mob/living/patient)
	check_victim()
	if(src.victim && get_turf(victim) == get_turf(src) && victim.lying)
		to_chat(usr, "<span class='warning'>\The [src] is already occupied!</span>")
		return FALSE
	if(patient.buckled)
		to_chat(usr, "<span class='notice'>Unbuckle \the [patient] first!</span>")
		return FALSE
	if(patient.anchored)
		return FALSE
	return TRUE