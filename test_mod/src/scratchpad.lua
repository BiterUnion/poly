local Component = require('__poly__.GUI.Component')

local WindowManager = require('__poly__.GUI.WindowManager')
local Window = require('__poly__.GUI.Window')

commands.add_command('poly_scratchpad', '', function(command)
    local player = game.players[command.player_index]

    local window = Window:new {
        titlebar = { title = 'Test Window' },
    }
    WindowManager:open(WindowManager.Anchor.screen(player), window)
    window:force_auto_center()
end)

commands.add_command('poly_scratchpad_print_global', '', function(command)
    print(serpent.block(global))
end)

commands.add_command('poly_scratchpad_print', '', function(command)
    print(table_size(global.poly.event_handler))
end)
