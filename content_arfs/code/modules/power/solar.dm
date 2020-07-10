// Used for mapping in solar array which automatically starts itself (telecomms, for example)
/obj/machinery/power/solar_control/arfsautostart
	track = 2 // Auto tracking mode

/obj/machinery/power/solar_control/arfsautostart/Initialize()
	..()
	spawn(150) // Wait 15 seconds to ensure everything was set up properly (such as, powernets, solar panels, etc.
		src.search_for_connected()
		if(connected_tracker && track == 2)
			connected_tracker.set_angle(SSsun.sun.angle)
		src.set_panels(cdir)
