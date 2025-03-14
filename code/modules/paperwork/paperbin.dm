/obj/item/paper_bin
	name = "paper bin"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "paper_bin1"
	item_state = "sheet-metal"
	randpixel = 0
	throwforce = 1
	w_class = ITEM_SIZE_NORMAL
	throw_speed = 3
	throw_range = 7
	layer = BELOW_OBJ_LAYER
	var/amount = 30					//How much paper is in the bin.
	var/list/papers = new/list()	//List of papers put in the bin for reference.


/obj/item/paper_bin/handle_mouse_drop(atom/over, mob/user)
	if((loc == user || in_range(src, user)) && user.get_empty_hand_slot())
		user.put_in_hands(src)
		return TRUE
	. = ..()

/obj/item/paper_bin/attack_hand(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/temp = GET_EXTERNAL_ORGAN(H, H.get_active_held_item_slot())
		if(temp && !temp.is_usable())
			to_chat(user, "<span class='notice'>You try to move your [temp.name], but cannot!</span>")
			return
	var/response = ""
	if(!papers.len > 0)
		response = alert(user, "Do you take regular paper, or Carbon copy paper?", "Paper type request", "Regular", "Carbon-Copy", "Cancel")
		if (response != "Regular" && response != "Carbon-Copy")
			add_fingerprint(user)
			return
	if(amount >= 1)
		amount--
		if(amount==0)
			update_icon()

		var/obj/item/paper/P
		if(papers.len > 0)	//If there's any custom paper on the stack, use that instead of creating a new paper.
			P = papers[papers.len]
			papers.Remove(P)
		else
			if(response == "Regular")
				P = new /obj/item/paper
				if(global.current_holiday?.name == "April Fool's Day")
					if(prob(30))
						P.info = "<font face=\"[P.crayonfont]\" color=\"red\"><b>HONK HONK HONK HONK HONK HONK HONK<br>HOOOOOOOOOOOOOOOOOOOOOONK<br>APRIL FOOLS</b></font>"
						P.rigged = 1
						P.updateinfolinks()
			else if (response == "Carbon-Copy")
				P = new /obj/item/paper/carbon
		user.put_in_hands(P)
		to_chat(user, "<span class='notice'>You take [P] out of the [src].</span>")
	else
		to_chat(user, "<span class='notice'>[src] is empty!</span>")

	add_fingerprint(user)
	return


/obj/item/paper_bin/attackby(obj/item/i, mob/user)
	if(istype(i, /obj/item/paper))
		if(!user.unEquip(i, src))
			return
		to_chat(user, "<span class='notice'>You put [i] in [src].</span>")
		papers.Add(i)
		update_icon()
		amount++
	else if(istype(i, /obj/item/paper_bundle))
		to_chat(user, "<span class='notice'>You loosen \the [i] and add its papers into \the [src].</span>")
		var/was_there_a_photo = 0
		for(var/obj/item/bundleitem in i) //loop through items in bundle
			if(istype(bundleitem, /obj/item/paper)) //if item is paper, add into the bin
				papers.Add(bundleitem)
				update_icon()
				amount++
			else if(istype(bundleitem, /obj/item/photo)) //if item is photo, drop it on the ground
				was_there_a_photo = 1
				bundleitem.dropInto(user.loc)
				bundleitem.reset_plane_and_layer()
		qdel(i)
		if(was_there_a_photo)
			to_chat(user, "<span class='notice'>The photo cannot go into \the [src].</span>")


/obj/item/paper_bin/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		if(amount)
			to_chat(user, "<span class='notice'>There " + (amount > 1 ? "are [amount] papers" : "is one paper") + " in the bin.</span>")
		else
			to_chat(user, "<span class='notice'>There are no papers in the bin.</span>")


/obj/item/paper_bin/on_update_icon()
	. = ..()
	if(amount < 1)
		icon_state = "paper_bin0"
	else
		icon_state = "paper_bin1"
