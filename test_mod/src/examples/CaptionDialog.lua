-- require Poly's Class API
local Class = require('__poly__.Class')

-- require Poly's pre-implemented components for frame, flow, empty-widget, label, textfield, and button
local Frame = require('__poly__.GUI.Factorio.Frame')
local Flow = require('__poly__.GUI.Factorio.Flow')
local EmptyWidget = require('__poly__.GUI.Factorio.EmptyWidget')
local Label = require('__poly__.GUI.Factorio.Label')
local Textfield = require('__poly__.GUI.Factorio.Textfield')
local Button = require('__poly__.GUI.Factorio.Button')

-- require Poly's WindowManager & Window component
local WindowManager = require('__poly__.GUI.WindowManager')
local Window = require('__poly__.GUI.Window')

-- require Poly's EventHandler API
local EventHandler = require('__poly__.GUI.EventHandler')


-- define a new custom component called "CaptionDialog", derived from Window
local CaptionDialog = Class:new('CaptionDialog', Window)

-- override Window's `new` to create a custom window
function CaptionDialog:new()
    local caption_dialog = Window:new {
        -- configure dialog's titlebar (don't add a close button, as Factorio dialogs have a back button on the bottom)
        titlebar = { title = 'Enter counter\'s caption', add_close_button = false },

        -- add a frame for dialog's content (a label and textfield)
        Frame:new {
            name = 'content',
            direction = 'horizontal',
            style = { 'inside_shallow_frame_with_padding' },

            Flow:new {
                name = 'input',
                style = 'player_input_horizontal_flow',

                Label:new { caption = 'Counter caption:' },
                Textfield:new { name = 'counter_caption' }
            }
        },
        -- add a flow for dialog's buttons (Back and Confirm)
        Flow:new {
            name = 'buttons',
            direction = 'horizontal',

            Button:new { name = 'back', caption = 'Back', style = 'back_button' },
            EmptyWidget:new { style = { horizontally_stretchable = true } },
            Button:new { name = 'confirm', caption = 'Confirm', style = 'confirm_button' }
        }
    }
    -- setup event handling
    caption_dialog.buttons.back:add_on_gui_click(EventHandler:register(caption_dialog, 'on_gui_click_back'))
    caption_dialog.buttons.confirm:add_on_gui_click(EventHandler:register(caption_dialog, 'on_gui_click_confirm'))

    return caption_dialog
end

-- add event handler functions for clicking on buttons
function CaptionDialog:on_gui_click_back()
    -- close this dialog
    WindowManager:close(self)
end
function CaptionDialog:on_gui_click_confirm(event)
    -- apply the new caption to the counter GUI's label
    global.counter_guis[event.player_index].content.counter.counter_caption:set_caption(
            self.content.input.counter_caption:get_text())
    -- close this dialog
    WindowManager:close(self)
end

-- make CaptionDialog usable as Lua module
return CaptionDialog
