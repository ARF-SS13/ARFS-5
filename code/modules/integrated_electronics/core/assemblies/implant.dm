// Note that this is contained inside an actual implant subtype.
// See code/game/objects/items/weapons/implants/implantcircuits.dm for where this gets held.
/*
/obj/item/device/electronic_assembly/implant
	name = "electronic implant"
	icon_state = "setup_implant"
	desc = "It's a case, for building very tiny electronics with."
	w_class = ITEMSIZE_TINY
	max_components = IC_MAX_SIZE_BASE / 2
	max_complexity = IC_COMPLEXITY_BASE / 2
	var/obj/item/weapon/implant/integrated_circuit/implant = null

/obj/item/device/electronic_assembly/implant/nano_host()
	return implant

/obj/item/device/electronic_assembly/implant/resolve_nano_host()
	return implant

/obj/item/device/electronic_assembly/implant/update_icon()
	..()
	implant.icon_state = icon_state

/*
/obj/item/device/electronic_assembly/implant/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/weapon/implanter))
		var/obj/item/weapon/implanter/implanter = I
		if(implanter.imp)
			return // It's full.
		user.drop_from_inventory(src)
		forceMove(implanter)
		implanter.imp = src
		implanter.update()
	..()

/obj/item/device/electronic_assembly/implant/proc/handle_implant(var/mob/source, var/target_zone = BP_TORSO)
	implant.handle_implant(source, target_zone)
	return

// Takes place after handle_implant, if that returns TRUE
/obj/item/device/electronic_assembly/implant/proc/post_implant(var/mob/source)
	 implant.post_implant(source)

/obj/item/device/electronic_assembly/proc/get_data()
	return "No information available"
*/
*/
//This doesn't work, sadly.
