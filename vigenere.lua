#!/usr/bin/lua
--global count
count=1

function ind(char,dic)
	return dic:find(char)
end

-- return fun(char), update global counter
-- gets index of "char", by using dic[]
function op_cipher(char,dic,passw,fun)
	if char:find("%a")==nil then
		return char
	else
		local i_l = ind(char:lower(),dic)-1
		local i_pw = ind(passw:sub(count,count),dic)-1
		local indx=fun(i_l,i_pw,passw,dic)
		count=count%passw:len()+1
		if char:find("%u") then
			return (dic:sub(indx,indx)):upper()
		else
			return dic:sub(indx,indx)
		end
	end
end

function plus(i_l,i_pw,passw,dic)
	return (i_l+i_pw)%dic:len()+1
end
function minus(i_l,i_pw,passw,dic)
	local indx=(i_l-i_pw)
		if(indx<0) then
			indx=indx+dic:len()
		end
	return indx%dic:len()+1
end
function encrypt(char,dic,passw)
	return op_cipher(char,dic,passw,plus)
end
function decrypt(char,dic,passw)
	return op_cipher(char,dic,passw,minus)
end

-- buf concat = less garbage !!
function get_passw(archive)
	local buf = {}
	for line in archive:lines() do
		for i in line:gmatch("%a") do 
			buf[#buf+1]=i:lower()
		end
	end
	archive:close()
	return table.concat(buf)
end

-- apply g() to every char in input
--FIXME: add output
function op(input, output, dic, passw, g)
	for line in input:lines() do
		for i=1,#line do
			char=g((line:sub(i,i)),dic,passw)
			--print(char)
			io.write(char)
		end
		io.write("\n")
	end
	io.close()
end

function encrypt_archive(input,output,dic,passw)
	op(input,output,dic,passw,encrypt)
end
function decrypt_archive(input,output,dic,passw)
	op(input,output,dic,passw,decrypt)
end

function print_help()
	print("\n")
	print("Usage: vigenere passw input output")
	print("\nNOTE: All inputs are files.")
	print("\n")
	print("-d :	Decrypt input file using passw")
	print("If no output is chosen, it will default to stdout.\n")
end

--main()
dic="abcdefghijklmnopqrstuvwxyz"
i=0
if(arg[1]==nil) then
	print_help()
	return
end

if(arg[1]=="-d") then
	i=1
	fun=decrypt_archive
else
	fun=encrypt_archive
end

passw=io.open(arg[1+i],"r")
if(arg[2+i]==nil) then
	input=io.input()
else
	input=io.open(arg[2+i],"r")
end
if(arg[3+i]==nil) then
	output=io.output()
else
	output=io.output(arg[3+i])
end
passw = get_passw(passw)
fun(input,output,dic,passw)
--print(passw)
