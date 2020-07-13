//Pokemon!

#define P_TYPE_FIRE 	"fire"
#define P_TYPE_WATER 	"water"
#define P_TYPE_ICE 		"ice"
#define P_TYPE_FLY 		"flying"
#define P_TYPE_PSYCH 	"psychic"
#define P_TYPE_NORM 	"normal"
#define P_TYPE_DARK 	"dark"

/mob/living/simple_mob/animal/passive/pokemon
	name = "eevee"
	icon_state = "eevee"
	icon_living = "eevee"
	icon_dead = "eevee_d"
	icon_rest = ""
	desc = "Gotta catch 'em all!"
	icon = 'content_arfs/icons/mob/mobs/pokemon.dmi'
	pixel_x = -16
	default_pixel_x = -16
	health = 100
	maxHealth = 100
	response_help = "pets"
	layer = MOB_LAYER
	vore_active = 0
	has_hands = 0
	movement_cooldown = 2
	meat_amount = 3
	makes_dirt = 0
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	melee_damage_lower = 3
	melee_damage_upper = 9
	var/list/p_types = list()

/mob/living/simple_mob/animal/passive/pokemon/Life()
	if(resting && stat < DEAD && health < maxHealth)
		var/heal_amt = rand(1,3)
		adjustBruteLoss(-heal_amt)
		adjustOxyLoss(-heal_amt)
		adjustFireLoss(-heal_amt)
		if(health > maxHealth)
			health = maxHealth
	. = ..()

/mob/living/simple_mob/animal/passive/pokemon/proc/simple_lay_down()
	set name = "Rest"
	set category = "IC"
	set desc = "Lie down and rest in order to slowly heal or just relax."
	resting = !resting
	to_chat(src,"<span class='notice'>You are now [resting ? "resting" : "getting up"].</span>")
	if(resting && health < maxHealth)
		to_chat(src,"<span class='green'>You feel your wounds mending as you rest.</span>")
	update_canmove()
	update_icon()

/mob/living/simple_mob/animal/passive/pokemon/update_icon()
	. = ..()
	pixel_x = default_pixel_x //If they're somehow reset out of their offset, this will correct them. (grabs do this)

/mob/living/simple_mob/animal/passive/pokemon/Initialize()
	. = ..()
	verbs += /mob/living/simple_mob/animal/passive/pokemon/proc/simple_lay_down
	icon_rest = "[icon_state]_rest"
	tt_desc = "[initial(icon_state)]"//Icon state > name
	init_vore()
	default_language = GLOB.all_languages[LANGUAGE_GALCOM]
	add_language(LANGUAGE_POKEMON)
	mob_radio = new
	if(p_types.len)
		for(var/T in p_types)
			give_moves(T)

/mob/living/simple_mob/animal/passive/pokemon/proc/give_moves(var/typetogive)
	if(!typetogive)
		return FALSE
	switch(typetogive)
		if(P_TYPE_ICE)
			minbodytemp = 100
			heat_damage_per_tick = 6
		if(P_TYPE_FIRE)
			maxbodytemp = 1000
			cold_damage_per_tick = 6
		else
			return FALSE

/*
/mob/living/simple_mob/animal/passive/pokemon/handle_message_mode(message_mode, message, verb, speaking, used_radios, alt_name)
	if(mob_radio)
		switch(message_mode)
			if("intercom")
				for(var/obj/item/device/radio/intercom/I in view(1, null))
					I.talk_into(src, message, verb, speaking)
//					used_radios += I
			if("headset")
				if(mob_radio && istype(mob_radio,/obj/item/device/radio/headset/mob_headset))
					mob_radio.talk_into(src,message,null,verb,speaking)
//					used_radios += mob_radio
			else
				if(message_mode)
					if(mob_radio && istype(mob_radio,/obj/item/device/radio/headset/mob_headset))
						mob_radio.talk_into(src,message, message_mode, verb, speaking)
//						used_radios += mob_radio
	else
		..()
*/


/*
/////TEMPLATE/////

/mob/living/simple_mob/animal/passive/pokemon/
	name = ""
	icon_state = ""
	icon_living = ""
	icon_dead = ""
*/

