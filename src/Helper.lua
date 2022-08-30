local Helper = {}

function Helper.uuid()
    if global.uuid_random == nil then
        global.uuid_random = game.create_random_generator()
    end
    local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function(c)
        local v = (c == 'x') and global.uuid_random(0, 0xf) or global.uuid_random(8, 0xb)
        return string.format('%x', v)
    end)
end

function Helper.deep_copy(tbl)
    local function copy(tbl, visited_tables)
        local tbl_copy = {}
        visited_tables[tbl] = tbl_copy
        for k, v in pairs(tbl) do
            if type(v) == 'table' then
                if visited_tables[v] ~= nil then
                    tbl_copy[k] = visited_tables[v]
                else
                    tbl_copy[k] = copy(v, visited_tables)
                end
            else
                tbl_copy[k] = v
            end
        end
        return tbl_copy
    end
    return copy(tbl, {})
end

local ReadOnlyMetatable = {
    __index = function(t, k)
        return t._poly.data[k]
    end,
    __newindex = function()
        error('cannot update read-only table', 2)
    end
}
script.register_metatable('_poly_read_only_metatable', ReadOnlyMetatable)
function Helper.read_only(tbl)
    local proxy = { _poly = { data = tbl } }
    setmetatable(proxy, ReadOnlyMetatable)
    return proxy
end

function Helper.apply_style(lua_gui_element, style)
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

return Helper
