local Class = require('__poly__.Class')

List = {}

function List.sum(list)
    local result = 0
    for i = 1, #list.data do
        result = result + list.data[i]
    end
    return result
end

WrappedList = {}

function WrappedList.sum(list)
    return List.sum(list)
end

PolyList = Class:new('PolyList')

function PolyList:new(data)
    return { data = data }
end

function PolyList:sum()
    local result = 0
    for i = 1, #self.data do
        result = result + self.data[i]
    end
    return result
end

DerivedPolyList = Class:new('DerivedPolyList', PolyList)

local profile = {}

function profile.overhead(list)
    -- empty profiling method for measuring profiling overhead
end

function profile.inlined(list)
    local result = 0
    for i = 1, #list.data do
        result = result + list.data[i]
    end
    return result
end

function profile.explicit(list)
    return List.sum(list)
end

function profile.implicit(list)
    list:sum()
end

function profile.wrapped(list)
    return WrappedList.sum(list)
end

function profile.poly(list)
    return list:sum()
end

function profile.derived(list)
    return list:sum()
end

commands.add_command('poly_profile_class_mechanism', '', function(command)
    if command.parameter == nil then
        return
    end
    game.print('profiling ' .. command.parameter .. ' class mechanism...')
    local variant = profile[command.parameter]
    if variant == nil then
        return
    end
    local data = {}
    for i = 1, 1000 do
        data[i] = i * 2
    end
    local list
    if command.parameter == 'poly' then
        list = PolyList:new(data)
    elseif command.parameter == 'derived' then
        list = DerivedPolyList:new(data)
    else
        list = { _poly = { class_name = 'List' }, data = data }
        setmetatable(list, { __index = List })
    end
    local num_runs = 20
    local num_evaluations = 1000000
    for run = 1, num_runs do
        local profiler = game.create_profiler()
        for _ = 1, num_evaluations do
            local result = variant(list)
        end
        profiler.stop()
        game.write_file(command.parameter .. '_' .. tostring(#list.data) .. '_' .. tostring(num_evaluations), { '', profiler, '\n' }, true, command.player_index)
    end
    game.print('done')

    --- profiling results:
    -- small runtimes (10 list elements):
    --     overhead:      22.0003ms     23.91292ms     53.13664ms
    --     inlined :     309.4837ms     316.7105ms     339.3742ms
    --     explicit:     354.8529ms      358.781ms     382.5593ms (+14.4% over inlined without overhead)
    --     implicit:     355.6629ms     362.1071ms     384.0822ms (+15.5% over inlined without overhead)
    --     wrapped :     408.2394ms      423.566ms     515.7245ms (+19.3% over explicit without overhead)
    --     poly  :     388.6392ms     396.1755ms     425.1345ms (+27.1% over inlined without overhead)
    --     derived :       385.31ms     391.6023ms     422.8824ms (+25.6% over inlined without overhead)
    -- medium runtimes (50 list elements):
    --     overhead:      22.8908ms     26.33043ms     60.55897ms
    --     inlined :     1462.858ms      1493.49ms     1511.753ms
    --     explicit:     1468.777ms      1522.71ms     1555.563ms (+1.99% over inlined without overhead)
    --     implicit:     1430.167ms     1467.338ms     1489.258ms (-1.78% over inlined without overhead)
    --     wrapped :     1559.182ms     1598.642ms     1824.067ms (+5.07% over explicit without overhead)
    --     poly  :     1336.399ms     1348.729ms     1377.071ms (-9.87% over inlined without overhead)
    --     derived :     1341.346ms     1380.828ms     1436.706ms (-7.68% over inlined without overhead)
    -- large runtimes (1000 list elements):
    --     overhead:     21.87061ms      24.2571ms     52.13777ms
    --     inlined :     26007.08ms     26850.53ms     28416.51ms
    --     explicit:     26831.12ms      27767.5ms     29848.08ms (+3.42% over inlined without overhead)
    --     implicit:     26454.38ms     27903.41ms     32280.71ms (+3.92% over inlined without overhead)
    --     wrapped :     28463.55ms     28912.34ms     31816.17ms (+4.13% over explicit without overhead)
    --     poly  :      26090.3ms     27333.34ms     27592.41ms (+1.8% over inlined without overhead)
    --     derived :      24778.7ms     25232.24ms      25586.1ms (-6.03% over inlined without overhead)
end)
