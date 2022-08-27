-- require Poly's Class API
local Class = require('__poly__.Class')

-- require Poly's pre-implemented components for flow, label, and button
local Flow = require('__poly__.GUI.Factorio.Flow')
local Label = require('__poly__.GUI.Factorio.Label')
local Button = require('__poly__.GUI.Factorio.Button')

-- require Poly's EventHandler API
local EventHandler = require('__poly__.GUI.EventHandler')


-- define a new custom component called "SpinnerLabel", derived from Flow
local SpinnerLabel = Class:new('examples.SpinnerLabel', Flow)

-- override Flow's `new` to create a custom flow containing the SpinnerLabel's buttons and label
function SpinnerLabel:new(args)
    -- create the SpinnerLabel as a flow containing two buttons and a label
    local spinner_label = Flow:new {
        name = args.name,
        direction = 'horizontal',

        -- add button for decreasing the spinner value
        Button:new { name = 'decrease', caption = '-', style = { width = 36 } },
        -- add a label with optional initial value that can be passed as
        -- a parameter to SpinnerLabel's `new` for displaying the spinner value
        Label:new { name = 'spinner_value', numeric = true, caption = args.initial_value,
                    style = { width = 48, horizontal_align = 'center', vertical_align = 'center' } },
        -- add button for increasing the spinner value
        Button:new { name = 'increase', caption = '+', style = { width = 36 } }
    }
    -- setup event handling
    spinner_label.decrease:add_on_gui_click(EventHandler:register(spinner_label, 'on_gui_click_inc_dec', -1))
    spinner_label.increase:add_on_gui_click(EventHandler:register(spinner_label, 'on_gui_click_inc_dec', 1))

    return spinner_label
end

-- add event handler function for updating the SpinnerLabel's value
function SpinnerLabel:on_gui_click_inc_dec(delta, event)
    if event.shift then
        -- multiply delta by 10, if the shift key was pressed during click
        delta = delta * 10
    end
    -- get current value and modify by delta
    local value = tonumber(self.spinner_value:get_caption()) or 0
    self.spinner_value:set_caption(tostring(value + delta))
end


-- make SpinnerLabel usable as Lua module
return SpinnerLabel
