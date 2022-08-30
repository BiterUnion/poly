-- prepare-listing-start
-- require Poly's Class API
local Class = require('__poly__.Class')

-- require Poly's EventHandler
local EventHandler = require('__poly__.GUI.EventHandler')

-- define globally available handler function
function handle_button_click(value, event)
    print('called global handle_button_click(' .. value .. ')')
end

-- define event handler class
local MyHandlerClass = Class:new('examples.MyHandlerClass')
function MyHandlerClass:new()
    return {}
end
function MyHandlerClass:handle_button_click(value, event)
    print('called MyHandlerClass:handle_button_click(' .. value .. ')')
end
-- prepare-listing-end

commands.add_command('poly_example_event_handling_create', '', function(command)
    -- create a GUI using Factorio's LuaGuiElement
    local player = game.players[command.player_index]
    frame = player.gui.screen.add {
        type = 'frame'
    }

    -- listing-start
    -- register call to globally defined function handle_button_click(5)
    local id1 = EventHandler:register(nil, 'handle_button_click', 5)
    -- register call to my_object:handle_button_click(10)
    local my_object = MyHandlerClass:new()
    local id2 = EventHandler:register(my_object, 'handle_button_click', 10)
    -- register call to MyHandlerClass:handle_button_click(15)
    local id3 = EventHandler:register(MyHandlerClass, 'handle_button_click', 15)

    -- create a button on some previously defined frame
    local button = frame.add {
        type = 'button', name = 'test_button',
        tags = {
            -- pass the registered event handlers to the LuaGuiElement by id
            -- you can either pass a single id or an array containing multiple ids
            Poly = { on_gui_click = { id1, id2, id3 } }
        }
    }
    -- listing-end
end)

commands.add_command('poly_example_event_handling_destroy', '', function(command)
    local button = frame.children[1]
    EventHandler:delete(button)
    frame.destroy()
    print(serpent.block(global))
end)