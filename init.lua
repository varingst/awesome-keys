local awful = require('awful')
--luacheck: globals unpack
--luacheck: no unused args
local module = {
    join = function(...)
        local keys = {}
        for _, key in ipairs(arg) do
            -- table of keyobjects, returned from awful.key()
            if type(key[1]) == "key" then
                keys = awful.util.table.join(keys, key)
            -- table of table of keyobjects, returned from bind()
            else
                keys = awful.util.table.join(keys, unpack(key))
            end
        end
        return keys
    end,

    only_if = function(make_keys, ...)
        if make_keys then
            return awful.util.table.join(...)
        else
            return {}
        end
    end
}

local function bind(_, group)
    return function(mod, ...)
        local keylist = {}
        local i = 1
        while arg[i] do
            table.insert(keylist, awful.key(mod, arg[i+1], arg[i+2],
                         { description = arg[i], group = group }))
            i = i + 3
        end
        return keylist
    end
end

--[[

Setting __index : module.mygroup() calls bind(module, "mygroup")
module.mygroup({ "Control" }, "belongs to group <mygroup>", "F3", function() end)

Setting __call  : module()         calls bind(module, nil)
module({ "Control" },  "does not belong to any group" "F4", function() end)

]]--

setmetatable(module, { __index = bind,
                       __call = function(_, ...) return bind()(...) end })
return module
