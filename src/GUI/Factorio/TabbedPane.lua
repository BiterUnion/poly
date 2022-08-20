-- Poly: generated for Factorio 1.1.67 runtime API 3

local Class = require('__poly__.Class')
local Component = require('__poly__.GUI.Component')
local FactorioComponent = require('__poly__.GUI.Factorio.FactorioComponent')

local TabbedPane = Class:new('TabbedPane', FactorioComponent)

function TabbedPane:new(args)
    local tabbed_pane = FactorioComponent:new(args)
    tabbed_pane.lua_gui_element_parameters.type = 'tabbed-pane'
    
    tabbed_pane.lua_gui_element_delayed_parameters.selected_tab_index = args.selected_tab_index
    
    return tabbed_pane
end

function TabbedPane:get_selected_tab_index()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.selected_tab_index
    else
        return self.lua_gui_element_delayed_parameters.selected_tab_index
    end
end
function TabbedPane:set_selected_tab_index(selected_tab_index)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.selected_tab_index = selected_tab_index
    end
    self.lua_gui_element_delayed_parameters.selected_tab_index = selected_tab_index
end

function TabbedPane:get_tabs()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.tabs
    else
        return self.lua_gui_element_parameters.tabs
    end
end

function TabbedPane:add_tab(...)
    assert(self:get_state() == Component.State.Created, 'LuaGuiElement methods can only be called after the component has been created')
    self.lua_gui_element.add_tab(...)
end

function TabbedPane:remove_tab(...)
    assert(self:get_state() == Component.State.Created, 'LuaGuiElement methods can only be called after the component has been created')
    self.lua_gui_element.remove_tab(...)
end

return TabbedPane
