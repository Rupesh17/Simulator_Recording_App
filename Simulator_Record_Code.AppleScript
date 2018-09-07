
# =================== Methods ==================

# Method to check App with "Name" passed as parameted is running or not
on is_running(appName)
	tell application "System Events" to (name of processes) contains appName
end is_running

# Method to create new Tab
on makeTab()
	tell application "System Events" to keystroke "t" using {command down}
	delay 0.2
end makeTab

# Method to stop recording of simulator
on stopRecording()
	tell application "System Events" to keystroke "c" using {control down}
end stopRecording

# Method to close current running tab
on closeCurrentTab()
	activate application "Terminal"
	delay 0.5
	tell application "System Events"
		tell process "Terminal"
			keystroke "w" using {command down}
		end tell
	end tell
end closeCurrentTab

# =================== App Script ==================

-- check terminal app  is running or not and save it in varibale
set safRunning to is_running("Terminal")
set simulatorRunning to is_running("Simulator")

-- set path to save video
tell application "System Events" to set currentUser to (name of current user)
set recordedFilePath to "/Users/" & currentUser & "/Documents/AppVideo.mov"

if simulatorRunning then
	tell application "Terminal" -- focus on terminal if already open or open if not launched
		activate
		
		if safRunning then -- if already running then open new tab
			my makeTab()
		end if
		
		do script "xcrun simctl io booted recordVideo " & recordedFilePath in front window
		delay 0.5
		
		
		display dialog "Please press stop to save recording" buttons {"Stop"} -- show dialog to stop recording
		if button returned of result = "Stop" then -- if stop recording button pressed
			my stopRecording() -- Stop recording
			delay 0.5
			
			if safRunning then -- If new tab was created 
				tell window 1
					set selected tab to tab 1
					my closeCurrentTab() -- Close the tab
				end tell
			else
				quit -- if App lunch the fresh terminal then quit the terminal
			end if
		end if
	end tell
	tell application "Finder" to open (recordedFilePath as POSIX file)
else
	display dialog "Please open the simulator first" buttons {"Ok"} -- show dialog to stop recording
end if
