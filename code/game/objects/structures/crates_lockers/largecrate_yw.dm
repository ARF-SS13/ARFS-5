/obj/structure/largecrate/piano
	name = "piano crate"
	starts_with = list(/obj/structure/device/piano)
	desc = "*Grand piano may end up being a minimoog."

/obj/structure/largecrate/piano/Initialize() //This is nessesary to get a random one each time.
	starts_with = list(pick(/obj/structure/device/piano/minimoog,
					/obj/structure/device/piano))
	return ..()