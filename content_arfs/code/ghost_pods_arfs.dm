//Pod to spawn in as pokemon or other mobs.
/obj/structure/ghost_pod/ghost_activated/pokemon
	name = "\improper Pokemon resleever"
	desc = "A glowing pod which features a holographic display showing several animal companions. A Pokemon or similar creature may be uploaded into a body from here."
	description_info = "A ghost can click on this to spawn in as a Pokemon or similar mob."
	icon = 'icons/obj/structures.dmi'
	icon_state = "borg_pod_closed"
	icon_state_opened = "borg_pod_opened"
	anchored = TRUE
	var/p_list = list()
	var/p_list_types = /mob/living/simple_mob/animal/passive/pokemon //Subtypes of this will be added to p_list
	var/p_list_paths = list()
	var/remove_paths = list(/mob/living/simple_mob/animal/passive/pokemon/leg, //These are removed from the final list of types
						    /mob/living/simple_mob/animal/passive/pokemon,
						    /mob/living/simple_mob/animal/passive/pokemon/eevee/jolteon/bud)

//Should move this into a global list if we need it for anything else.
/obj/structure/ghost_pod/ghost_activated/pokemon/Initialize()
	. = ..()
	p_list_paths = typesof(/mob/living/simple_mob/animal/passive/pokemon) - remove_paths//Create a list of mob paths
	for (var/path in p_list_paths)//add the mobs to a list with their names referencing paths
		var/mob/living/simple_mob/animal/passive/pokemon/P = new path()
		p_list["[P.name]"] = P.type
		qdel(P)

/obj/structure/ghost_pod/ghost_activated/pokemon/attack_ghost(var/mob/observer/dead/user)
	if (p_list == list() || !p_list)
		to_chat(user, "<span class='warning'>Pod configuration error.</span>")
		return
	create_occupant(user)


/obj/structure/ghost_pod/ghost_activated/pokemon/create_occupant(var/mob/M)
	var/m_ckey = M.ckey
	var/p_choice = input(M, "What would you like to spawn in as?", "[src.name]") as null|anything in p_list
	if(!p_choice || p_choice == null)
		return
	p_choice = p_list["[p_choice]"]
	var/newname = sanitize(input(M, "Would you like to change your name or use the default one?)", "Name change") as null|text, MAX_NAME_LEN)
	var/mob/living/simple_mob/animal/passive/pokemon/P = new p_choice(get_turf(src))

	if (newname)
		P.name = newname
	if(M.mind)
		M.mind.transfer_to(P)
	if(m_ckey)
		P.ckey = m_ckey

	log_and_message_admins("used \the [src] and became \an [initial(P.name)] named [P.name].")

	to_chat(P, "<span class='notice'>You are a <b>Pokemon</b>, an artifically designed creature. Exiting the sleeve pod, your memories \
	slowly start to come back to you as your mind adapts to this new body.</span>")
	to_chat(P, "<span class='warning'>(OOC:While you may roleplay as the same pokemon each time you use this spawner, please respect \
	normal resleeving rules regarding memory. Your mind is 'scanned' upon successful crew transfer or whenever you enter cryogenic \
	storage and it's uploaded when you use this pod to spawn in. Respawning in this manner does not upload your regular character's \
	mind into this body.)</span>")

	visible_message("<span class='notice'>\the [src.name] hisses and slowly opens before \the [P.name] steps out!</span>")

	P.forceMove(get_turf(src))