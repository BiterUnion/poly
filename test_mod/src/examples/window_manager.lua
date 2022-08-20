-- require Poly's Class API
local Class = require('__poly__.Class')

-- require Poly's WindowManager & Window
local WindowManager = require('__poly__.GUI.WindowManager')
local Window = require('__poly__.GUI.Window')

-- require Poly's pre-implemented component for label
local Label = require('__poly__.GUI.Factorio.Label')

-- add command that opens a new window in player.gui.screen
commands.add_command('open_window', '', function(command)
    local player = game.players[command.player_index]

    -- initialize a new window
    local window = Window:new {
        -- configure window's titlebar
        titlebar = {
            -- set window's title (append number of currently open windows)
            title = 'Test window ' .. tostring(#player.gui.screen.children)
        },

        -- add components to the window (3 labels for this example)
        Label:new { caption = 'This window can be dragged' },
        Label:new { caption = 'by clicking and dragging' },
        Label:new { caption = 'its titlebar or title' }
    }

    -- open window in player.gui.screen
    WindowManager:open(WindowManager.Anchor.screen(player), window)
end)

-- add command that closes all windows in player.gui.screen
commands.add_command('close_all_windows', '', function(command)
    local player = game.players[command.player_index]

    -- close all windows in player.gui.screen
    WindowManager:close(WindowManager.Anchor.screen(player))
end)