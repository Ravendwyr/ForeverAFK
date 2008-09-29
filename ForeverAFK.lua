local status = false

--simply hide the logout popup as soom as it shows up. This triggers the OnHide method, which cancels logout
hooksecurefunc("StaticPopup_Show", function(which)
	if status and which == "CAMP" then
		StaticPopup_Hide("CAMP")
	end
end)

--prevents "You've been inactive for a long time..." system message spam when foreverAFK is active
local blizzMsgEventHandler = ChatFrame_MessageEventHandler
ChatFrame_MessageEventHandler = function(event,...)
	if status and event == "CHAT_MSG_SYSTEM" and arg1 == IDLE_MESSAGE then
		return true
	end
	return blizzMsgEventHandler(event,...)
end

--prevents "You can't logout now." error spam in UIErrorsFrame when ForeverAFK is active
local blizzErrorHandler = UIErrorsFrame_OnEvent
UIErrorsFrame_OnEvent = function(event,message,...)
	if status and event == "UI_ERROR_MESSAGE" and message == ERR_LOGOUT_FAILED then
		return
	end
	return blizzErrorHandler(event,message,...)
end

SlashCmdList["FOREVERAFK"] = function(msg)
	status = not status
	DEFAULT_CHAT_FRAME:AddMessage((status and "Forever AFK is now on.") or "Forever AFK is now off.")
end
SLASH_FOREVERAFK1 = "/foreverafk"
