-- TODO: make helpers a local table for better performance

function Poly.uuid()
    if global.uuid_random == nil then
        global.uuid_random = game.create_random_generator()
    end
    local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function(c)
        local v = (c == 'x') and global.uuid_random(0, 0xf) or global.uuid_random(8, 0xb)
        return string.format('%x', v)
    end)
end

function Poly.deep_copy(tbl)
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
function Poly.read_only(tbl)
    local proxy = { _poly = { data = tbl } }
    setmetatable(proxy, ReadOnlyMetatable)
    return proxy
end
