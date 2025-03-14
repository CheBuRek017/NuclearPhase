/decl/material/liquid/luminol
	name = "luminol"
	uid = "chem_luminol"
	lore_text = "A compound that interacts with blood on the molecular level."
	taste_description = "metal"
	color = "#f2f3f4"
	exoplanet_rarity = MAT_RARITY_NOWHERE

/decl/material/liquid/luminol/touch_obj(var/obj/O, var/amount, var/datum/reagents/holder)
	O.reveal_blood()

/decl/material/liquid/luminol/touch_mob(var/mob/living/M, var/amount, var/datum/reagents/holder)
	M.reveal_blood()

/decl/material/liquid/glowsap
	name = "glowsap"
	lore_text = "A popular party drug for adventurous types who want to BE the glowstick. Rumoured to be hallucinogenic in high doses."
	overdose = 15
	color = "#9eefff"
	uid = "chem_glowsap"

/decl/material/liquid/glowsap/affect_ingest(mob/living/M, removed, var/datum/reagents/holder)
	affect_blood(M, removed, holder)

/decl/material/liquid/glowsap/affect_blood(mob/living/M, removed, var/datum/reagents/holder)
	M.add_chemical_effect(CE_GLOWINGEYES, 1)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.update_eyes()

/decl/material/liquid/glowsap/on_leaving_metabolism(atom/parent, metabolism_class)
	if(ishuman(parent))
		var/mob/living/carbon/human/H = parent
		addtimer(CALLBACK(H, /mob/living/carbon/human/proc/update_eyes), 5 SECONDS)
	. = ..()

/decl/material/liquid/glowsap/affect_overdose(var/mob/living/M, var/datum/reagents/holder)
	. = ..()
	M.add_chemical_effect(CE_TOXIN, 1)
	M.set_hallucination(60, 20)
	SET_STATUS_MAX(M, STAT_DRUGGY, 10)

/decl/material/solid/blackpepper
	name = "black pepper"
	lore_text = "A powder ground from peppercorns. *AAAACHOOO*"
	taste_description = "pepper"
	color = "#000000"
	value = 0.1
	uid = "chem_blackpepper"

/decl/material/liquid/enzyme
	name = "universal enzyme"
	uid = "chem_enzyme"
	lore_text = "A universal enzyme used in the preperation of certain chemicals and foods."
	taste_description = "sweetness"
	taste_mult = 0.7
	color = "#365e30"
	overdose = REAGENTS_OVERDOSE

/decl/material/liquid/frostoil
	name = "chilly oil"
	lore_text = "An oil harvested from a mutant form of chili peppers, it has a chilling effect on the body."
	taste_description = "arctic mint"
	taste_mult = 1.5
	color = "#07aab2"
	value = 2
	fruit_descriptor = "numbing"
	uid = "chem_frostoil"

/decl/material/liquid/frostoil/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	M.bodytemperature = max(M.bodytemperature - 10 * TEMPERATURE_DAMAGE_COEFFICIENT, 0)
	if(prob(1))
		M.emote("shiver")
	holder.remove_reagent(/decl/material/liquid/capsaicin, 5)

/decl/material/liquid/capsaicin
	name = "capsaicin oil"
	lore_text = "This is what makes chilis hot."
	taste_description = "hot peppers"
	taste_mult = 1.5
	color = "#b31008"
	fruit_descriptor = "spicy"
	uid = "chem_caspaicin"

	heating_point = T100C
	heating_message = "darkens and thickens as it seperates from its water content"
	heating_products = list(
		/decl/material/liquid/capsaicin/condensed = 0.5,
		/decl/material/liquid/water = 0.5
	)

	var/agony_dose = 5
	var/agony_amount = 2
	var/discomfort_message = "<span class='danger'>Your insides feel uncomfortably hot!</span>"
	var/slime_temp_adj = 10

/decl/material/liquid/capsaicin/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	M.adjustToxLoss(0.5 * removed)

/decl/material/liquid/capsaicin/affect_ingest(var/mob/living/M, var/removed, var/datum/reagents/holder)
	holder.remove_reagent(/decl/material/liquid/frostoil, 5)

	if(M.HasTrait(/decl/trait/metabolically_inert))
		return

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.can_feel_pain())
			return

	var/dose = LAZYACCESS(M.chem_doses, type)
	if(dose < agony_dose)
		if(prob(5) || dose == metabolism) //dose == metabolism is a very hacky way of forcing the message the first time this procs
			to_chat(M, discomfort_message)
	else
		M.apply_effect(agony_amount, PAIN, 0)
		if(prob(5))
			M.custom_emote(2, "[pick("dry heaves!","coughs!","splutters!")]")
			to_chat(M, "<span class='danger'>You feel like your insides are burning!</span>")

