local Math = {}

function Math.round(number : number, decimalPlace : number) -- x is the float that you are rounding, y is the amount of decimal places you're rounding it to (--> m)
	local r = 10^decimalPlace
	if decimalPlace ~= nil then
		return math.floor(number*r+.5)/r
	else
		return math.floor(number+.5)
	end

end

function gcd(a,b) 
	if b ~= 0 then
		return gcd(b, a % b)
	else
		return math.abs(a)
	end
end

function Math.perc(number : number, decimalPlace : number)--just converts the value into a string with a percentage, y is to determine which decimal place to round it to (optional)
	local r = 10^decimalPlace
	if decimalPlace ~= nil then
		return math.floor(number*100*r+.5)/r .. "%"
	else
		return number*100 .. "%"
	end
end


function Math.flip(odds : number) --randomly gets true or false
	return math.random(1,100000)/1000 < math.clamp(odds,0,100)
end

function Math.fact(number : number) -- gets the factorial of the number 
	local r = 1
	if math.abs(number) == number then
		for i=1,number do
			r *= i
		end
		return r
	else
		number = math.abs(number)
		for i=1,number do
			r *= i
		end
		return -r
	end
end

function Math.commaFormat(number : number) -- formats the number into commas (1622 --> 1,622, 178263.8912 --> 178,263.8912)

	local i, j, n, int, dec = tostring(number):find('([-]?)(%d+)([.]?%d*)')
	int = string.gsub(string.reverse(int),"(%d%d%d)", "%1,")
	return n .. string.gsub(string.reverse(int),"^,", "") .. dec
end

function Math.int(number : number) -- checks if number is an integer
	return math.floor(number) == number
end

function Math.random(table,decimalPlace : number) -- math.random but the second parameter is the decimal place (optional)
	if type(table) == "table" then
		if decimalPlace == nil then
			decimalPlace = 0
		end
		local r = 10^decimalPlace
		return math.random(tonumber(table[1])*r,tonumber(table[2])*r)/r
	else
		return nil
	end
end
function Math.fraction(number : number,mixed : boolean)
	local whole,number = math.modf(number)
	local a,b,c,d,e,f = 0,1,1,1,nil,nil
	local exact = false
	for i=1,10000 do
		e = a+c
		f = b+d
		if e/f < number then
			a=e
			b=f
		elseif e/f > number then
			c=e
			d=f
		else
			break
		end
	end
		exact = e/f == number
	if mixed then
		return whole.. ' '..e..'/'..f,exact
	else
		return e+(f*whole)..'/'..f,exact
	end
	
end

function Math.prime(number : number) -- if x is a prime, then it returns true, else, it returns false
	for i = 2, number^(1/2) do
		if (number % i) == 0 then
			return false
		end
	end
	return true
end

function Math.avg(table) -- gets the average of a table
	local sum = 0
	for _,v in pairs(table) do 
		sum = sum + v
	end
	return sum / #table
end

function Math.science(number : number,toggleENotation : boolean) -- turns any number into scientific (1273568172356 --> 1.273568172356 * 10^12 or 1.273568172356e12)
	if number ~= math.abs(number) then
		number = math.abs(number)
		local log = math.floor(math.log10(number))
		if toggleENotation == nil then
			return -number/(10^log).. ' * 10^'.. log
		else
			return -number/(10^log).. 'e'.. log
		end
	else
		local log = math.floor(math.log10(number))
		if toggleENotation == nil then
			return number/(10^log).. ' * 10^'.. log
		else
			return number/(10^log).. 'e'.. log
		end
	end

		
		
end

