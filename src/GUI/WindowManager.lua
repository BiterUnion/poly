require('__poly__.GUI.init_control')

local Class = require('__poly__.Class')

if global.poly.window_manager == nil then
    global.poly.window_manager = {
        stacks = {},
        window_to_stack_position = {}
    }
end

local WindowManager = Class:new('WindowManager')

WindowManager.Anchor = {
    top = function(player)
        return player.gui.top
    end,
    left = function(player)
        return player.gui.left
    end,
    center = function(player)
        return player.gui.center
    end,
    goal = function(player)
        return player.gui.goal
    end,
    screen = function(player)
        return player.gui.screen
    end,
    relative = function(player)
        return player.gui.relative
    end
}

function WindowManager:open(anchor, window_or_class, ...)
    local window
    if Class:is_registered_class(window_or_class) then
        window = window_or_class:new(...)
    else
        window = window_or_class
    end

    local player_index = anchor.player_index
    local anchor_name = anchor.name
    if global.poly.window_manager.stacks[player_index] == nil then
        global.poly.window_manager.stacks[player_index] = {}
    end
    if global.poly.window_manager.stacks[player_index][anchor_name] == nil then
        global.poly.window_manager.stacks[player_index][anchor_name] = {}
    end
    local stack_size = #global.poly.window_manager.stacks[player_index][anchor_name]
    if stack_size > 0 then
        global.poly.window_manager.stacks[player_index][anchor_name][stack_size]:set_ignored_by_interaction(true)
    end
    global.poly.window_manager.stacks[player_index][anchor_name][stack_size + 1] = window
    global.poly.window_manager.window_to_stack_position[window] = {
        stack = global.poly.window_manager.stacks[player_index][anchor_name],
        index = stack_size + 1
    }
    window:set_ignored_by_interaction(false)
    window:create(anchor)
    window:force_auto_center()
    return window
end

function WindowManager:close(window_or_anchor, delete, delete_in_front)
    local stack, index
    if window_or_anchor.object_name == 'LuaGuiElement' then
        -- close whole stack
        stack = global.poly.window_manager.stacks[window_or_anchor.player_index][window_or_anchor.name]
        index = 1
    elseif global.poly.window_manager.window_to_stack_position[window_or_anchor] == nil then
        -- window was not managed by window manager
        window_or_anchor:destroy()
        if delete == nil or delete == true then
            window_or_anchor:delete()
        end
        return
    else
        stack = global.poly.window_manager.window_to_stack_position[window_or_anchor].stack
        index = global.poly.window_manager.window_to_stack_position[window_or_anchor].index
    end

    -- window was managed by window manager
    for idx = #stack, index, -1 do
        stack[idx]:destroy()
        if ((idx == index or window_or_anchor.object_name == 'LuaGuiElement') and (delete == nil or delete == true))
                or (idx > index and (delete_in_front == nil or delete_in_front == true)) then
            stack[idx]:delete()
        end
        global.poly.window_manager.window_to_stack_position[stack[idx]] = nil
        stack[idx] = nil
    end
    if index > 1 then
        stack[index - 1]:set_ignored_by_interaction(false)
    end
end

return WindowManager