/mob/living/simple_mob/animal/passive/pokemon/leg
	icon = 'content_arfs/icons/mob/mobs/legendary.dmi'
	pixel_x = -32
	default_pixel_x = -32
	health = 200
	maxHealth = 200
	meat_amount = 6

/mob/living/simple_mob/animal/passive/pokemon/leg/articuno
	name = "Articuno"
	icon_state = "articuno"
	icon_living = "articuno"
	icon_dead = "articuno_d"
	p_types = list(P_TYPE_ICE, P_TYPE_FLY)

/mob/living/simple_mob/animal/passive/pokemon/leg/rayquaza
	name = "Rayquaza"
	icon_state = "rayquaza"
	icon_living = "rayquaza"
	icon_dead = "rayquaza_d"
	p_types = list(P_TYPE_FLY)

//ALPHABETICAL PLEASE

/mob/living/simple_mob/animal/passive/pokemon/absol
	name = "absol"
	icon_state = "absol"
	icon_living = "absol"
	icon_dead = "absol_d"

/mob/living/simple_mob/animal/passive/pokemon/aggron
	name = "aggron"
	icon_state = "aggron"
	icon_living = "aggron"
	icon_dead = "aggron_d"

/mob/living/simple_mob/animal/passive/pokemon/ampharos
	name = "ampharos"
	icon_state = "ampharos"
	icon_living = "ampharos"
	icon_dead = "ampharos_d"

/mob/living/simple_mob/animal/passive/pokemon/charmander
	name = "charmander"
	icon_state = "charmander"
	icon_living = "charmander"
	icon_dead = "charmander_d"

/mob/living/simple_mob/animal/passive/pokemon/ditto
	name = "ditto"
	icon_state = "ditto"
	icon_living = "ditto"
	icon_dead = "ditto_d"

/mob/living/simple_mob/animal/passive/pokemon/dratini/dragonair
	name = "dragonair"
	desc = "A Dragonair stores an enormous amount of energy inside its body. It is said to alter the weather around it by loosing energy from the crystals on its neck and tail."
	icon_state = "dragonair"
	icon_living = "dragonair"
	icon_dead = "dragonair_d"

/mob/living/simple_mob/animal/passive/pokemon/dratini/dragonair/dragonite
	name = "dragonite"
	desc = "It can circle the globe in just 16 hours. It is a kindhearted Pokémon that leads lost and foundering ships in a storm to the safety of land."
	icon_state = "dragonite"
	icon_living = "dragonite"
	icon_dead = "dragonite_d"

/mob/living/simple_mob/animal/passive/pokemon/dratini
	name = "dratini"
	desc = "A Dratini continually molts and sloughs off its old skin. It does so because the life energy within its body steadily builds to reach uncontrollable levels."
	icon_state = "dratini"
	icon_living = "dratini"
	icon_dead = "dratini_d"

/mob/living/simple_mob/animal/passive/pokemon/eevee
	name = "eevee"
	desc = "Eevee has an unstable genetic makeup that suddenly mutates due to its environment. Radiation from various stones causes this Pokémon to evolve."
	icon_state = "eevee"
	icon_living = "eevee"
	icon_dead = "eevee_d"
	response_help  = "pets"
	response_harm   = "hits"

/mob/living/simple_mob/animal/passive/pokemon/eevee/espeon
	name = "espeon"
	desc = "Espeon is extremely loyal to any trainer it considers to be worthy. It is said to have developed precognitive powers to protect its trainer from harm."
	icon_state = "espeon"
	icon_living = "espeon"
	icon_dead = "espeon_d"

/mob/living/simple_mob/animal/passive/pokemon/flaaffy
	name = "flaaffy"
	icon_state = "flaaffy"
	icon_living = "flaaffy"
	icon_dead = "flaaffy_d"

/mob/living/simple_mob/animal/passive/pokemon/eevee/flareon
	name = "flareon"
	desc = "Flareon's fluffy fur releases heat into the air so that its body does not get excessively hot. Its body temperature can rise to a maximum of 1,650 degrees F."
	icon_state = "flareon"
	icon_living = "flareon"
	icon_dead = "flareon_d"

/mob/living/simple_mob/animal/passive/pokemon/eevee/glaceon
	name = "glaceon"
	desc = "By controlling its body heat, it can freeze the atmosphere around it to make a diamond-dust flurry."
	icon_state = "glaceon"
	icon_living = "glaceon"
	icon_dead = "glaceon_d"
	p_types = list(P_TYPE_ICE)

