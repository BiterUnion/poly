require('__poly__.init_control')

Poly.GUI = {}

function Poly.GUI.apply_style(lua_gui_element, style)
    if type(style) == 'string' then
        lua_gui_element.style = style
    elseif type(style) == 'table' then
        if style[1] ~= nil then
            lua_gui_element.style = style[1]
        end
        for k, v in pairs(style) do
            if k ~= 1 then
                lua_gui_element.style[k] = v
            end
        end
    else
        assert(false, 'style has to be string or table')
    end
end
