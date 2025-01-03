
/proc/power_failure(var/announce = 1, var/severity = 2, var/list/affected_z_levels)
	if(announce)
		global.using_map.grid_check_announcement()

	for(var/obj/machinery/power/generator/transformer/switchable/T in SSmachines.machinery)
		if(T.on && !T.critical && (!affected_z_levels || (T.z in affected_z_levels)))
			if(prob(10))
				T.trip()

	for(var/obj/machinery/power/apc/C in SSmachines.machinery)
		if(!C.is_critical && (!affected_z_levels || (C.z in affected_z_levels)))
			C.energy_fail(rand(30 * severity,60 * severity))

/proc/power_restore(var/announce = 1)
	if(announce)
		global.using_map.grid_restored_announcement()
	for(var/obj/machinery/power/apc/C in SSmachines.machinery)
		C.failure_timer = 0
		var/obj/item/cell/cell = C.get_cell()
		if(cell)
			cell.charge = cell.maxcharge
	for(var/obj/machinery/power/generator/smes/S in SSmachines.machinery)
		S.failure_timer = 0
		S.charge = S.capacity
		S.update_icon()
		S.power_change()

/proc/power_restore_quick(var/announce = 1)

	if(announce)
		command_announcement.Announce("All SMESs on the [station_name()] have been recharged. We apologize for the inconvenience.", "Power Systems Nominal", new_sound = global.using_map.grid_restored_sound)
	for(var/obj/machinery/power/generator/smes/S in SSmachines.machinery)
		S.failure_timer = 0
		S.charge = S.capacity
		S.output_level = S.output_level_max
		S.output_attempt = 1
		S.input_attempt = 1
		S.update_icon()
		S.power_change()
