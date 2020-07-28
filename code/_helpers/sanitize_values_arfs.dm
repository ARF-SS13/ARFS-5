//from bay. Arfs addition. Sanitizes circuitry input.

/proc/is_valid_index(input, list/given_list)
	if(!isnum(input))
		return FALSE
	if(input != round(input))
		return FALSE
	if(input < 1 || input > length(given_list))
		return FALSE
	return TRUE
