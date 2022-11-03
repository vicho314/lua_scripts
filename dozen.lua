--float -> aprox. 7 digits
function strfdec(x,precision)
	local base=12
	local dec=7
	local minus=""
	if x<0 then
		minus="-"
	end 
	x=math.abs(x)
	local frac=x-math.floor(x)
	local frac_str=""
	x=math.floor(x)
	if frac>0 then
		if(precision) then
			dec=precision
		end
		frac=math.floor(frac*(12^dec)+0.5)
		frac_str="." .. strfdec(frac)
	end
	if (x<10) then
		return minus..(tostring(x)..frac_str)
	end
	if (x==10) then
		return minus.."X"
	end
	if(x==11) then
		return minus.."E"
	end
	local digit={}
	while(x>0) do
		digit[#digit+1] = strfdec(x%12)
		x=math.floor(x/12)
	end
	return (minus..(table.concat(digit):reverse()..frac_str))
end

-- decimal percent to dozenal
function perc(arb)
        local num=0
        num=math.floor(tonumber(arb)*144/100+0.5)
        return strfdec(num)
end

-- prints current hour using semidiurnal time
--semidiurnal (d for dozen)
-- 1dh = 1h
-- 1dm = 5min
-- 1ds = 25s
-- 1dt = 2+1/12 s
-- https://clock.dozenal.ca/clock/semidiurnal
function dtime()
        local date = os.date("*t")
        --print(date.hour)
        local zero=""
        local zero2=""
        local ds=25
        local digits={}
        if(date.hour<12) then --FIXME:add trailing 0s
                zero="0"
        end
        digits[#digits+1]=zero..strfdec(date.hour)
        digits[#digits+1]=";"
        --how many "ds" are in seconds
        local units=(date.min*60+date.sec)/(ds)
        if(units<12) then --FIXME:add trailing 0s
                zero2="0"
        end
        digits[#digits+1]=zero2 .. strfdec(math.floor(units))
        return table.concat(digits)
end


return {
	strfdec=strfdec
	perc=perc
	dtime=dtime
}
