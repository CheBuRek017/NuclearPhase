/decl/hierarchy/outfit/job
	name = "Standard Gear"
	abstract_type = /decl/hierarchy/outfit/job

	uniform = /obj/item/clothing/under/tactical
	shoes = /obj/item/clothing/shoes/workboots

	id_slot = slot_wear_id_str
	id_type = /obj/item/card/id/civilian
	pda_slot = slot_belt_str

	flags = OUTFIT_HAS_BACKPACK

/decl/hierarchy/outfit/job/equip_id(mob/living/carbon/human/H)
	var/obj/item/card/id/C = ..()
	if(!C)
		return
	if(H.mind)
		if(H.mind.initial_account)
			C.associated_account_number = H.mind.initial_account.account_number
	return C
