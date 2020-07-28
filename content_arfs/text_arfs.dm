//bayport

/proc/generateRandomString(var/length)
	. = list()
	for(var/a in 1 to length)
		var/letter = rand(33,126)
		. += ascii2text(letter)
	. = jointext(.,null)
