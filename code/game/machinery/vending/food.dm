
/obj/machinery/vending/snack
	name = "old food vendor"
	desc = "A typical snack machine."
	product_slogans = "Try our new nougat bar!;Twice the calories for half the price!"
	icon_state = "snack"
	icon_vend = "snack-vend"
	icon_deny = "snack-deny"
	vend_delay = 25
	base_type = /obj/machinery/vending/snack
	products = list()
	contraband = list(
		/obj/item/chems/food/syndicake = 0
	)

//a food variant of the boda machine - It carries slavic themed foods.. Mostly beer snacks
/obj/machinery/vending/snix
	name = "Snix"
	desc = "An old snack vending machine, how did it get here? And are the snacks still good?"
	vend_delay = 30
	base_type = /obj/machinery/vending/snix
	product_slogans = "Snix!"

	icon_state = "snix"
	icon_vend = "snix-vend"
	icon_deny = "snix-deny"
	products = list(/obj/item/chems/food/semki = 7,
					/obj/item/chems/food/can/caviar = 7,
					/obj/item/chems/food/squid = 7,
					/obj/item/chems/food/croutons = 7,
					/obj/item/chems/food/salo = 7,
					/obj/item/chems/food/driedfish = 7,
					/obj/item/chems/food/pistachios = 7,
					)

	contraband = list(/obj/item/chems/food/can/caviar/true = 1)

/obj/machinery/vending/snix/on_update_icon()
	..()
	if(!(stat & NOPOWER))
		overlays += image(icon, "[initial(icon_state)]-fan")

/obj/machinery/vending/sol
	name = "Mars-Mart"
	desc = "A SolCentric vending machine dispensing treats from home."
	vend_delay = 30
	product_slogans = "A taste of home!"
	icon_state = "solsnack"
	icon_vend = "solsnack-vend"
	icon_deny = "solsnack-deny"
	products = list(
		/obj/item/chems/food/lunacake = 8,
		/obj/item/chems/food/lunacake/mochicake = 8,
		/obj/item/chems/food/lunacake/mooncake = 8,
		/obj/item/chems/food/pluto = 8,
		/obj/item/chems/food/triton = 8,
		/obj/item/chems/food/saturn = 8,
		/obj/item/chems/food/jupiter = 8,
		/obj/item/chems/food/mars = 8,
		/obj/item/chems/food/venus = 8,
		/obj/item/chems/food/oort = 8
	)

/obj/machinery/vending/weeb
	name = "Nippon-tan!"
	desc = "A distressingly ethnic vending machine loaded with high sucrose low calorie for lack of better words snacks."
	vend_delay = 30
	product_slogans = "Konnichiwa gaijin senpai! ;Notice me senpai!; Kawaii-desu!"
	icon_state = "weeb"
	icon_vend = "weeb-vend"
	icon_deny = "weeb-deny"
	products = list()

/obj/machinery/vending/weeb/on_update_icon()
	..()
	if(!(stat & NOPOWER))
		overlays += image(icon, "[initial(icon_state)]-fan")

/obj/machinery/vending/hotfood
	name = "Hot Foods"
	desc = "An old vending machine promising 'hot foods'. You doubt any of its contents are still edible."
	vend_delay = 40
	base_type = /obj/machinery/vending/hotfood

	icon_state = "hotfood"
	icon_deny = "hotfood-deny"
	icon_vend = "hotfood-vend"
	products = list(/obj/item/chems/food/old/pizza = 1,
					/obj/item/chems/food/old/burger = 1,
					/obj/item/chems/food/old/hamburger = 1,
					/obj/item/chems/food/old/fries = 1,
					/obj/item/chems/food/old/hotdog = 1,
					/obj/item/chems/food/old/taco = 1
					)

/obj/machinery/vending/hotfood/on_update_icon()
	..()
	if(!(stat & NOPOWER))
		overlays += image(icon, "[initial(icon_state)]-heater")

