require 'table'
require 'lib/lib_Debug'

local Core = {
    chatHistory = {},
    chatHistoryLimit = 50,
    allowReRecording = false, -- Set to true if you want reinserted messages to be remembered like any other messages are (good for multiple reloadui)
}

function OnComponentLoad(args)
    Debug.EnableLogging(false)
    Debug.Log('Xsear\'s Chat Reloader Loaded')

    if Component.GetSetting('_ReloadUI') then 
        Component.SaveSetting('_ReloadUI', false)
        OnPostReloadUI()
    end
end

function OnPreReloadUI(args)
    Debug.Log('OnPreReloadUI')
    
    Component.SaveSetting('_Core_chatHistory', Core.chatHistory)

    Component.SaveSetting('_ReloadUI', true)
end

function OnPostReloadUI(args)
    Debug.Log('OnPostReloadUI')

    for _, args in ipairs(Component.GetSetting('_Core_chatHistory')) do
        args.xChatReloader_recordedMessage = true
        Component.GenerateEvent('MY_CHAT_MESSAGE', args)
    end

    Component.SaveSetting('_Core_chatHistory', {})
end

function OnChatMessage(args)
    if not args.xChatReloader_recordedMessage or Core.allowReRecording then

        if #Core.chatHistory >= Core.chatHistoryLimit then
            table.remove(Core.chatHistory, 1)
        end

        Core.chatHistory[#Core.chatHistory + 1] = args
    end
end