//Custom airlocks and airlock code
/obj/machinery/door/airlock/ckey
	desc = "Looks like this airlock has been fitted with a DNA scanner to only allow certain people through."
	var/list/req_one_ckey = list() //If you have a key in this list you can open the door. NO CAPITALIZATION

/obj/machinery/door/airlock/ckey/allowed(mob/M)
	if(locked)
		return 0
	if(!LAZYLEN(req_one_ckey) || !M.ckey)
		return ..(M)//No ckey list or no ckey. Callback
	if(M.ckey in req_one_ckey)
		return 1
	return 0
