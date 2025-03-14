/mob/living/carbon/human/proc/handle_bleeding()
	//Dead or cryosleep people do not pump the blood.
	if(InStasis() || stat == DEAD)
		return

	var/obj/item/organ/internal/liver/cL = GET_INTERNAL_ORGAN(src, BP_LIVER)
	var/total_bleeding_modifier = get_bleeding_modifier(cL)

	var/total_blood_lost = 0 //how much blood will be removed from the bloodstream
	var/spray_message_list = list()

	for(var/obj/item/organ/external/cur_organ in get_external_organs())
		if(BP_IS_PROSTHETIC(cur_organ))
			continue
		var/open_wound = FALSE
		if(cur_organ.status & ORGAN_BLEEDING)
			for(var/datum/wound/W in cur_organ.wounds)
				if(!open_wound && (W.damage_type == CUT || W.damage_type == PIERCE) && W.damage && !W.is_treated())
					open_wound = TRUE
				if(W.bleeding())
					if(cur_organ.applied_pressure)
						if(ishuman(cur_organ.applied_pressure))
							var/mob/living/carbon/human/H = cur_organ.applied_pressure
							H.bloody_hands(src, 0)
						total_blood_lost += W.bleed_amount * 0.2 * total_bleeding_modifier
					else
						total_blood_lost += W.bleed_amount * total_bleeding_modifier
			if(cur_organ.status & ORGAN_ARTERY_CUT)
				var/bleed_amount = min(mcv, NORMAL_MCV) * cur_organ.arterial_bleed_severity
				bleed_amount = max(0.1, bleed_amount)
				if(bleed_amount)
					if(open_wound)
						spray_message_list += "[cur_organ.name]"
					else
						vessel.remove_any(bleed_amount)

		if(world.time >= next_blood_squirt && isturf(loc) && length(spray_message_list))
			var/spray_organ = pick(spray_message_list)
			visible_message(
				SPAN_DANGER("Blood sprays out from \the [src]'s [spray_organ]!"),
				FONT_HUGE(SPAN_DANGER("Blood sprays out from your [spray_organ]!"))
			)
			SET_STATUS_MAX(src, STAT_STUN, 1)
			set_status(STAT_BLURRY, 2)

			next_blood_squirt = world.time + 80
			var/turf/sprayloc = get_turf(src)
			total_blood_lost -= drip(NONUNIT_CEILING(total_blood_lost/3, 0.1), sprayloc)
			if(total_blood_lost > 0)
				total_blood_lost -= blood_squirt(total_blood_lost, sprayloc)
				if(total_blood_lost > 0)
					drip(total_blood_lost, get_turf(src))
		else
			drip(total_blood_lost)
	return total_blood_lost

/mob/living/carbon/human/proc/get_bleeding_modifier(obj/item/organ/internal/liver/cL)
	var/cur_modifier = 0.5
	cur_modifier *= mcv / NORMAL_MCV
	cur_modifier *= 1 + GET_CHEMICAL_EFFECT(src, CE_BLOOD_THINNING) * 0.2
	if(cL)
		cur_modifier += cL.damage / cL.max_damage
	else
		cur_modifier *= 1.7 //you bleed like hell without a liver
	return Clamp(cur_modifier, 0.2, 2.5)