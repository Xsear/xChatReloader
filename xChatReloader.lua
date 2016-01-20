
-- ------------------------------------------
-- Chat Reloader
--   by: Xsear
-- ------------------------------------------

require "table"
require "lib/lib_Debug"
require "lib/lib_InterfaceOptions"
require "lib/lib_ChatLib"

-- ------------------------------------------
-- CONSTANTS
-- ------------------------------------------

AddonInfo = {
    release  = "2016-01-20",
    version = "1.1",
    patch = "1.6.14xx",
    save = 1,
}

OUTPUT_PREFIX = "[xCR] "
RELOADUI_FLAG = "_ReloadUI"
RELOADUI_DATA_CHATHISTORY = "_ReloadUI_ChatHistory"
MAX_HISTORY_LIMIT = 2048

-- ------------------------------------------
-- VARIABLES
-- ------------------------------------------

local g_ChatHistory = {}


-- ------------------------------------------
-- OPTIONS
-- ------------------------------------------

g_Loaded = false
g_Options = {}
g_Options.Enabled = true
g_Options.Debug = false
g_Options.AllowReRecording = false
g_Options.ChatHistoryLimit = 50

-- Callback for when an options is changed in the Interface Options. Updates the value in g_Options.
function OnOptionChanged(id, value)

    if id == "__LOADED" then
        OnOptionsLoaded()

    elseif id == "Debug" then
        Component.SaveSetting("Debug", value)
        Debug.EnableLogging(value)

    elseif id == "ChatHistoryLimit" or "Enabled" then
        g_ChatHistory = {}
    end
    
    g_Options[id] = value
end

function OnOptionsLoaded()
    g_Loaded = true
end

-- Creating the Interface Options
do
    InterfaceOptions.NotifyOnLoaded(true)
    InterfaceOptions.SaveVersion(AddonInfo.save)

    InterfaceOptions.AddCheckBox({id = "Enabled", label = "Enable addon", tooltip = "If unchecked, the addon will not restore messages. Please note that this doesn't truly stop the addon from functioning - it merely suppresses actions that would otherwise signify that the addon is active. If you are suspecting compatability issues with other addons, it would be better to tempoarily remove the addon in order to verify whether or not it is part of the issue.", default = g_Options.Enabled})
    InterfaceOptions.AddCheckBox({id = "Debug", label = "Enable debug", tooltip = "If checked, the addon will log messages into the console that are helpful to the addon creator in order to track down problems.", default = g_Options.Debug})
    InterfaceOptions.AddCheckBox({id = "AllowReRecording", label = "Restore previously restored messages", tooltip = "If checked, the addon will restore messages even if they had already been restored in a previous reload. This way, messages can persist through multiple reloads.", default = g_Options.Debug})
    InterfaceOptions.AddSlider({id = "ChatHistoryLimit", label = "Message limit", tooltip = "Maximum number of messages that the addon will restore. The addon will wipe its current history when you change this value.", default = g_Options.ChatHistoryLimit, min = 1, max = 2048, inc = 1, format="%0.0f"})
end


-- ------------------------------------------
-- EVENTS
-- ------------------------------------------

function OnComponentLoad(args)
    Debug.EnableLogging(Component.GetSetting("Debug"))
    InterfaceOptions.SetCallbackFunc(OnOptionChanged, "Chat Reloader")

    if Component.GetSetting(RELOADUI_FLAG) then 
        Component.SaveSetting(RELOADUI_FLAG, false)
        OnPostReloadUI()
    end
end

function OnPreReloadUI(args)
    Debug.Event(args)
    
    Component.SaveSetting(RELOADUI_DATA_CHATHISTORY, g_ChatHistory)

    Component.SaveSetting(RELOADUI_FLAG, true)
end

function OnPostReloadUI(args)
    Debug.Log("OnPostReloadUI")

    local restoredHistory = Component.GetSetting(RELOADUI_DATA_CHATHISTORY)

    if g_Options.Enabled then
        for index, args in ipairs(Component.GetSetting(RELOADUI_DATA_CHATHISTORY)) do
            args.xChatReloader_recordedMessage = true
            Component.GenerateEvent("MY_CHAT_MESSAGE", args)
        end
    end

    Component.SaveSetting(RELOADUI_DATA_CHATHISTORY, {})
end

function OnChatMessage(args)
    if not args.xChatReloader_recordedMessage or g_Options.AllowReRecording then

        if #g_ChatHistory >= g_Options.ChatHistoryLimit then
            table.remove(g_ChatHistory, 1)
        end

        g_ChatHistory[#g_ChatHistory + 1] = args
    end
end