require('__poly__.GUI.init_control')

local Class = require('__poly__.Class')
local Frame = require('__poly__.GUI.Factorio.Frame')
local Flow = require('__poly__.GUI.Factorio.Flow')
local Label = require('__poly__.GUI.Factorio.Label')
local EmptyWidget = require('__poly__.GUI.Factorio.EmptyWidget')
local SpriteButton = require('__poly__.GUI.Factorio.SpriteButton')
local EventHandler = require('__poly__.GUI.EventHandler')
local WindowManager = require('__poly__.GUI.WindowManager')

local Window = Class:new('Window', Frame)

function Window:new(args)
    args.titlebar = args.titlebar or {}
    local window = Frame:new {
        name = args.name,
        direction = 'vertical',
        style = 'Poly.GUI.Window',

        Flow:new {
            name = 'titlebar',
            direction = 'horizontal',
            style = 'Poly.GUI.Window.Titlebar',

            Label:new {
                name = 'title',
                caption = args.titlebar.title,
                style = 'Poly.GUI.Window.Titlebar.Title',
                ignored_by_interaction = true
            },
            EmptyWidget:new {
                name = 'drag_handle',
                style = 'Poly.GUI.Window.Titlebar.DragHandle',
                ignored_by_interaction = true
            },
            table.unpack(args.titlebar)
        },
        table.unpack(args)
    }
    if args.titlebar.add_close_button == nil or args.titlebar.add_close_button == true then
        window.titlebar:add_child(SpriteButton:new {
            name = 'close_button',
            sprite = 'utility/close_white', hovered_sprite = 'utility/close_black', clicked_sprite = 'utility/close_black',
            style = 'Poly.GUI.Window.Titlebar.SpriteButton',
            on_gui_click = EventHandler:register(WindowManager, 'close', window, args.titlebar.delete_on_close)
        })
    end
    return window
end

function Window:create(parent)
    Frame.create(self, parent)
    self.titlebar:set_drag_target(self.lua_gui_element)
end

function Window:destroy()
    self.titlebar:set_drag_target(nil)
    Frame.destroy(self)
end

return Window