/obj/machinery/vending/boozeomat
	name = "Booze-O-Mat"
	desc = "A refrigerated vending unit for alcoholic beverages and alcoholic beverage accessories."
	icon_state = "fridge_dark"
	icon_deny = "fridge_dark-deny"
	markup = 0
	products = list(
		/obj/item/chems/drinks/glass2/square = 10,
		/obj/item/chems/drinks/flask/barflask = 5,
		/obj/item/chems/drinks/flask/vacuumflask = 5,
		/obj/item/chems/drinks/bottle/gin = 5,
		/obj/item/chems/drinks/bottle/whiskey = 5,
		/obj/item/chems/drinks/bottle/tequila = 5,
		/obj/item/chems/drinks/bottle/vodka = 5,
		/obj/item/chems/drinks/bottle/vermouth = 5,
		/obj/item/chems/drinks/bottle/rum = 5,
		/obj/item/chems/drinks/bottle/wine = 5,
		/obj/item/chems/drinks/bottle/cognac = 5,
		/obj/item/chems/drinks/bottle/kahlua = 5,
		/obj/item/chems/drinks/bottle/sake = 5,
		/obj/item/chems/drinks/bottle/jagermeister = 5,
		/obj/item/chems/drinks/bottle/melonliquor = 5,
		/obj/item/chems/drinks/bottle/bluecuracao = 5,
		/obj/item/chems/drinks/bottle/absinthe = 5,
		/obj/item/chems/drinks/bottle/champagne = 5,
		/obj/item/chems/drinks/bottle/herbal = 5,
		/obj/item/chems/drinks/bottle/small/beer = 15,
		/obj/item/chems/drinks/bottle/small/ale = 15,
		/obj/item/chems/drinks/bottle/small/gingerbeer = 15,
		/obj/item/chems/drinks/cans/speer = 10,
		/obj/item/chems/drinks/cans/ale = 10,
		/obj/item/chems/drinks/bottle/cola = 5,
		/obj/item/chems/drinks/bottle/space_up = 5,
		/obj/item/chems/drinks/bottle/space_mountain_wind = 5,
		/obj/item/chems/drinks/cans/beastenergy = 5,
		/obj/item/chems/drinks/tea/black = 15,
		/obj/item/chems/drinks/bottle/orangejuice = 5,
		/obj/item/chems/drinks/bottle/tomatojuice = 5,
		/obj/item/chems/drinks/bottle/limejuice = 5,
		/obj/item/chems/drinks/cans/tonic = 15,
		/obj/item/chems/drinks/bottle/cream = 5,
		/obj/item/chems/drinks/cans/sodawater = 15,
		/obj/item/chems/drinks/bottle/grenadine = 5,
		/obj/item/chems/condiment/mint = 2,
		/obj/item/chems/drinks/ice = 10,
		/obj/item/glass_extra/stick = 15,
		/obj/item/glass_extra/straw = 15
	)
	contraband = list(
		/obj/item/chems/drinks/bottle/premiumwine = 3,
		/obj/item/chems/drinks/bottle/premiumvodka = 3,
		/obj/item/chems/drinks/bottle/patron = 5,
		/obj/item/chems/drinks/bottle/goldschlager = 5
	)
	vend_delay = 15
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	product_slogans = "I hope nobody asks me for a bloody cup o' tea...;Alcohol is humanity's friend. Would you abandon a friend?;Quite delighted to serve you!;Is nobody thirsty on this station?"
	product_ads = "Drink up!;Booze is good for you!;Alcohol is humanity's best friend.;Quite delighted to serve you!;Care for a nice, cold beer?;Nothing cures you like booze!;Have a sip!;Have a drink!;Have a beer!;Beer is good for you!;Only the finest alcohol!;Best quality booze since 2053!;Award-winning wine!;Maximum alcohol!;Man loves beer.;A toast for progress!"
	initial_access = list(access_bar)
	base_type = /obj/machinery/vending/boozeomat


