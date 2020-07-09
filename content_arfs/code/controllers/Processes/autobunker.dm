var/global/datum/controller/process/autobunker/autobunkerProcess

/datum/controller/process/autobunker
	var/max_afk = 30
	var/list/alert_times = list(5,10,15,20,25,26,27,28) //5 = 25 minutes, 28 = 2 minutes

/datum/controller/process/autobunker/setup()
	name = "autobunker"
	schedule_interval = 600 //Every minute
	autobunkerProcess = src

/datum/controller/process/autobunker/doWork()
	var/non_afk_admins = 0
	var/afk_admins = 0
	var/min_afk_admin_activity = 0
	var/temp_afk_admin_activity

	if(config.panic_bunker == 0)          //Panic bumker is open
		for(var/client/C in admins)       //Get a list of admins
			if(R_ADMIN & C.holder.rights) //Make sure they have admin rights
				if(!C.is_afk())           //Get a count of non-AFK admins
					non_afk_admins += 1
					return				  //Remove this if you want to do something when there are a certain amount of online admins
				else
					afk_admins += 1
					temp_afk_admin_activity = round(C.last_activity_seconds()/60)
					if(temp_afk_admin_activity < min_afk_admin_activity || min_afk_admin_activity == 0)
						min_afk_admin_activity = temp_afk_admin_activity

		if(non_afk_admins > 0)
			return

		if(non_afk_admins == 0 && afk_admins > 0)
			if(min_afk_admin_activity < max_afk)
				if(min_afk_admin_activity == max_afk - 1)
					message_admins("No active admins, panic bunker closing in 1 minute!")
					return
				if(min_afk_admin_activity in alert_times)
					message_admins("No active admins, panic bunker closing in [max_afk - min_afk_admin_activity] minutes!")
					return
			else
				log_admin("Panic bunker open with no active admins. Autobunker has closed the panic bunker.")
				message_admins("Panic bunker open with no active admins. Autobunker has closed the panic bunker.")
				config.panic_bunker = 1
				return

		if(non_afk_admins == 0 && afk_admins == 0)
			log_admin("Panic bunker open with no admins online. Panic bunker closed by Autobunker.")
			config.panic_bunker = 1
			return