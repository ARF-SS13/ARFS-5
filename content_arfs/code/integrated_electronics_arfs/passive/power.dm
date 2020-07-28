
/obj/item/integrated_circuit/passive/power
	name = "power thingy"
	desc = "Does power stuff."
	complexity = 5
	category_text = "Power - Passive"

/obj/item/integrated_circuit/passive/power/proc/make_energy()
	return

// For calculators.
/obj/item/integrated_circuit/passive/power/solar_cell
	name = "tiny photovoltaic cell"
	desc = "It's a very tiny solar cell, generally used in calculators."
	extended_desc = "This cell generates 1 W of power in optimal lighting conditions. Less light will result in less power being generated."
	icon_state = "solar_cell"
	complexity = 8
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	var/max_power = 30

/obj/item/integrated_circuit/passive/power/solar_cell/make_energy()
	var/turf/T = get_turf(src)
	var/light_amount = T ? T.get_lumcount() : 0
	var/adjusted_power = max(max_power * light_amount, 0)
	adjusted_power = round(adjusted_power, 0.1)
	if(adjusted_power)
		if(assembly)
			assembly.give_power(adjusted_power)

/obj/item/integrated_circuit/passive/power/starter
	name = "starter"
	desc = "This tiny circuit will send a pulse right after the device is turned on, or when power is restored to it."
	icon_state = "led"
	complexity = 1
	activators = list("pulse out" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	var/is_charge = FALSE

/obj/item/integrated_circuit/passive/power/starter/make_energy()
	if(assembly.battery)
		if(assembly.battery.charge)
			if(!is_charge)
				activate_pin(1)
			is_charge = TRUE
		else
			is_charge = FALSE
	else
		is_charge=FALSE
	return FALSE

// For fat machines that need fat power, like drones.
/obj/item/integrated_circuit/passive/power/relay
	name = "tesla power relay"
	desc = "A seemingly enigmatic device which connects to nearby APCs wirelessly and draws power from them."
	w_class = ITEMSIZE_SMALL
	extended_desc = "The siphon drains 50 W of power from an APC in the same room as it as long as it has charge remaining. It will always drain \
	from the 'equipment' power channel."
	icon_state = "power_relay"
	complexity = 7
	spawn_flags = IC_SPAWN_RESEARCH
	var/power_amount = 50


/obj/item/integrated_circuit/passive/power/relay/make_energy()
	if(!assembly)
		return
	var/area/A = get_area(src)
	if(A && A.powered(EQUIP) && assembly.give_power(power_amount))
		A.use_power_oneoff(power_amount, EQUIP)
		// give_power() handles CELLRATE on its own.


// For really fat machines.
/obj/item/integrated_circuit/passive/power/relay/large
	name = "large tesla power relay"
	desc = "A seemingly enigmatic device which connects to nearby APCs wirelessly and draws power from them, now in industrial size!"
	w_class = ITEMSIZE_LARGE
	extended_desc = "The siphon drains 2 kW of power from an APC in the same room as it as long as it has charge remaining. It will always drain \
 	from the 'equipment' power channel."
	icon_state = "power_relay"
	complexity = 15
	spawn_flags = IC_SPAWN_RESEARCH
	power_amount = 2000


//fuel cell
/obj/item/integrated_circuit/passive/power/chemical_cell
	name = "fuel cell"
	desc = "Produces electricity from chemicals."
	icon_state = "chemical_cell"
	extended_desc = "This is effectively an internal beaker. It will consume and produce power from phoron, welding fuel, carbon,\
	 ethanol, nutriment, and blood in order of decreasing efficiency. It will consume fuel only if the battery can take more energy."
	complexity = 4
	inputs = list()
	outputs = list("volume used" = IC_PINTYPE_NUMBER, "self reference" = IC_PINTYPE_REF)
	activators = list("push ref" = IC_PINTYPE_PULSE_IN)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	var/volume = 60
	var/list/fuel = list(/datum/reagent/toxin/phoron = 50000, /datum/reagent/fuel = 15000, /datum/reagent/carbon = 10000, /datum/reagent/ethanol = 10000, /datum/reagent/nutriment = 8000)
	var/multi = 1
	var/lfwb =TRUE

/obj/item/integrated_circuit/passive/power/chemical_cell/New()
	..()
	create_reagents(volume)
	extended_desc +="But no fuel can be compared with blood of living human."


/obj/item/integrated_circuit/passive/power/chemical_cell/interact(mob/user)
	set_pin_data(IC_OUTPUT, 2, weakref(src))
	push_data()
	..()

/obj/item/integrated_circuit/passive/power/chemical_cell/on_reagent_change(changetype)
	set_pin_data(IC_OUTPUT, 1, reagents.total_volume)
	push_data()

/obj/item/integrated_circuit/passive/power/chemical_cell/make_energy()
	if(assembly)
		if(assembly.battery)
			var/bp = 5000
			if((assembly.battery.maxcharge-assembly.battery.charge) / CELLRATE > bp && reagents.remove_reagent(/datum/reagent/blood, 1)) //only blood is powerful enough to power the station(c)
				assembly.give_power(bp)
			for(var/I in fuel)
				if((assembly.battery.maxcharge-assembly.battery.charge) / CELLRATE > fuel[I])
					if(reagents.remove_reagent(I, 1))
						assembly.give_power(fuel[I]*multi)

/obj/item/integrated_circuit/passive/power/chemical_cell/do_work()
	set_pin_data(IC_OUTPUT, 2, weakref(src))
	push_data()

/*

/obj/item/integrated_circuit/passive/power/powernet
	name = "power network interface"
	desc = "Gives or takes power from a wire underneath the machine."
	icon_state = "powernet"
	extended_desc = "The assembly must be anchored, with a wrench, and a wire node must be avaiable directly underneath.<br>\
	The first pin determines if power is moved at all. The second pin, if true, will draw from the powernet to charge the assembly's \
	cell, otherwise it will give power from the cell to the powernet."
	complexity = 20
	inputs = list(
		"active" = IC_PINTYPE_BOOLEAN,
		"draw power" = IC_PINTYPE_BOOLEAN
		)
	outputs = list(
		"power in grid" = IC_PINTYPE_NUMBER,
		"surplus power" = IC_PINTYPE_NUMBER,
		"load" = IC_PINTYPE_NUMBER
		)
	activators = list()
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 2, TECH_POWER = 2)
	var/obj/machinery/power/circuit_io/IO = null // Dummy power machine to move energy in/out without a bunch of code duplication.
	var/throughput = 10000 // Give/take up to 10kW.

/obj/item/integrated_circuit/passive/power/powernet/Initialize()
	IO = new(src)
	return ..()

/obj/item/integrated_circuit/passive/power/powernet/Destroy()
	qdel(IO)
	return ..()

/obj/item/integrated_circuit/passive/power/powernet/on_anchored()
	IO.connect_to_network()

/obj/item/integrated_circuit/passive/power/powernet/on_unanchored()
	IO.disconnect_from_network()

/obj/item/integrated_circuit/passive/power/powernet/make_energy()
	if(assembly && assembly.anchored && assembly.battery)
		var/should_act = get_pin_data(IC_INPUT, 1) // Even if this is false, we still need to update the output pins with powernet information.
		var/drawing = get_pin_data(IC_INPUT, 2)

		if(should_act) // We're gonna give or take from the net.
			if(drawing)
				var/to_transfer = min(throughput, assembly.battery.amount_missing() / CELLRATE) // So we don't need to draw 10kW if the cell needs much less.
				var/amount = IO.draw_power(to_transfer)
				assembly.give_power(amount)
			else
				var/amount = assembly.draw_power(throughput)
				IO.add_avail(amount)

		set_pin_data(IC_OUTPUT, 1, IO.avail())
		set_pin_data(IC_OUTPUT, 2, IO.surplus())
		set_pin_data(IC_OUTPUT, 3, IO.viewload())

// Internal power machine for interacting with the powernet.
// It needs a bit of special code since base /machinery/power assumes loc will be a tile.
/obj/machinery/power/circuit_io
	name = "embedded electrical I/O"

/obj/machinery/power/circuit_io/connect_to_network()
	var/turf/T = get_turf(src)
	if(!T || !istype(T))
		return FALSE

	var/obj/structure/cable/C = T.get_cable_node()
	if(!C || !C.powernet)
		return FALSE

	C.powernet.add_machine(src)
	return TRUE

	*/