/decl/material/liquid/capsaicin/condensed
	name = "condensed capsaicin"
	lore_text = "A chemical agent used for self-defense and in police work."
	taste_description = "scorching agony"
	taste_mult = 10
	touch_met = 5 // Get rid of it quickly
	color = "#b31008"
	agony_dose = 0.5
	agony_amount = 4
	discomfort_message = "<span class='danger'>You feel like your insides are burning!</span>"
	slime_temp_adj = 15
	value = 2
	uid = "chem_capsaicin_condensed"

/decl/material/liquid/capsaicin/condensed/affect_touch(var/mob/living/M, var/removed, var/datum/reagents/holder)
	var/eyes_covered = 0
	var/mouth_covered = 0
	var/partial_mouth_covered = 0
	var/stun_probability = 50
	var/no_pain = !M.can_feel_pain()
	var/obj/item/eye_protection = null
	var/obj/item/face_protection = null
	var/obj/item/partial_face_protection = null
	var/effective_strength = 5

	for(var/slot in global.standard_headgear_slots)
		var/obj/item/I = M.get_equipped_item(slot)
		if(istype(I))
			if(I.body_parts_covered & SLOT_EYES)
				eyes_covered = 1
				eye_protection = I.name
			if((I.body_parts_covered & SLOT_FACE) && !(I.item_flags & ITEM_FLAG_FLEXIBLEMATERIAL))
				mouth_covered = 1
				face_protection = I.name
			else if(I.body_parts_covered & SLOT_FACE)
				partial_mouth_covered = 1
				partial_face_protection = I.name

	if(eyes_covered)
		if(!mouth_covered)
			to_chat(M, "<span class='warning'>Your [eye_protection] protects your eyes from the pepperspray!</span>")
	else
		to_chat(M, "<span class='warning'>The pepperspray gets in your eyes!</span>")
		ADJ_STATUS(M, STAT_CONFUSE, 2)
		if(mouth_covered)
			SET_STATUS_MAX(M, STAT_BLURRY, effective_strength * 3)
			SET_STATUS_MAX(M, STAT_BLIND, effective_strength)
		else
			SET_STATUS_MAX(M, STAT_BLURRY, effective_strength * 5)
			SET_STATUS_MAX(M, STAT_BLIND, effective_strength * 2)

	if(mouth_covered)
		to_chat(M, "<span class='warning'>Your [face_protection] protects you from the pepperspray!</span>")
	else if(!no_pain)
		if(partial_mouth_covered)
			to_chat(M, "<span class='warning'>Your [partial_face_protection] partially protects you from the pepperspray!</span>")
			stun_probability *= 0.5
		to_chat(M, "<span class='danger'>Your face and throat burn!</span>")
		if(HAS_STATUS(M, STAT_STUN)  && !M.lying)
			SET_STATUS_MAX(M, STAT_WEAK, 4)
		if(prob(stun_probability))
			M.custom_emote(2, "[pick("coughs!","coughs hysterically!","splutters!")]")
			SET_STATUS_MAX(M, STAT_STUN, 3)

/decl/material/liquid/capsaicin/condensed/affect_ingest(var/mob/living/M, var/removed, var/datum/reagents/holder)
	holder.remove_reagent(/decl/material/liquid/frostoil, 5)

	if(M.HasTrait(/decl/trait/metabolically_inert))
		return

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.can_feel_pain())
			return
	if(LAZYACCESS(M.chem_doses, type) == metabolism)
		to_chat(M, "<span class='danger'>You feel like your insides are burning!</span>")
	else
		M.apply_effect(6, PAIN, 0)
		if(prob(5))
			to_chat(M, "<span class='danger'>You feel like your insides are burning!</span>")
			M.custom_emote(2, "[pick("coughs.","gags.","retches.")]")
			SET_STATUS_MAX(M, STAT_STUN, 2)

/decl/material/liquid/mutagenics
	name = "mutagenics"
	lore_text = "Might cause unpredictable mutations. Keep away from children."
	taste_description = "slime"
	taste_mult = 0.9
	color = "#13bc5e"
	uid = "chem_mutagenics"

/decl/material/liquid/mutagenics/affect_touch(var/mob/living/M, var/removed, var/datum/reagents/holder)
	if(prob(33))
		affect_blood(M, removed, holder)

/decl/material/liquid/mutagenics/affect_ingest(var/mob/living/M, var/removed, var/datum/reagents/holder)
	if(prob(67))
		affect_blood(M, removed, holder)