function Math.roman(number : number) -- converts integers into roman numberals (12 --> XII, 9 --> IV, 129 -->CXXIX)
	local numberMap = {
		{1000000, '_M'},
		{500000, '_D'},
		{100000, '_C'},
		{50000, '_L'},
		{10000, '_X'},
		{5000, '_V'},
		{1000, 'M'},
		{900, 'CM'},
		{500, 'D'},
		{400, 'CD'},
		{100, 'C'},
		{90, 'XC'},
		{50, 'L'},
		{40, 'XL'},
		{10, 'X'},
		{9, 'IX'},
		{5, 'V'},
		{4, 'IV'},
		{1, 'I'}

	}
	local roman = ""
	while number > 0 do
		for index,v in pairs(numberMap)do 
			local romanChar = v[2]
			local int = v[1]
			while number >= int do
				roman = roman..romanChar
				number = number - int
			end
		end
	end
	return roman
end


function Math.rscience(scientificNotation : string) -- reverses the scientific function (1.7233e3 --> 1723.3, 1.7233*10^3 --> 1723.3)
	if string.find(scientificNotation,'e') == nil then
		local strs = string.split(scientificNotation,'*')
		return tonumber(strs[1]) * 10^ tonumber(string.split(strs[2],'^')[2])
	else
		local strs = string.split(scientificNotation,'e')
		return tonumber(strs[1]) * 10^ tonumber(strs[2])
	end
end

function Math.kmbt(number : number) --formats the number into mbt format (millions, billions, trillions), (1622 --> 1.62K, 179123672163 --> 179.12B)
	local t = {'K','M','B','T','Qa','Qi','Sx','Sp','Oc','No','Dc','Udc','Ddc','Tdc'}
	if number ~= math.abs(number) then
		number = math.abs(number)
		if number < 1000 then return -number end
		local log = math.log10(number)
		return -math.floor(number/10^(math.floor(log/3)+2*math.floor(log/3))*100)/100 .. t[math.floor(log/3)]
	else
		if number < 1000 then return number end
		local log = math.log10(number)
		return math.floor(number/10^(math.floor(log/3)+2*math.floor(log/3))*100)/100 .. t[math.floor(log/3)]

	end
end
function Math.equation(axPlusBEqualsC : string) -- solves an equation in the form of mx+b=y or even x=y (x=5 --> 5, 2x+3=8 --> 2.5, 12x+612=1623 -->  84.25). This may give an error depending on equation complexity
	local nospace = axPlusBEqualsC:gsub(" ","")
	local a, b, c = nospace:match("(.+)x+(.+)=(.+)")
	if string.split(nospace,'x')[1] == '-' then a = -1 end
	if a == nil then a = string.split(nospace,'x')[1] end
	if a == '' then a = 1 end
	if b == nil then b = nospace:split('x')[2]:split('=')[1] end
	if b == '' then b = 0 end
	if c == nil then c = nospace:split('=')[2] end

	local isovar = (tonumber(c)-tonumber(b))/tonumber(a)
	return (isovar)

end

