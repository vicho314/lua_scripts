#!/usr/bin/lua
album_name=arg[2] or "album"
player="mpv --no-video"
-- FIXME: add user Music path
--music="$HOME/$MUSIC"
music="~/Música"

--print help
if arg[1]=="-h" then
	print("album - m3u automaker and visualizer")
	print("USAGE:\n album [OPTION] NAME")
	print("\n-c\tcreate a playlist NAME.m3u with all files inside curr. dir")
	print("-m\tmove all playlists inside dir to Music dir in HOME")
	print("\nIf no first option is given, it shows all m3u files in MUSIC.")
	print("\nElse, it plays NAME album with PLAYER.")
elseif arg[1]=="-m" then
	os.execute("mv *.m3u "..music)
--FIXME:add non-Unix support (what?)
elseif arg[1]=="-c" then
	os.execute([[find "$PWD" | grep "mp3\|wav\|m4a\|ogg\|opus\|flac" >]]..album_name .. ".m3u")
elseif arg[1]=="show" or arg[1]==nil then
	os.execute("ls "..music.." | grep m3u")
else
	os.execute(player.." "..music.."/"..arg[1]..".m3u")
end