/decl/material/liquid/mutagenics/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)

	if(M.isSynthetic())
		return

	var/mob/living/carbon/human/H = M
	if(istype(H) && (H.species.species_flags & SPECIES_FLAG_NO_SCAN))
		return

	if(M.dna)
		if(prob(removed * 0.1)) // Approx. one mutation per 10 injected/20 ingested/30 touching units
			randmuti(M)
			if(prob(98))
				randmutb(M)
			else
				randmutg(M)
			domutcheck(M, null)
			M.UpdateAppearance()
	M.apply_damage(10 * removed, IRRADIATE, armor_pen = 100)

/decl/material/liquid/lactate
	name = "lactate"
	lore_text = "Lactate is produced by the body during strenuous exercise. It often correlates with elevated heart rate, shortness of breath, and general exhaustion."
	taste_description = "sourness"
	color = "#eeddcc"
	scannable = 1
	overdose = REAGENTS_OVERDOSE
	metabolism = REM*2
	exoplanet_rarity = MAT_RARITY_NOWHERE
	uid = "chem_lactate"

/decl/material/liquid/lactate/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	var/volume = REAGENT_VOLUME(holder, type)
	M.add_chemical_effect(CE_PULSE, volume * 5)
	if(volume >= 10)
		M.add_chemical_effect(CE_PULSE, 50)
		M.add_chemical_effect(CE_SLOWDOWN, (volume/15) ** 2)
	else if(LAZYACCESS(M.chem_doses, type) > 30) //after prolonged exertion
		ADJ_STATUS(M, STAT_JITTER, 5)
		M.add_chemical_effect(CE_BREATHLOSS, 0.2 * volume)

/decl/material/liquid/nanoblood
	name = "nanoblood"
	lore_text = "A stable hemoglobin-based nanoparticle oxygen carrier, used to rapidly replace lost blood. Toxic unless injected in small doses. Does not contain white blood cells."
	taste_description = "blood with bubbles"
	color = "#c10158"
	scannable = 1
	overdose = 5
	metabolism = 1
	exoplanet_rarity = MAT_RARITY_NOWHERE
	uid = "chem_nanoblood"
	var/blood_power = 4

/decl/material/liquid/nanoblood/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	var/mob/living/carbon/human/H = M
	if(!istype(H))
		return
	if(!H.should_have_organ(BP_HEART)) //We want the var for safety but we can do without the actual blood.
		return
	if(H.regenerate_blood(blood_power * removed))
		H.immunity = max(H.immunity - 0.1, 0)
		if(LAZYACCESS(H.chem_doses, type) > H.species.blood_volume/8) //half of blood was replaced with us, rip white bodies
			H.immunity = max(H.immunity - 0.5, 0)

/decl/material/liquid/nanoblood/saline
	name = "saline solution"
	lore_text = "Saline (also known as saline solution) is a mixture of sodium chloride and water. It has a number of uses in medicine including cleaning wounds, removal and storage of contact lenses, and help with dry eyes."
	overdose = 5600
	color = "#bebebe"
	metabolism = REM * 9
	uid = "chem_saline"
	blood_power = 1
	drug_category = DRUG_CATEGORY_MISC

/decl/material/solid/tobacco
	name = "tobacco"
	lore_text = "Cut and processed tobacco leaves."
	taste_description = "tobacco"
	color = "#684b3c"
	scannable = 1
	scent = "cigarette smoke"
	scent_descriptor = SCENT_DESC_ODOR
	scent_range = 4
	hidden_from_codex = TRUE
	uid = "chem_tobacco"

	var/nicotine = REM * 0.2

/decl/material/solid/tobacco/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	..()
	M.reagents.add_reagent(/decl/material/liquid/nicotine, nicotine)

/decl/material/solid/tobacco/fine
	name = "fine tobacco"
	taste_description = "fine tobacco"
	value = 1.5
	scent = "fine tobacco smoke"
	scent_descriptor = SCENT_DESC_FRAGRANCE
	uid = "chem_tobacco_fine"

/decl/material/solid/tobacco/bad
	name = "terrible tobacco"
	taste_description = "acrid smoke"
	value = 0.5
	scent = "acrid tobacco smoke"
	scent_intensity = /decl/scent_intensity/strong
	scent_descriptor = SCENT_DESC_ODOR
	uid = "chem_tobacco_terrible"

/decl/material/solid/tobacco/liquid
	name = "nicotine solution"
	lore_text = "A diluted nicotine solution."
	taste_mult = 0
	color = "#fcfcfc"
	nicotine = REM * 0.1
	scent = null
	scent_intensity = null
	scent_descriptor = null
	scent_range = null
	exoplanet_rarity = MAT_RARITY_NOWHERE
	uid = "chem_nicotinesolution"