function Math.factors(number : number) 
	local f = {}

	for i = 1, number/2 do
		if number % i == 0 then 
			f[#f+1] = i
		end
	end
	f[#f+1] = number

	return f
end

function Math.time(time24 : number,toggle12Hr : boolean) -- parameter 1 is for the time 0-24, parameter 2 is if the 12 or 24 hour system is used, if set to false, the script will use the 24 hours system.
	if toggle12Hr == nil or toggle12Hr == false then
		local hours = math.floor(time24)
		local m = (time24-hours)*60
		local minutes = math.floor(m+.5)
		local seconds = math.floor((m-minutes)*60+.5)
		if hours >= 0 and hours <= 24 then
			if hours < 10 and seconds < 10 and minutes < 10 then
				return "0".. hours.. ":".. "0".. minutes.. ":".. "0".. seconds
			elseif hours < 10 and seconds < 10 then
				return "0".. hours.. ":".. minutes.. ":".. "0".. seconds
			elseif hours < 10 and minutes < 10 then
				return "0".. hours.. ":".. "0".. minutes.. ":".. seconds
			elseif seconds < 10 and minutes < 10 then
				return hours.. ":".. "0".. minutes.. ":".. "0".. seconds
			elseif seconds < 10 then
				return hours.. ":".. minutes.. ":".. "0".. seconds
			elseif minutes < 10 then
				return hours.. ":".. "0".. minutes.. ":".. seconds
			elseif hours < 10 then
				return "0".. hours.. ":".. minutes.. ":".. seconds
			end
		end
	elseif toggle12Hr == true then
		local hours = math.floor(time24)
		if hours > 12 and hours < 24 then
			hours = hours - 12
			local m = ((time24-12)-hours)*60
			local minutes = math.floor(m+.5)
			local seconds = math.floor((m-minutes)*60+.5)
			if hours < 10 and seconds < 10 and minutes < 10 then
				return "0".. hours.. ":".. "0".. minutes.. ":".. "0".. seconds.. " PM"
			elseif hours < 10 and seconds < 10 then
				return "0".. hours.. ":".. minutes.. ":".. "0".. seconds.. " PM"
			elseif hours < 10 and minutes < 10 then
				return "0".. hours.. ":".. "0".. minutes.. ":".. seconds.. " PM"
			elseif seconds < 10 and minutes < 10 then
				return hours.. ":".. "0".. minutes.. ":".. "0".. seconds.. " PM"
			elseif seconds < 10 then
				return hours.. ":".. minutes.. ":".. "0".. seconds.. " PM"
			elseif minutes < 10 then
				return hours.. ":".. "0".. minutes.. ":".. seconds.. " PM"
			elseif hours < 10 then
				return "0".. hours.. ":".. minutes.. ":".. seconds.. " PM"
			end
		elseif hours == 12 and hours < 24 then
			local m = (time24-hours)*60
			local minutes = math.floor(m+.5)
			local seconds = math.floor((m-minutes)*60+.5)
			if hours < 10 and seconds < 10 and minutes < 10 then
				return "0".. hours.. ":".. "0".. minutes.. ":".. "0".. seconds.. " PM"
			elseif hours < 10 and seconds < 10 then
				return "0".. hours.. ":".. minutes.. ":".. "0".. seconds.. " PM"
			elseif hours < 10 and minutes < 10 then
				return "0".. hours.. ":".. "0".. minutes.. ":".. seconds.. " PM"
			elseif seconds < 10 and minutes < 10 then
				return hours.. ":".. "0".. minutes.. ":".. "0".. seconds.. " PM"
			elseif seconds < 10 then
				return hours.. ":".. minutes.. ":".. "0".. seconds.. " PM"
			elseif minutes < 10 then
				return hours.. ":".. "0".. minutes.. ":".. seconds.. " PM"
			elseif hours < 10 then
				return "0".. hours.. ":".. minutes.. ":".. seconds.. " PM"
			end
		elseif hours == 24 then
			local m = ((time24-12)-hours)*60
			local minutes = math.floor(m+.5)
			local seconds = math.floor((m-minutes)*60+.5)
			if hours < 10 and seconds < 10 and minutes < 10 then
				return "0".. hours.. ":".. "0".. minutes.. ":".. "0".. seconds.. " AM"
			elseif hours < 10 and seconds < 10 then
				return "0".. hours.. ":".. minutes.. ":".. "0".. seconds.. " AM"
			elseif hours < 10 and minutes < 10 then
				return "0".. hours.. ":".. "0".. minutes.. ":".. seconds.. " AM"
			elseif seconds < 10 and minutes < 10 then
				return hours.. ":".. "0".. minutes.. ":".. "0".. seconds.. " AM"
			elseif seconds < 10 then
				return hours.. ":".. minutes.. ":".. "0".. seconds.. " AM"
			elseif minutes < 10 then
				return hours.. ":".. "0".. minutes.. ":".. seconds.. " AM"
			elseif hours < 10 then
				return "0".. hours.. ":".. minutes.. ":".. seconds.. " AM"
			end
		elseif hours < 24 and hours > 0 then
			local m = (time24-hours)*60
			local minutes = math.floor(m+.5)
			local seconds = math.floor((m-minutes)*60+.5)
			if hours < 10 and seconds < 10 and minutes < 10 then
				return "0".. hours.. ":".. "0".. minutes.. ":".. "0".. seconds.. " AM"
			elseif hours < 10 and seconds < 10 then
				return "0".. hours.. ":".. minutes.. ":".. "0".. seconds.. " AM"
			elseif hours < 10 and minutes < 10 then
				return "0".. hours.. ":".. "0".. minutes.. ":".. seconds.. " AM"
			elseif seconds < 10 and minutes < 10 then
				return hours.. ":".. "0".. minutes.. ":".. "0".. seconds.. " AM"
			elseif seconds < 10 then
				return hours.. ":".. minutes.. ":".. "0".. seconds.. " AM"
			elseif minutes < 10 then
				return hours.. ":".. "0".. minutes.. ":".. seconds.. " AM"
			elseif hours < 10 then
				return "0".. hours.. ":".. minutes.. ":".. seconds.. " AM"
			end
		elseif hours == 0 then
			hours = 12
			local m = ((time24)-hours)*60
			local minutes = math.floor(m+.5)
			local seconds = math.floor((m-minutes)*60+.5)
			if hours < 10 and seconds < 10 and minutes < 10 then
				return "0".. hours.. ":".. "0".. minutes.. ":".. "0".. seconds.. " AM"
			elseif hours < 10 and seconds < 10 then
				return "0".. hours.. ":".. minutes.. ":".. "0".. seconds.. " AM"
			elseif hours < 10 and minutes < 10 then
				return "0".. hours.. ":".. "0".. minutes.. ":".. seconds.. " AM"
			elseif seconds < 10 and minutes < 10 then
				return hours.. ":".. "0".. minutes.. ":".. "0".. seconds.. " AM"
			elseif seconds < 10 then
				return hours.. ":".. minutes.. ":".. "0".. seconds.. " AM"
			elseif minutes < 10 then
				return hours.. ":".. "0".. minutes.. ":".. seconds.. " AM"
			elseif hours < 10 then
				return "0".. hours.. ":".. minutes.. ":".. seconds.. " AM"
			end
		end
	end
end

--Useless Math
function Math.integral(p,l,u,f)
	local s = 0
	local n = false
	if u < 0 then
		n = true
		u=math.abs(u)
	end
	for i=l,u,p do
		s += f(i)*p
	end
	if n then return -s else return s end
end

function Math.quadsolve(a,b,c)
	local disc = b^2-4*a*c
	local root
	local perfectroot = false
	local negative = disc < 0
	if not negative then
		for i,v in pairs(Math.factors(disc)) do
			if v^.5 == math.floor(v^.5) then
				root = v
				if v == disc then
					perfectroot = true
				end
			end
		end
		if -b == 0 then
			if perfectroot then
				return '+'..disc^.5/2*a .. '','-'..disc^.5/2*a.. ''
			elseif root^.5 == 2*a then
				return '+'..'\\sqrt{'..disc/root..'}','-'..'\\sqrt{'..disc/root..'}'
			elseif root == 1 then
				a=''
				return '+'..'\\frac{\\sqrt{'..disc..'}}{'..2*a..'}','-'..'\\frac{\\sqrt{'..disc..'}}{'..2*a..'}'
			else
				return '+'..'\\frac{\\sqrt{'..disc..'}}{'..2*a..'}','-'..'\\frac{\\sqrt{'..disc..'}}{'..2*a..'}'
			end
		else
			if perfectroot then
				return -b/2*a +(disc^.5/2*a),-b/2*a -(disc^.5/2*a)
			elseif root == 1 then
				return '\\frac{'..-b..'+'..'\\sqrt{'..disc..'}}{'..2*a..'}','\\frac{'..-b..'-'..'\\sqrt{'..disc..'}}{'..2*a..'}'
			elseif root^.5 == 2*a then
				return -b/root^.5 ..'+'..'\\sqrt{'..disc/root..'}',-b/root^.5 ..'-'..'\\sqrt{'..disc/root..'}'
			else
				return '\\frac{'..-b..'+'..'\\sqrt{'..disc..'}}{'..2*a..'}','\\frac{'..-b..'+'..'\\sqrt{'..disc..'}}{'..2*a..'}'
			end
		end

	else
		for i,v in pairs(Math.factors(math.abs(disc))) do
			if v^.5 == math.floor(v^.5) then
				root = v
				if v == math.abs(disc) then
					perfectroot = true
				end
			end
		end
		disc = math.abs(disc)
		if -b == 0 then
			if root == 1 then
				a=''
				return '+'..'\\frac{\\sqrt{'..disc..'}i}{'..2*a..'}','-'..'\\frac{\\sqrt{'..disc..'}i}{'..2*a..'}'
			elseif root^.5 == 2*a then
				return '+'..'\\sqrt{'..disc/root..'}i','-'..'\\sqrt{'..disc/root..'}i'
			elseif perfectroot then
				return '+'..disc^.5/2*a .. 'i','-'..disc^.5/2*a.. 'i'
			else
				return '+'..'\\frac{\\sqrt{'..disc..'}i}{2'..a..'}','-'..'\\frac{\\sqrt{'..disc..'}i}{2'..a..'}'
			end
		else

			if root == 1 then
				a=1
				return '\\frac{'..-b..'+'..'\\sqrt{'..disc..'}i}{'..2*a..'}','\\frac{'..-b..'-'..'\\sqrt{'..disc..'}i}{'..2*a..'}'
			elseif root^.5 == 2*a then
				return -b/root^.5 ..'+'..'\\sqrt{'..disc/root..'}i', -b/root^.5 ..'-'..'\\sqrt{'..disc/root..'}i'
			elseif perfectroot then
				return -b/2*a ..'+'..disc^.5/2*a .. 'i',-b/2*a ..'-'..disc^.5/2*a.. 'i'
			else
				return '\\frac{'..-b..'+'..'\\sqrt{'..disc..'}i}{'..2*a..'}','\\frac{'..-b..'-'..'\\sqrt{'..disc..'}i}{'..2*a..'}'
			end
		end

	end
end
function Math.derivative(precision,point,func)
	return (func(point+precision)-func(point))/precision
end
function Math.summation(start,finish,f)
	local sum = 0
	for i=start,finish do
		sum += f(i)
	end
	return sum
end
function Math.product(start,finish,f)
	local sum = 0
	for i=start,finish do
		sum *= f(i)
	end
	return sum
end

function Math.limit(lim,func)
	return math.floor(func(lim+1e-13)*10^12)/10^12
end

--Consants
Math.e = 2.718281828459045235360287471352662497757247093699959574966967627724076630353547594571382178525166427427466391932003059921817413596629043572900334295260595630738132328627943490763233829880753195251019011573834187930702154089149934884167509244761460668082264800168477411853742345442437107539077744992069551702761838606261331384583000752044933826560297606737113200709328709127443747047230696977209310
Math.phi = (1+5^.5)/2

--Useless Ones
Math.pi = 3.14159265358979323846264338327950288419716939937510582097494459230781640628620899862803482534211706798214808651328230664709384460955058223172535940812848111745028410270193852110555 --162 digits of pi(doesnt mean anything since lua rounds to the nearest 13th digit, its just a flex)
Math.tau = 3.14159265358979323846264338327950288419716939937510582097494459230781640628620899862803482534211706798214808651328230664709384460955058223172535940812848111745028410270193852110555*2 -- *2 (crazy)
return Math

--hi :D
