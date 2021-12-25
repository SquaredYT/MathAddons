local Math = {}

function Math.round(x,y) -- x is the float that you are rounding, y is the amount of decimal places you're rounding it to (--> m)
	local r = 10^y
	if y ~= nil then
		return math.floor(x*r+.5)/r
	else
		return math.floor(x+.5)
	end

end

function gcd(a,b) 
	if b ~= 0 then
		return gcd(b, a % b)
	else
		return math.abs(a)
	end
end

function Math.perc(x,y)--just converts the value into a string with a percentage, y is to determine which decimal place to round it to (optional)
	local r = 10^y
	if y ~= nil then
		return math.floor(x*100*r+.5)/r .. "%"
	else
		return x*100 .. "%"
	end
end


function Math.flip() --randomly gets true or false
	return math.random(1,2) == 1
end

function Math.fact(x) -- gets the factorial of the number 
	local r = 1
	if math.abs(x) == x then
		for i=1,x do
			r = r*x
		end
		return r
	else
		x = math.abs(x)
		for i=1,x do
			r = r*x
		end
		return -r
	end
end

function Math.commaFormat(x) -- formats the number into commas (1622 --> 1,622, 178263.8912 --> 178,263.8912)
	local decimal = nil
	if math.floor(x) ~= x then
		decimal = string.split(tostring(x),'.')[2]
		x = math.floor(x)
	end
	local digits = string.split(tostring(x),'')
	local newS = ''
	local leftOver = #tostring(x)%3
	for i,v in pairs(digits) do
		if i%3 == #tostring(x)%3 and #digits > 3 then
			if i ~= #tostring(x) then
				newS = newS.. v.. ','
			else
				newS = newS.. v
			end

		else
			newS = newS.. v
		end
	end
	if decimal == nil then
		return newS
	else
		return (newS.. '.'.. decimal)
	end
	
end

function Math.int(x) -- checks if number is an integer
	return math.floor(x) == x
end

function Math.sqrt(x) -- Just a square root
return x^.5
end

function Math.random(x,d) -- math.random but the second parameter is the decimal place (optional)
	if type(x) == "table" then
		if d == nil then
			d = 0
		end
		local r = 10^d
		return math.random(tonumber(x[1])*r,tonumber(x[2])*r)/r
	else
		return nil
	end
end
function Math.fraction(x) --converts a decimal to a fraction (dont go to heavy on this with long decimals, it goes through a for loop)
		local ret
		for i=10,math.huge,10 do
			if i/10 == math.floor(i/10) then

				if (i*x) == math.floor(i*x) then
					local gcf = gcd(i,i*x)
					if math.floor(((i*x)/gcf)/(i/gcf)) == x then
						ret = ((i*x)/gcf)/(i/gcf)
					elseif (i*x)/gcf > i/gcf then
						local whole = math.floor(((i*x)/gcf)/(i/gcf))
						local subt = math.floor(whole*(i/gcf))
						ret = whole.. " ".. (((i*x)/gcf))-subt.. "/".. i/gcf
					elseif (i*x)/gcf < i/gcf then
						ret = (i*x)/gcf.. "/".. i/gcf
					end
					break
				end
			end
		end
		return ret
	end

function Math.prime(x) -- if x is a prime, then it returns true, else, it returns false
	for i = 2, x^(1/2) do
		if (x % i) == 0 then
			return false
		end
	end
	return true
end

function Math.avg(x) -- gets the average of a table
	local sum = 0
	for _,v in pairs(x) do 
		sum = sum + v
	end
	return sum / #x
end

function Math.science(x,bool) -- turns any number into scientific (1273568172356 --> 1.273568172356 * 10^12 or 1.273568172356e12)
	local log = math.floor(math.log10(x))
	if bool == nil then
		return x/(10^log).. ' * 10^'.. log
	else
		return x/(10^log).. 'e'.. log
	end
		
		
end

function Math.roman(num) -- converts integers into roman numberals (12 --> XII, 9 --> IV, 129 -->CXXIX)
	local numberMap = {
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
	while num > 0 do
		for index,v in pairs(numberMap)do 
			local romanChar = v[2]
			local int = v[1]
			while num >= int do
				roman = roman..romanChar
				num = num - int
			end
		end
	end
	return roman
end


function Math.rscience(x) -- the reverse of the scientific function (1.7233e3 --> 1723.3, 1.7233*10^3 --> 1723.3)
	if string.find(x,'e') == nil then
		local strs = string.split(x,'*')
		return tonumber(strs[1]) * 10^ tonumber(string.split(strs[2],'^')[2])
	else
		local strs = string.split(x,'e')
		return tonumber(strs[1]) * 10^ tonumber(strs[2])
	end
end

function Math.kmbt(x) --formats the number into mbt format (millions, billions, trillions), (1622 --> 1.62K, 179123672163 --> 179.12B)
	local t = {'K','M','B','T','Qa','Qi','Sx','Sp','Oc','No','Dc','Udc','Ddc','Tdc'}
	if x < 1000 then return x end
	local log = math.log10(x)
	return math.floor(x/10^(math.floor(log/3)+2*math.floor(log/3))*100)/100 .. t[math.floor(log/3)]
end
function Math.equation(equ) -- solves an equation in the form of mx+b=y or even x=y (x=5 --> 5, 2x+3=8 --> 2.5, 12x+612=1623 -->  84.25). This may give an error depending on equation complexity
	local Str = equ
	local nospace = Str:gsub(" ","")
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

function Math.time(x,y) -- parameter 1 is for the time 0-24, parameter 2 is if the 12 or 24 hour system is used, if set to false, the script will use the 24 hours system.
	if y == nil or y == false then
		local hours = math.floor(x)
		local m = (x-hours)*60
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
	elseif y == true then
		local hours = math.floor(x)
		if hours > 12 and hours < 24 then
			hours = hours - 12
			local m = ((x-12)-hours)*60
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
			local m = (x-hours)*60
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
			local m = ((x-12)-hours)*60
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
			local m = (x-hours)*60
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
			local m = ((x)-hours)*60
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
return Math

--hi :D