/mob/living/simple_mob/animal/passive/pokemon/eevee/jolteon
	name = "jolteon"
	desc = "Its cells generate weak power that is amplified by its fur's static electricity to drop thunderbolts. The bristling fur is made of electrically charged needles."
	icon_state = "jolteon"
	icon_living = "jolteon"
	icon_dead = "jolteon_d"
	var/charge_cooldown_time = 100
	var/charge_cooldown = 0


/mob/living/simple_mob/animal/passive/pokemon/eevee/jolteon/attack_hand(mob/user)
	..()
	if(!stat)
		electrocute_mob(user, get_area(src), src, 1)

/mob/living/simple_mob/animal/passive/pokemon/eevee/jolteon/attackby(obj/item/weapon/W, mob/user, params)
	electrocute_mob(user, get_area(src), src, W.siemens_coefficient)
	if(!stat && istype(W, /obj/item/weapon/cell))
		var/obj/item/weapon/cell/C = W
		if(charge_cooldown)
			to_chat(user,"<span class='red'>\the [src.name] is recharging!</span>")
			return
		if(C.charge == C.maxcharge)
			to_chat(user,"<span class='red'>[C] is already fully charged!</span>")
			return
		electrocute_mob(user, get_area(src), src, W.siemens_coefficient)
		to_chat(user,"<span class='green'>You charge [C] using [src].</span>")
		var/chargetogive = rand(50,250)
		C.give(chargetogive)
		C.update_icon()
		charge_cooldown = 1
		spawn(charge_cooldown_time)
			charge_cooldown = 0
		return
	..()

/mob/living/simple_mob/animal/passive/pokemon/eevee/jolteon/bud
	name = "Bud"

/mob/living/simple_mob/animal/passive/pokemon/larvitar
	name = "larvitar"
	desc = "It is born deep underground. It can't emerge until it has entirely consumed the soil around it."
	icon = 'content_arfs/icons/mob/mobs/pokemon.dmi'
	icon_state = "larvitar"
	icon_living = "larvitar"
	icon_dead = "larvitar_d"

/mob/living/simple_mob/animal/passive/pokemon/growlithe
	name = "growlithe"
	icon_state = "growlithe"
	icon_living = "growlithe"
	icon_dead = "growlithe_d"

/mob/living/simple_mob/animal/passive/pokemon/mareep
	name = "mareep"
	icon_state = "mareep"
	icon_living = "mareep"
	icon_dead = "mareep_d"

/mob/living/simple_mob/animal/passive/pokemon/poochyena/mightyena
	name = "mightyena"
	icon_state = "mightyena"
	icon_living = "mightyena"
	icon_dead = "mightyena"

/mob/living/simple_mob/animal/passive/pokemon/miltank
	name = "miltank"
	icon_state = "miltank"
	icon_living = "miltank"
	icon_dead = "miltank_d"
	var/datum/reagents/udder = null

/mob/living/simple_mob/animal/passive/pokemon/miltank/New()
	udder = new(50)
	udder.my_atom = src
	..()

/mob/living/simple_mob/animal/passive/pokemon/miltank/Life()
	. = ..()
	if(stat == CONSCIOUS)
		if(udder && prob(5))
			udder.add_reagent("milk", rand(5, 10))

/mob/living/simple_mob/animal/passive/pokemon/miltank/attackby(var/obj/item/O as obj, var/mob/user as mob)
	var/obj/item/weapon/reagent_containers/glass/G = O
	if(stat == CONSCIOUS && istype(G) && G.is_open_container())
		user.visible_message("<span class='notice'>[user] milks [src] using \the [O].</span>")
		var/transfered = udder.trans_id_to(G, "milk", rand(5,10))
		if(G.reagents.total_volume >= G.volume)
			user << "<font color='red'> The udder is dry. Wait a bit longer... </font>"
		if(!transfered)
			user << "<font color='red'> The udder is dry. Wait a bit longer... </font>"
		..()

/mob/living/simple_mob/animal/passive/pokemon/poochyena
	name = "poochyena"
	icon_state = "poochyena"
	icon_living = "poochyena"
	icon_dead = "poochyena_d"

