/obj/item/assembly
	name = "assembly"
	desc = "A small electronic device that should never exist."
	icon = 'icons/obj/assemblies/new_assemblies.dmi'
	icon_state = ""
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	w_class = ITEM_SIZE_SMALL
	material = /decl/material/solid/metal/steel
	throwforce = 2
	throw_speed = 3
	throw_range = 10
	origin_tech = @'{"magnets":1}'

	var/secured = 1
	var/list/attached_overlays = null
	var/obj/item/assembly_holder/holder = null
	var/cooldown = 0//To prevent spam
	var/wires = WIRE_RECEIVE | WIRE_PULSE

	var/const/WIRE_RECEIVE = 1			//Allows Pulsed(0) to call Activate()
	var/const/WIRE_PULSE = 2				//Allows Pulse(0) to act on the holder
	var/const/WIRE_PULSE_SPECIAL = 4		//Allows Pulse(0) to act on the holders special assembly
	var/const/WIRE_RADIO_RECEIVE = 8		//Allows Pulsed(1) to call Activate()
	var/const/WIRE_RADIO_PULSE = 16		//Allows Pulse(1) to send a radio message

/obj/item/assembly/Destroy()
	if(!QDELETED(holder))
		if(holder.a_left == src)
			holder.a_left = null
		if(holder.a_right == src)
			holder.a_right = null
		QDEL_NULL(holder)
	else
		holder = null
	return ..()

/obj/item/assembly/proc/activate()									//What the device does when turned on
	return

/obj/item/assembly/proc/pulsed(var/radio = 0)						//Called when another assembly acts on this one, var/radio will determine where it came from for wire calcs
	return

/obj/item/assembly/proc/pulse(var/radio = 0)						//Called when this device attempts to act on another device, var/radio determines if it was sent via radio or direct
	return

/obj/item/assembly/proc/toggle_secure()								//Code that has to happen when the assembly is un\secured goes here
	return

/obj/item/assembly/proc/attach_assembly(var/obj/A, var/mob/user)	//Called when an assembly is attacked by another
	return

/obj/item/assembly/proc/process_cooldown()							//Called via spawn(10) to have it count down the cooldown var
	return

/obj/item/assembly/proc/holder_movement()							//Called when the holder is moved
	return

/obj/item/assembly/interact(mob/user)				//Called when attack_self is called
	return


/obj/item/assembly/process_cooldown()
	cooldown--
	if(cooldown <= 0)	return 0
	spawn(10)
		process_cooldown()
	return 1


/obj/item/assembly/pulsed(var/radio = 0)
	if(holder && (wires & WIRE_RECEIVE))
		activate()
	if(radio && (wires & WIRE_RADIO_RECEIVE))
		activate()
	return 1


/obj/item/assembly/pulse(var/radio = 0)
	if(holder && (wires & WIRE_PULSE))
		holder.process_activation(src, 1, 0)
	if(holder && (wires & WIRE_PULSE_SPECIAL))
		holder.process_activation(src, 0, 1)
//		if(radio && (wires & WIRE_RADIO_PULSE))
		//Not sure what goes here quite yet send signal?
	return 1


/obj/item/assembly/activate()
	if(!secured || (cooldown > 0))	return 0
	cooldown = 2
	spawn(10)
		process_cooldown()
	return 1


/obj/item/assembly/toggle_secure()
	secured = !secured
	update_icon()
	return secured


/obj/item/assembly/attach_assembly(var/obj/item/assembly/A, var/mob/user)
	holder = new/obj/item/assembly_holder(get_turf(src))
	if(holder.attach(A,src,user))
		to_chat(user, "<span class='notice'>You attach \the [A] to \the [src]!</span>")
		return 1
	return 0


/obj/item/assembly/attackby(obj/item/W, mob/user)
	if(isassembly(W))
		var/obj/item/assembly/A = W
		if((!A.secured) && (!secured))
			attach_assembly(A,user)
			return
	if(IS_SCREWDRIVER(W))
		if(toggle_secure())
			to_chat(user, "<span class='notice'>\The [src] is ready!</span>")
		else
			to_chat(user, "<span class='notice'>\The [src] can now be attached!</span>")
		return
	..()
	return


/obj/item/assembly/Process()
	return PROCESS_KILL


/obj/item/assembly/examine(mob/user, distance)
	. = ..()
	if(distance <= 1 || loc == user)
		if(secured)
			to_chat(user, "\The [src] is ready!")
		else
			to_chat(user, "\The [src] can be attached!")


/obj/item/assembly/attack_self(mob/user)
	if(!user)	return 0
	user.set_machine(src)
	interact(user)
	return 1

/obj/item/assembly/interact(mob/user)
	return //HTML MENU FOR WIRES GOES HERE

/obj/item/assembly/nano_host()
	if(istype(loc, /obj/item/assembly_holder))
		return loc.nano_host()
	return ..()

/*
	var/small_icon_state = null//If this obj will go inside the assembly use this for icons
	var/list/small_icon_state_overlays = null//Same here
	var/obj/holder = null
	var/cooldown = 0//To prevent spam

	proc
		Activate()//Called when this assembly is pulsed by another one
		Process_cooldown()//Call this via spawn(10) to have it count down the cooldown var
		Attach_Holder(var/obj/H, var/mob/user)//Called when an assembly holder attempts to attach, sets src's loc in here


	Activate()
		if(cooldown > 0)
			return 0
		cooldown = 2
		spawn(10)
			Process_cooldown()
		//Rest of code here
		return 0


	Process_cooldown()
		cooldown--
		if(cooldown <= 0)	return 0
		spawn(10)
			Process_cooldown()
		return 1


	Attach_Holder(var/obj/H, var/mob/user)
		if(!H)	return 0
		if(!H.IsAssemblyHolder())	return 0
		//Remember to have it set its loc somewhere in here


*/
