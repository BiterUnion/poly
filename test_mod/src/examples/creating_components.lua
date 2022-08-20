-- require Poly's Class API
local Class = require('__poly__.Class')

-- require Poly's pre-implemented components for flow, textfield, and button
local Flow = require('__poly__.GUI.Factorio.Flow')
local Textfield = require('__poly__.GUI.Factorio.Textfield')
local Button = require('__poly__.GUI.Factorio.Button')

-- require Poly's EventHandler API
local EventHandler = require('__poly__.GUI.EventHandler')


-- define a new custom component called "SpinnerTextfield", derived from Flow
local SpinnerTextfield = Class:new('SpinnerTextfield', Flow)

-- override Flow's `new` to create a custom flow containing the SpinnerTextfield's buttons and textfield
function SpinnerTextfield:new(args)
    -- create the SpinnerTextfield as a flow containing two buttons and a textfield
    local spinner_textfield = Flow:new {
        name = args.name,
        direction = 'horizontal',

        -- add button for decreasing the spinner value
        Button:new { name = 'decrease', caption = '-', style = { width = 36 } },
        -- add numeric textfield with optional initial value that can be passed as
        -- a parameter to SpinnerTextfield's `new` for displaying the spinner value
        Textfield:new { name = 'spinner_value', numeric = true, text = args.initial_value, style = { width = 48 } },
        -- add button for increasing the spinner value
        Button:new { name = 'increase', caption = '+', style = { width = 36 } }
    }
    -- setup event handling
    spinner_textfield.decrease:add_on_gui_click(EventHandler:register(spinner_textfield, 'on_gui_click_inc_dec', -1))
    spinner_textfield.increase:add_on_gui_click(EventHandler:register(spinner_textfield, 'on_gui_click_inc_dec', 1))

    return spinner_textfield
end

-- add event handler function for updating the SpinnerTextfield's value
function SpinnerTextfield:on_gui_click_inc_dec(delta, event)
    if event.shift then
        -- multiply delta by 10, if the shift key was pressed during click
        delta = delta * 10
    end
    -- get current value and modify by delta
    local value = tonumber(self.spinner_value:get_text()) or 0
    self.spinner_value:set_text(tostring(value + delta))
end


-- make SpinnerTextfield usable as Lua module
return SpinnerTextfield
