--- MultipartData Parser module
-- multipart/form-data support
-- @author Israel Sotomayor israel@moltin.com

local stringy = require "stringy"
local upload = require "resty.upload"

local MultipartData = {}
MultipartData.__index = MultipartData

setmetatable(MultipartData, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

--- Load multipart/form-data request
-- @param chunk_size string should be set to 4096 or 8192 for real-world settings
-- @return table with the data sent on the request
local function decode (chunk_size)
    local result = {}

    local form, err = upload:new(chunk_size)
    if not form then
        return nil -- There is no form data to read from
    end

    form:set_timeout(1000) -- 1 sec

    local part_index = 1
    local part_name, part_value

    while true do
        local typ, res, err = form:read()
        if not typ then
            return nil -- An error happened, 'failed to read'
        end

        if typ == "header" then
            if stringy.startswith(string.lower(res[1]), "content-disposition") then
                local parts = stringy.split(res[3], ";")
                local current_parts = stringy.split(stringy.strip(parts[2]), "=")
                if string.lower(table.remove(current_parts, 1)) == "name" then
                    local current_value = stringy.strip(table.remove(current_parts, 1))
                    part_name = string.sub(current_value, 2, string.len(current_value) - 1)
                end
            end
        elseif typ == "body" then
            part_value = res
        elseif typ == "part_end" then
            if part_name ~= nil then
                result[part_name] = part_value

                -- Reset fields for the next part
                part_value = nil
                part_name = nil
                part_index = part_index + 1
            end
        elseif typ == "eof" then
            break -- Finish reading the input
        else
            -- Do nothing
        end
    end
    return result
end

--- Get read data from the multiform/form-data request
-- @return table data, or nil
function MultipartData:get()
    return self._data
end

--- Construct class
-- @param chunk_size string should be set to 4096 or 8192 for real-world settings
-- @return instance of MultipartData class
function MultipartData.new(chunk_size)
    local instance = {}
    setmetatable(instance, MultipartData)

    -- Should be set to 4096 or 8192 for real-world settings
    instance._chunk_size = chunk_size or 4096

    instance._data = decode(instance._chunk_size)
    return instance
end

return MultipartData