/mob/living/simple_mob/animal/passive/pokemon/eevee/sylveon
	name = "sylveon"
	desc = "Sylveon, the Intertwining Pokémon. Sylveon affectionately wraps its ribbon-like feelers around its Trainer's arm as they walk together."
	icon_state = "sylveon"
	icon_living = "sylveon"
	icon_dead = "sylveon_d"
	response_help  = "pets"
	response_harm   = "hits"

/mob/living/simple_mob/animal/passive/pokemon/eevee/umbreon
	name = "umbreon"
	icon_state = "umbreon"
	icon_dead = "umbreon_d"
	icon_living = "umbreon"

/mob/living/simple_mob/animal/passive/pokemon/vulpix
	name = "vulpix"
	icon_state = "vulpix"
	icon_living = "vulpix"
	icon_dead = "vulpix_d"

/mob/living/simple_mob/animal/passive/pokemon/tentacruel
	name = "tentacruel"
	icon_state = "tentacruel"
	icon_living = "tentacruel"
	icon_dead = "tentacruel_d"

/mob/living/simple_mob/animal/passive/pokemon/ninetales
	name = "ninetales"
	icon_state = "ninetales"
	icon_living = "ninetales"
	icon_dead = "ninetales_d"

/mob/living/simple_mob/animal/passive/pokemon/ponyta
	name = "ponyta"
	icon_state = "ponyta"
	icon_living = "ponyta"
	icon_dead = "ponyta_d"

/mob/living/simple_mob/animal/passive/pokemon/zubat
	name = "zubat"
	icon_state = "zubat"
	icon_living = "zubat"
	icon_dead = "zubat_d"
	desc = "Even though it has no eyes, it can sense obstacles using ultrasonic waves it emits from its mouth."
//	speak = list("Zubat!", "Zu Zu!")

/mob/living/simple_mob/animal/passive/pokemon/tangela
	name = "tangela"
	icon_state = "tangela"
	icon_living = "tangela"
	icon_dead = "tangela_d"

/mob/living/simple_mob/animal/passive/pokemon/pincer
	name = "pincher"
	icon_state = "pincher"
	icon_living = "pincher"
	icon_dead = "pincher_d"

/mob/living/simple_mob/animal/passive/pokemon/omanyte
	name = "omanyte"
	icon_state = "omanyte"
	icon_living = "omanyte"
	icon_dead = "omanyte_d"

/mob/living/simple_mob/animal/passive/pokemon/magamar
	name = "magamar"
	icon_state = "magamar"
	icon_living = "magamar"
	icon_dead = "magamar_d"

/mob/living/simple_mob/animal/passive/pokemon/magicarp
	name = "magicarp"
	icon_state = "magicarp"
	icon_living = "magicarp"
	icon_dead = "magicarp_d"

/mob/living/simple_mob/animal/passive/pokemon/lapras
	name = "lapras"
	icon_state = "lapras"
	icon_living = "lapras"
	icon_dead = "lapras_d"

/mob/living/simple_mob/animal/passive/pokemon/kabuto
	name = "kabuto"
	icon_state = "Kabuto"
	icon_living = "Kabuto"
	icon_dead = "Kabuto_d"


/mob/living/simple_mob/animal/passive/pokemon/aerodactyl
	name = "aerodactyl"
	icon_state = "Aerodactyl"
	icon_living = "Aerodactyl"
	icon_dead = "Aerodactyl_d"

/mob/living/simple_mob/animal/passive/pokemon/lickitung
	name = "lickitung"
	icon_state = "lickitung"
	icon_living = "lickitung"
	icon_dead = "lickitung_d"

/mob/living/simple_mob/animal/passive/pokemon/cubone
	name = "cubone"
	icon_state = "cubone"
	icon_living = "cubone"
	icon_dead = "cubone_d"

/mob/living/simple_mob/animal/passive/pokemon/mewtwo
	name = "mewtwo"
	icon_state = "mewtwo"
	icon_living = "mewtwo"
	icon_dead = "mewtwo_d"

/mob/living/simple_mob/animal/passive/pokemon/snorlax
	name = "snorlax"
	icon_state = "snorlax"
	icon_living = "snorlax"
	icon_dead = "snorlax_d"
