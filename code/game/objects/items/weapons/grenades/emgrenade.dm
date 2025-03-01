/obj/item/grenade/empgrenade
	name = "classic emp grenade"
	icon = 'icons/obj/items/grenades/emp.dmi'
	origin_tech = @'{"materials":2,"magnets":3}'
	var/emp_light_range = 10
	var/emp_heavy_range = 4

/obj/item/grenade/empgrenade/detonate()
	..()
	if(empulse(src, 4, 10))
		qdel(src)
	return

/obj/item/grenade/empgrenade/low_yield
	name = "low yield emp grenade"
	desc = "A weaker variant of the classic emp grenade."
	icon = 'icons/obj/items/grenades/emp_old.dmi'
	origin_tech = @'{"materials":2,"magnets":3}'

/obj/item/grenade/empgrenade/low_yield/detonate()
	..()
	if(empulse(src, 4, 1))
		qdel(src)
	return
