# Chat Reloader
A Firefall addon that remembers and restores chat messages after a reloadui.

You are welcome and encouraged to [leave feedback / ask for help / report issues in the addon thread](//forums.firefall.com/community/threads/2981021) on the official Firefall forums.

## Features
* Restores recent chat messages after the UI has been reloaded.
* Options to customize number of messages to store.

## Issues
* The addon can not restore messages that you whisper to another player. It will however remember messages that you send on normal chat channels.

## Interface Options
| Option  | Description |
|------------- | ------------- |
| Enable addon | If unchecked, the addon will not restore messages. |
| Enable debug | If checked, the addon will log messages into the console that are helpful to the addon creator in order to track down problems. |
| Restore previously restored messages | If checked, the addon will restore messages even if they had already been restored in a previous reload. This way, messages can persist through multiple reloads. |
| Message limit | The slider allows you to set maximum number of messages that the addon will restore. |
