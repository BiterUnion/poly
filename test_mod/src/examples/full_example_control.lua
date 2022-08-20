-- require Factorio's mod GUI for adding a mod button
local mod_gui = require('mod-gui')

-- require Poly's WindowManager & Window component
local WindowManager = require('__poly__.GUI.WindowManager')
local Window = require('__poly__.GUI.Window')

-- require Poly's Component API
local Component = require('__poly__.GUI.Component')

-- require Poly's pre-implemented components for frame, flow, button, sprite-button, empty-widget and label
local Frame = require('__poly__.GUI.Factorio.Frame')
local Flow = require('__poly__.GUI.Factorio.Flow')
local Button = require('__poly__.GUI.Factorio.Button')
local SpriteButton = require('__poly__.GUI.Factorio.SpriteButton')
local EmptyWidget = require('__poly__.GUI.Factorio.EmptyWidget')
local Label = require('__poly__.GUI.Factorio.Label')

-- require Poly's EventHandler API
local EventHandler = require('__poly__.GUI.EventHandler')

-- require custom SpinnerLabel component
local SpinnerLabel = require('SpinnerLabel')

-- require custom CaptionDialog
local CaptionDialog = require('CaptionDialog')


-- function for initializing a mod button and counter GUI for the given player
-- this will be called when the mod is initialized or a new player joins
local function create_counter_gui(player)
    -- initialize player's counter GUI and store it in global
    global.counter_guis[player.index] = Window:new {
        -- configure window's titlebar (don't delete window when closing, because we want to keep it in global)
        titlebar = { title = 'Counter', delete_on_close = false },

        -- add content to the window
        Frame:new {
            name = 'content',
            direction = 'horizontal',
            style = { 'inside_shallow_frame_with_padding' },

            Flow:new {
                name = 'counter',
                style = 'player_input_horizontal_flow',

                Label:new { name = 'counter_caption', caption = 'My Counter' },
                -- add button for opening CaptionDialog (its event handler directly calls WindowManager:open)
                SpriteButton:new { style = 'tool_button', sprite = 'utility/rename_icon_normal',
                                   on_gui_click = EventHandler:register(WindowManager, 'open',
                                   -- WindowManager:open's arguments:
                                           WindowManager.Anchor.screen(player), CaptionDialog) },
                EmptyWidget:new { style = { width = 12 } },
                SpinnerLabel:new { name = 'counter_value', initial_value = 0 }
            }
        }
    }

    -- create player's mod button for opening/closing the counter GUI
    local mod_button = Button:new {
        caption = 'C',
        style = mod_gui.button_style,
        on_gui_click = EventHandler:register(nil, 'toggle_counter_gui', global.counter_guis[player.index])
    }
    mod_button:create(mod_gui.get_button_flow(player))
end

-- create global event handler for toggling counter GUI
function toggle_counter_gui(counter_window, event)
    local player = game.get_player(event.player_index)
    -- depending on counter GUIs state, either open or close it
    if counter_window:get_state() == Component.State.Created then
        -- close counter GUI, but don't delete it
        WindowManager:close(counter_window, false)
    else
        -- open counter GUI
        WindowManager:open(WindowManager.Anchor.screen(player), counter_window)
    end
end

-- create counter GUI for all players when the mod is initialized
script.on_init(function(event)
    global.counter_guis = {}
    for _, player in pairs(game.players) do
        create_counter_gui(player)
    end
end)
-- create counter GUI for newly joined players
script.on_event(defines.events.on_player_created, function(event)
    local player = game.get_player(event.player_index)
    create_counter_gui(player)
end)
