--[[
	github/ElliottLMz/Cachet
	
	MIT License
	
	Copyright (c) 2019 Elliott Mozley
	
	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
]]
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Cachet = {}
Cachet.__index = Cachet

local BAD_TYPE = "bad argument #%i to '%s' (%s expected, got %s)"
local BAD_ARGUMENT = "bad argument #%i to '%s' (%s)"

--[[
	Better assert function.
]]
local function assert(assertion, message, level)
  if assertion then
    return assertion
  else
    error(message, level and level+1 or 2)
  end
end

--[[
	Creates, prepares, and returns a new cache object.
]]
function Cachet.new(defaultValues)
	assert(defaultValues == nil or typeof(defaultValues) == "table", BAD_TYPE:format(1, "Cachet.new", "table", typeof(defaultValues)), 2)
	
	local cache = setmetatable({
		data = {},
		event = Instance.new("BindableEvent")
	}, Cachet)
	
	if defaultValues then
		for key, value in pairs(defaultValues) do
			cache:store(key, value)
		end
	end

	return cache
end

--[[
	Retrives 'key' from the cache.
]]
function Cachet:retrieve(key)
	assert(typeof(key) == "string", BAD_TYPE:format(1, "cache.retrieve", "string", typeof(key)), 2)
	if self.data[key] then
		return self.data[key].value, self.data[key]
	else
		return nil, nil
	end
end

-- Alias for retrieve
Cachet.get = Cachet.retrieve

--[[
	Updates the cache
]]
function Cachet:store(key, value, invalidateAfter)
	assert(typeof(key) == "string", BAD_TYPE:format(1, "cache.store", "string", typeof(key)), 2)
	assert(value ~= nil, BAD_TYPE:format(2, "cache.store", "any", typeof(key)), 2)
	assert(invalidateAfter == nil or typeof(invalidateAfter) == "number" and invalidateAfter >= 1,
		BAD_TYPE:format(3, "cache.store", "number", typeof(invalidateAfter)), 2)
	
	local oldValue = self.data[key]
	local guid = HttpService:GenerateGUID(false)
	self.data[key] = {
		guid = guid,
		value = value,
		stored = os.time(),
		willInvalidate = invalidateAfter and os.time() + invalidateAfter
	}
	
	if invalidateAfter then
		coroutine.wrap(function()
			wait(invalidateAfter)
			self:invalidateGUID(guid)
		end)()
	end
	
	self.event:Fire(key, oldValue and oldValue.value, value, guid)
	
	return guid
end

-- Alias for store
Cachet.set = Cachet.store

--[[
	Retrives a key (or nil) based on the GUID provided
]]
function Cachet:getKeyFromGUID(guid)
	assert(typeof(guid) == "string", BAD_TYPE:format(1, "cache.getKeyFromGUID", "string", typeof(guid)), 2)
	for key, store in pairs(self.data) do
		if store.guid == guid then
			return key 
		end
	end
	return nil
end

--[[
	Invalidates the key if it exists
]]
function Cachet:invalidateKey(key)
	assert(typeof(key) == "string", BAD_TYPE:format(1, "cache.invalidateKey", "string", typeof(key)), 2)
	local oldValue = self.data[key]
	if oldValue then
		self.data[key] = nil
		self.event:Fire(key, oldValue.value, nil, nil)
		return true
	end
	return false
end

-- Aliases for invalidateKey
Cachet.remove = Cachet.invalidateKey
Cachet.drop = Cachet.invalidateKey

--[[
	Finds a key from GUID and invalidates it
]]
function Cachet:invalidateGUID(guid)
	assert(typeof(guid) == "string", BAD_TYPE:format(1, "cache.invalidateGUID", "string", typeof(guid)), 2)
	local key = self:getKeyFromGUID(guid)
	if key then
		return self:invalidateKey(key)
	else
		return false
	end
end

--[[
	Connects the callback to the updated event
]]
function Cachet:connect(callback)
	assert(typeof(callback) == "function", BAD_TYPE:format(1, "cache.connect", "function", typeof(callback)), 2)
	return self.event.Event:Connect(callback)
end

--[[
	Destroys the cache so it can no-longer be used
]]
function Cachet:destroy()
	self.event:Destroy()
	self.data = nil
	self = nil
end

return Cachet