/obj/machinery/vending/coffee
	name = "Hot Drinks machine"
	desc = "A vending machine which dispenses hot drinks and hot drinks accessories."
	product_ads = "Have a drink!;Drink up!;It's good for you!;Would you like a hot joe?;I'd kill for some coffee!;The best beans in the galaxy.;Only the finest brew for you.;Mmmm. Nothing like a coffee.;I like coffee, don't you?;Coffee helps you work!;Try some tea.;We hope you like the best!;Try our new chocolate!;Admin conspiracies"
	icon_state = "coffee"
	icon_vend = "coffee-vend"
	icon_deny = "coffee-deny"
	vend_delay = 34
	base_type = /obj/machinery/vending/coffee
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	vend_power_usage = 85000 //85 kJ to heat a 250 mL cup of coffee
	products = list(
		/obj/item/chems/drinks/coffee = 15,
		/obj/item/chems/drinks/tea/black = 15,
		/obj/item/chems/drinks/tea/green = 15,
		/obj/item/chems/drinks/tea/chai = 15,
		/obj/item/chems/drinks/h_chocolate = 10,
		/obj/item/chems/condiment/small/packet/sugar = 25,
		/obj/item/chems/pill/pod/cream = 25,
		/obj/item/chems/pill/pod/cream_soy = 25,
		/obj/item/chems/pill/pod/orange = 10,
		/obj/item/chems/pill/pod/mint = 10,
		/obj/item/chems/drinks/ice = 10
	)

/obj/machinery/vending/coffee/on_update_icon()
	..()
	if(stat & BROKEN && prob(20))
		icon_state = "[initial(icon_state)]-hellfire"
	else if(!(stat & NOPOWER))
		overlays += image(icon, "[initial(icon_state)]-screen")

/obj/machinery/vending/cola
	name = "softdrink machine"
	desc = "A softdrink vendor provided by Robust Industries, LLC."
	icon_state = "Cola_Machine"
	icon_vend = "Cola_Machine-vend"
	icon_deny = "Cola_Machine-deny"
	vend_delay = 11
	base_type = /obj/machinery/vending/cola
	products = list()
	contraband = list(
		/obj/item/chems/drinks/cans/thirteenloko = 5,
		/obj/item/chems/food/liquidfood = 6
	)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.

/obj/machinery/vending/fitness
	name = "SweatMAX"
	desc = "An exercise aid and nutrition supplement vendor that preys on your inadequacy."
	product_slogans = "SweatMAX, get robust!"
	product_ads = "Pain is just weakness leaving the body!;Run! Your fat is catching up to you;Never forget leg day!;Push out!;This is the only break you get today.;Don't cry, sweat!;Healthy is an outfit that looks good on everybody."
	icon_state = "fitness"
	icon_vend = "fitness-vend"
	icon_deny = "fitness-deny"
	vend_delay = 6
	base_type = /obj/machinery/vending/fitness
	products = list(
		/obj/item/chems/drinks/milk/smallcarton = 8,
		/obj/item/chems/drinks/milk/smallcarton/chocolate = 8,
		/obj/item/chems/drinks/cans/waterbottle = 8,
		/obj/item/chems/drinks/glass2/fitnessflask/proteinshake = 8,
		/obj/item/chems/drinks/glass2/fitnessflask = 8,
		/obj/item/chems/food/candy/proteinbar = 8,
		/obj/item/storage/mre/random = 8,
		/obj/item/storage/mre/menu9 = 4,
		/obj/item/storage/mre/menu10 = 4,
		/obj/item/towel/random = 8
	)
	contraband = list(/obj/item/chems/syringe/steroid = 4)

/obj/machinery/vending/fitness/on_update_icon()
	..()
	if(!(stat & NOPOWER))
		overlays += image(icon, "[initial(icon_state)]-overlay")

/obj/machinery/vending/sovietsoda
	name = "BODA"
	desc = "An old soda vending machine. How could this have got here?"
	icon_state = "sovietsoda"
	icon_vend = "sovietsoda-vend"
	icon_deny = "sovietsoda-deny"
	base_type = /obj/machinery/vending/sovietsoda
	product_ads = "For Tsar and Country.;Have you fulfilled your nutrition quota today?;Very nice!;We are simple people, for this is all we eat.;If there is a person, there is a problem. If there is no person, then there is no problem."
	products = list()
	contraband = list(/obj/item/chems/drinks/bottle/space_up = 8) // TODO Russian cola can
	idle_power_usage = 211
