//bayadd

/datum/controller/subsystem/proc/enable()
	if (!can_fire)
		next_fire = world.time + wait
		can_fire = TRUE
