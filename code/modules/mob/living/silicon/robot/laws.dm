/mob/living/silicon/robot/verb/cmd_show_laws()
	set category = "Silicon Commands"
	set name = "Show Laws"
	show_laws()

/mob/living/silicon/robot/show_laws(var/everyone = 0)
	laws_sanity_check()
	var/who

	if (everyone)
		who = world
	else
		who = src
	if(lawupdate)
		if (connected_ai)
			if(connected_ai.stat || connected_ai.control_disabled)
				to_chat(src, "<b>AI signal lost, unable to sync laws.</b>")

			else
				lawsync()
				photosync()
				to_chat(src, "<b>Laws synced with AI, be sure to note any changes.</b>")
				// TODO: Update to new antagonist system.
				if(mind && mind.assigned_special_role == /decl/special_role/traitor && mind.original == src)
					to_chat(src, "<b>Remember, your AI does NOT share or know about your law 0.</b>")
		else
			to_chat(src, "<b>No AI selected to sync laws with, disabling lawsync protocol.</b>")
			lawupdate = 0

	to_chat(who, SPAN_BOLD("Obey the following laws."))
	to_chat(who, SPAN_ITALIC("All laws have equal priority. Laws may override other laws if written specifically to do so. If laws conflict, break the least."))
	laws.show_laws(who)

/mob/living/silicon/robot/lawsync()
	laws_sanity_check()
	var/datum/ai_laws/master = connected_ai && lawupdate ? connected_ai.laws : null
	if (master)
		master.sync(src)
	..()
	return

/mob/living/silicon/robot/proc/robot_checklaws()
	set category = "Silicon Commands"
	set name = "State Laws"
	open_subsystem(/datum/nano_module/law_manager)
