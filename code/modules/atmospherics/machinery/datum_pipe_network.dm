/datum/pipe_network
	var/list/datum/gas_mixture/gases = list() //All of the gas_mixtures continuously connected in this network
	var/volume = 0	//caches the total volume for atmos machines to use in gas calculations

	var/list/obj/machinery/atmospherics/normal_members = list()
	var/list/datum/pipeline/line_members = list()
		//membership roster to go through for updates and what not
	var/list/leaks = list()
	var/update = 1
	var/net_flow_mass = 0 //kg/s of flow summed from pumps and whatever

/datum/pipe_network/Destroy()
	STOP_PROCESSING_PIPENET(src)
	for(var/datum/pipeline/line_member in line_members)
		line_member.network = null
	for(var/obj/machinery/atmospherics/normal_member in normal_members)
		normal_member.reassign_network(src, null)
	gases.Cut()  // Do not qdel the gases, we don't own them
	leaks.Cut()
	normal_members.Cut()
	line_members.Cut()
	return ..()

/datum/pipe_network/Process()
	//Equalize gases amongst pipe if called for
	if(update)
		update = 0
		equalize_gases(gases)
		net_flow_mass = 0
		for(var/obj/machinery/atmospherics/binary/pump/adv/P in normal_members) //TODO: ACCOUNT FOR DIRECTION
			net_flow_mass += P.last_mass_flow
		for(var/obj/machinery/atmospherics/binary/regulated_valve/V in normal_members)
			var/datum/gas_mixture/verify_mixture = pick(gases)
			if(V.air2.temperature == verify_mixture.temperature) //A crazy workaround to having a valve constantly adding mass flow to itself
				net_flow_mass += V.air1.net_flow_mass
		for(var/datum/gas_mixture/gm in gases)
			gm.net_flow_mass = net_flow_mass

	//Give pipelines their process call for pressure checking and what not. Have to remove pressure checks for the time being as pipes dont radiate heat - Mport
	//for(var/datum/pipeline/line_member in line_members)
	//	line_member.process()

/datum/pipe_network/proc/build_network(obj/machinery/atmospherics/start_normal, obj/machinery/atmospherics/reference)
	//Purpose: Generate membership roster
	//Notes: Assuming that members will add themselves to appropriate roster in network_expand()

	if(!start_normal)
		qdel(src)
		return
	start_normal.network_expand(src, reference)

	update_network_gases()

	if((normal_members.len>0)||(line_members.len>0))
		START_PROCESSING_PIPENET(src)
		return 1
	qdel(src)

/datum/pipe_network/proc/merge(datum/pipe_network/giver)
	if(giver==src) return 0

	normal_members |= giver.normal_members

	line_members |= giver.line_members

	leaks |= giver.leaks

	for(var/obj/machinery/atmospherics/normal_member in giver.normal_members)
		normal_member.reassign_network(giver, src)

	for(var/datum/pipeline/line_member in giver.line_members)
		line_member.network = src

	qdel(giver)

	update_network_gases()
	return 1

/datum/pipe_network/proc/update_network_gases()
	//Go through membership roster and make sure gases is up to date

	gases = list()
	volume = 0

	for(var/obj/machinery/atmospherics/normal_member in normal_members)
		var/result = normal_member.return_network_air(src)
		if(result) gases += result

	for(var/datum/pipeline/line_member in line_members)
		gases += line_member.air

	for(var/datum/gas_mixture/air in gases)
		volume += air.volume
