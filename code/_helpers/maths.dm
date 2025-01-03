// min is inclusive, max is exclusive
/proc/Wrap(val, min, max)
	var/d = max - min
	var/t = FLOOR((val - min) / d)
	return val - (t * d)

/proc/Default(a, b)
	return a ? a : b

// Trigonometric functions.
/proc/Tan(x)
	return sin(x) / cos(x)

/proc/Csc(x)
	return 1 / sin(x)

/proc/Sec(x)
	return 1 / cos(x)

/proc/Cot(x)
	return 1 / Tan(x)

/proc/Atan2(x, y)
	if(!x && !y) return 0
	var/a = arccos(x / sqrt(x*x + y*y))
	return y >= 0 ? a : -a

// Greatest Common Divisor: Euclid's algorithm.
/proc/Gcd(a, b)
	while (1)
		if (!b) return a
		a %= b
		if (!a) return b
		b %= a

// Least Common Multiple. The formula is a consequence of: a*b = LCM*GCD.
/proc/Lcm(a, b)
	return abs(a) * abs(b) / Gcd(a, b)

// Useful in the cases when x is a large expression, e.g. x = 3a/2 + b^2 + Function(c)
/proc/Square(x)
	return x*x

/proc/Inverse(x)
	return 1 / x

// Condition checks.
/proc/IsAboutEqual(a, b, delta = 0.1)
	return abs(a - b) <= delta

// Returns true if val is from min to max, inclusive.
/proc/IsInRange(val, min, max)
	return (val >= min) && (val <= max)

/proc/IsInteger(x)
	return FLOOR(x) == x

/proc/IsMultiple(x, y)
	return x % y == 0

/proc/IsEven(x)
	return !(x & 0x1)

/proc/IsOdd(x)
	return  (x & 0x1)

// Performs a linear interpolation between a and b.
// Note: weight=0 returns a, weight=1 returns b, and weight=0.5 returns the mean of a and b.
/proc/Interpolate(a, b, weight = 0.5)
	return a + (b - a) * weight // Equivalent to: a*(1 - weight) + b*weight

/proc/Mean(...)
	var/sum = 0
	for(var/val in args)
		sum += val
	return sum / args.len

// Returns the nth root of x.
/proc/Root(n, x)
	return x ** (1 / n)

// The quadratic formula. Returns a list with the solutions, or an empty list
// if they are imaginary.
/proc/SolveQuadratic(a, b, c)
	ASSERT(a)

	. = list()
	var/discriminant = b*b - 4*a*c
	var/bottom       = 2*a

	// Return if the roots are imaginary.
	if(discriminant < 0)
		return

	var/root = sqrt(discriminant)
	. += (-b + root) / bottom

	// If discriminant == 0, there would be two roots at the same position.
	if(discriminant != 0)
		. += (-b - root) / bottom

/proc/ToDegrees(radians)
	// 180 / Pi ~ 57.2957795
	return radians * 57.2957795

/proc/ToRadians(degrees)
	// Pi / 180 ~ 0.0174532925
	return degrees * 0.0174532925

// Vector algebra.
/proc/squaredNorm(x, y)
	return x*x + y*y

/proc/norm(x, y)
	return sqrt(squaredNorm(x, y))

/proc/IsPowerOfTwo(var/val)
	return (val & (val-1)) == 0

/proc/RoundUpToPowerOfTwo(var/val)
	return 2 ** -round(-log(2,val))

/matrix/proc/get_angle()
	return Atan2(b,a)

/datum/vector2
	var/x
	var/y

/datum/vector2/New(var/_x=0, var/_y=0)
	x = _x
	y = _y

/datum/vector2/proc/get_angle()
	return Atan2(x, y)

/datum/vector2/proc/summ(var/datum/vector2/v)
	x = x + v.x
	y = y + v.y

/datum/vector2/proc/sub(var/datum/vector2/v)
	x = x - v.x
	y = y - v.y

/datum/vector2/proc/mult(var/datum/vector2/v)
	x = x * v.x
	y = y * v.y

/datum/vector2/proc/lerp(var/target, var/weight)
	x = Interpolate(x, target, weight)
	y = Interpolate(y, target, weight)

/datum/vector2/proc/get_hipotynuse()
	return sqrt(x*x + y*y)

/datum/vector2/proc/normalise()
	var/hip = get_hipotynuse()
	x = x / hip
	y = y / hip

/datum/vector2/proc/from_angle(var/degrees)
	x = round(cos(degrees), 0.001)
	y = round(sin(degrees), 0.001)

/datum/vector2/proc/copy()
	return new /datum/vector2(x, y)

/datum/vector3
	var/x
	var/y
	var/z

/datum/vector3/New(var/_x=0, var/_y=0, var/_z=0)
	x = _x
	y = _y
	z = _z

/datum/vector3/proc/get_angle()
	return Atan2(x, y) // я хуй знает

/datum/vector3/proc/summ(var/datum/vector3/v)
	x = x + v.x
	y = y + v.y
	z = z + v.z

/datum/vector3/proc/sub(var/datum/vector3/v)
	x = x - v.x
	y = y - v.y
	z = z - v.z

/datum/vector3/proc/mult(var/datum/vector3/v)
	x = x * v.x
	y = y * v.y
	z = z * v.z

/datum/vector3/proc/lerp(var/target, var/weight)
	x = Interpolate(x, target, weight)
	y = Interpolate(y, target, weight)
	z = Interpolate(z, target, weight)

/datum/vector3/proc/get_hipotynuse()
	return sqrt(x*x + y*y + z*z)

/datum/vector3/proc/normalise()
	var/hip = get_hipotynuse()
	x = x / hip
	y = y / hip
	z = z / hip

/datum/vector3/proc/from_angle(var/degrees)
	x = round(cos(degrees), 0.001)
	y = round(sin(degrees), 0.001)	// тоже хуй знает

/datum/vector3/proc/copy()
	return new /datum/vector3(x, y, z)