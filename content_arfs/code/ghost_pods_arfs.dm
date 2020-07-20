//globals so the lists dont get generated more than once
var/global/list/pokemon_choices_list = list()//Referenced list for use in input()
var/global/list/pokemon_pods = list()//List of pods that ghosts can spawn at

//Pod to spawn in as pokemon or other mobs.
/obj/structure/ghost_pod/ghost_activated/pokemon
	name = "\improper Pokemon resleever"
	desc = "A glowing pod which features a holographic display showing several animal companions. A Pokemon or similar creature may be uploaded into a body from here."
	description_info = "A ghost can click on this to spawn in as a Pokemon or similar mob."
	icon = 'icons/obj/structures.dmi'
	icon_state = "borg_pod_closed"
	icon_state_opened = "borg_pod_opened"
	anchored = TRUE
	var/do_announcement = TRUE //FALSE won't give them a choice of announcing
	var/list/remove_paths = list(/mob/living/simple_mob/animal/passive/pokemon/leg, 		//Can tailor this list for different types of
						    /mob/living/simple_mob/animal/passive/pokemon,					//spawners down the line
						    /mob/living/simple_mob/animal/passive/pokemon/jolteon/bud)

/obj/structure/ghost_pod/ghost_activated/pokemon/Initialize()
	. = ..()
	generate_lists()
	var/turf/T = get_turf(src)
	pokemon_pods["[T.loc]"] = src

/obj/structure/ghost_pod/ghost_activated/pokemon/proc/generate_lists()
	if(LAZYLEN(pokemon_choices_list))
		return FALSE	//The global list is already generated
	var/pokemon_choices_list_paths = typesof(/mob/living/simple_mob/animal/passive/pokemon) - remove_paths
	for (var/path in pokemon_choices_list_paths)//add the mobs to a list with their names referencing paths
		var/mob/living/simple_mob/animal/passive/pokemon/P = new path()
		pokemon_choices_list["[P.name]"] = P.type
		qdel(P)

/obj/structure/ghost_pod/manual/attack_hand(var/mob/living/user)
	//Inform curious minds about how to use this.
	to_chat(user, "<span class='notice'>You can't seem to find a way to interact with this from the outside.</span>")
	to_chat(user, "<span class='warning'>(Only observers may use [src])</span>")
	return

/obj/structure/ghost_pod/ghost_activated/pokemon/attack_ghost(var/mob/observer/dead/user)
	if (ticker.current_state != GAME_STATE_PLAYING)
		to_chat(user, "<span class='warning'>The round either hasn't started yet or has ended.</span>")
		return
	if (!LAZYLEN(pokemon_choices_list))
		to_chat(user, "<span class='warning'>Pod configuration error. Report this to a developer.</span>")
		return
	create_occupant(user)

/obj/structure/ghost_pod/ghost_activated/pokemon/create_occupant(var/mob/M)
	var/m_ckey = M.ckey
	var/turf/T
	var/area/A
	var/p_choice = input(M, "What would you like to spawn in as?", "[src.name]") as null|anything in pokemon_choices_list
	if(!p_choice || isnull(p_choice))
		to_chat(M, "<span class='notice'>Spawning aborted.</span>")
		return
	p_choice = pokemon_choices_list["[p_choice]"]
	var/newname = input(M, "Would you like to change your name or use the default one? Enter nothing to use the default name. Canceling will stop the spawning process.", "Name Change") as null|text
	if(isnull(newname))
		to_chat(M, "<span class='notice'>Spawning aborted.</span>")
		return
	newname = sanitize(newname, MAX_NAME_LEN)//Sanitize the name afterwards, so we know if they hit cancel or input an empty string
	var/new_gender = input(M, "Choose your Pokemon's gender:", "Character Preference", "neuter") as null|anything in list("neuter", "male", "female")
	if(isnull(new_gender))
		to_chat(M, "<span class='notice'>Spawning aborted.</span>")
		return
	var/announce_choice = FALSE
	if(do_announcement)
		announce_choice = input(M, "Would you like to announce your arrival over the common radio channel?", "[src.name]") as null|anything in list("Yes","No")
		if(isnull(announce_choice))
			to_chat(M, "<span class='notice'>Spawning aborted.</span>")
			return
		if(announce_choice == "Yes")
			announce_choice = TRUE
	T = get_turf(src)
	A = T.loc
	var/mob/living/simple_mob/animal/passive/pokemon/P = new p_choice(T)
	if(newname)//Still not empty after sanitization
		P.name = newname
		P.voice_name = P.name
	P.real_name = P.name
	if(new_gender)
		P.gender = new_gender
	if(M.mind)
		M.mind.transfer_to(P)
	if(m_ckey)
		P.ckey = m_ckey

	var/obj/item/device/radio/headset/mob_headset/R = new
	R.forceMove(P)
	P.mob_radio = R //Implant a mob radio on them so they can communicate over a distance and hear what's going on. Being left in the dark isn't fun.

	log_and_message_admins("used \the [src] and became \an [initial(P.name)] named [P.name].")

	to_chat(P, "<span class='notice'>You are a <b>Pokemon</b>, an artifically designed creature. Exiting the sleeve pod, your memories \
	slowly start to come back to you as your mind adapts to this new body.</span>")
	to_chat(P, "<span class='warning'>(OOC: While you may roleplay as the same pokemon each time you use this spawner, please respect \
	normal resleeving rules regarding memory. Your mind is 'scanned' upon successful crew transfer or whenever you enter cryogenic \
	storage and it's uploaded when you use this pod to spawn in. Respawning in this manner does not upload your regular character's \
	mind into this body. Additionally, you may set your OOC Notes and Flavortext with the <b>\"Set OOC Notes\"</b> and <b>\"Set Flavortext\"</b> verbs.)</span>")

	visible_message("<span class='notice'>[src] dings and hisses before its doors slowly open and \the [P.name] steps out!</span>")
	playsound(src, 'sound/machines/microwave/microwave-end.ogg', 100)

	P.forceMove(T)

	//Announce the pokemon spawning.
	if(announce_choice && P.z)//We aren't in nullspace
		AnnounceArrivalSimple(P.name, "Pokemon", "has been resleeved at [A]", "Common", P.z)
