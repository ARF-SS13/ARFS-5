//from bay wth circuitry, arfs change

#define ceil(x) (-round(-(x)))

/proc/ToDegrees(radians)
	// 180 / Pi ~ 57.2957795
	return radians * 57.2957795

/proc/ToRadians(degrees)
	// Pi / 180 ~ 0.0174532925
	return degrees * 0.0174532925