/decl/material/liquid/menthol
	name = "menthol"
	lore_text = "Tastes naturally minty, and imparts a very mild numbing sensation."
	taste_description = "mint"
	color = "#80af9c"
	metabolism = REM * 0.2
	overdose = REAGENTS_OVERDOSE * 0.25
	scannable = 1
	hidden_from_codex = TRUE
	uid = "chem_tobacco_menthol"

/decl/material/liquid/menthol/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	if(world.time > REAGENT_DATA(holder, type) + 3 MINUTES)
		LAZYSET(holder.reagent_data, type, world.time)
		to_chat(M, SPAN_NOTICE("You feel faintly sore in the throat."))

/decl/material/liquid/nanitefluid
	name = "nanite fluid"
	lore_text = "A solution of repair nanites used to repair robotic organs. Due to the nature of the small magnetic fields used to guide the nanites, it must be used in temperatures below 170K."
	taste_description = "metallic sludge"
	color = "#c2c2d6"
	scannable = 1
	flags = IGNORE_MOB_SIZE
	uid = "chem_nanite_fluid"

/decl/material/liquid/nanitefluid/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	M.add_chemical_effect(CE_CRYO, 1)
	if(M.bodytemperature < 170)
		M.heal_organ_damage(30 * removed, 30 * removed, affect_robo = 1)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			for(var/obj/item/organ/internal/I in H.get_internal_organs())
				if(BP_IS_PROSTHETIC(I))
					I.heal_damage(20*removed)

/decl/material/liquid/antiseptic
	name = "antiseptic"
	lore_text = "Sterilizes surfaces (or wounds) in preparation for surgery, and thoroughly removes blood."
	taste_description = "bitterness"
	color = "#c8a5dc"
	touch_met = 5
	dirtiness = DIRTINESS_STERILE
	turf_touch_threshold = 0.1
	uid = "chem_antiseptic"

/decl/material/liquid/crystal_agent
	name = "crystallizing agent"
	taste_description = "sharpness"
	color = "#13bc5e"
	uid = "chem_crystalizing_agent"

/decl/material/liquid/crystal_agent/proc/do_material_check(var/mob/living/carbon/M)
	. = /decl/material/solid/gemstone/crystal

/decl/material/liquid/crystal_agent/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	var/result_mat = do_material_check(M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/list/limbs = H.get_external_organs()
		var/list/shuffled_limbs = LAZYLEN(limbs) ? shuffle(limbs.Copy()) : null
		for(var/obj/item/organ/external/E in shuffled_limbs)
			if(BP_IS_PROSTHETIC(E))
				continue

			if(BP_IS_CRYSTAL(E))
				if((E.brute_dam + E.burn_dam) > 0)
					if(prob(35))
						to_chat(M, SPAN_NOTICE("You feel a crawling sensation as fresh crystal grows over your [E.name]."))
					E.heal_damage(rand(5,8), rand(5,8))
					break
				if(BP_IS_BRITTLE(E))
					E.status &= ~ORGAN_BRITTLE
					break
			else if(E.organ_tag != BP_CHEST && E.organ_tag != BP_GROIN && prob(15))
				to_chat(H, SPAN_DANGER("Your [E.name] is being lacerated from within!"))
				if(E.can_feel_pain())
					H.emote("scream")
				if(prob(25))
					for(var/i = 1 to rand(3,5))
						new /obj/item/shard(get_turf(E), result_mat)
					E.dismember(0, DISMEMBER_METHOD_BLUNT)
				else
					E.take_external_damage(rand(20,30), 0)
					BP_SET_CRYSTAL(E)
					E.status |= ORGAN_BRITTLE
				break

		var/list/internal_organs = H.get_internal_organs()
		var/list/shuffled_organs = LAZYLEN(internal_organs) ? shuffle(internal_organs.Copy()) : null
		for(var/obj/item/organ/internal/I in shuffled_organs)
			if(BP_IS_PROSTHETIC(I) || !BP_IS_CRYSTAL(I) || I.damage <= 0 || I.organ_tag == BP_BRAIN)
				continue
			if(prob(35))
				to_chat(M, SPAN_NOTICE("You feel a deep, sharp tugging sensation as your [I.name] is mended."))
			I.heal_damage(rand(1,3))
			break
	else
		to_chat(M, SPAN_DANGER("Your flesh is being lacerated from within!"))
		M.adjustBruteLoss(rand(3,6))
		if(prob(10))
			new /obj/item/shard(get_turf(M), result_mat)

/decl/material/solid/water_purifier_first
	name = "water purifying compound"
	lore_text = "A weak but easy to use mix of cleaning agents."
	taste_description = "chlorine"
	color = "#86ffbd"
	uid = "water_purifier_first"