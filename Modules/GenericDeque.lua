local genericDeque = {}

function genericDeque:pushRight(x)
    assert(x ~= nil)
    self.tail = self.tail + 1
    self[self.tail] = x
end

function genericDeque:pushLeft(x)
    assert(x ~= nil)
    self[self.head] = x
    self.head = self.head - 1
end

function genericDeque:peekRight()
    return self[self.tail]
end

function genericDeque:peekLeft()
    return self[self.head + 1]
end

function genericDeque:popRight()
    if self:isEmpty() then return nil end
    local r = self[self.tail]
    self[self.tail] = nil
    self.tail = self.tail - 1
    return r
end

function genericDeque:popLeft()
    if self:isEmpty() then return nil end
    local r = self[self.head + 1]
    self.head = self.head + 1
    local r = self[self.head]
    self[self.head] = nil
    return r
end

function genericDeque:rotateRight(n)
    n = n or 1
    if self:isEmpty() then return nil end
    for _ = 1, n do self:pushLeft(self:popRight()) end
end

function genericDeque:rotateLeft(n)
    n = n or 1
    if self:isEmpty() then return nil end
    for _ = 1, n do self:pushRight(self:popLeft()) end
end

function genericDeque:removeAtInternal(idx)
    for i = idx, self.tail do self[i] = self[i + 1] end
    self.tail = self.tail - 1
end

function genericDeque:removeRight(x)
    for i = self.tail, self.head + 1, -1 do
        if self[i] == x then
            genericDeque:removeAtInternal(i)
            return true
        end
    end
    return false
end

function genericDeque:removeLeft(x)
    for i = self.head + 1, self.tail do
        if self[i] == x then
            genericDeque:removeAtInternal(i)
            return true
        end
    end
    return false
end

function genericDeque:length()
    return self.tail - self.head
end

function genericDeque:isEmpty()
    return self:length() == 0
end

function genericDeque:contents()
    local r = {}
    for i = self.head + 1, self.tail do
        r[i - self.head] = self[i]
    end
    return r
end

function genericDeque:iterRight()
    local i = self.tail + 1
    return function()
        if i > self.head + 1 then
            i = i - 1
            return self[i]
        end
    end
end

function genericDeque:iterLeft()
    local i = self.head
    return function()
        if i < self.tail then
            i = i + 1
            return self[i]
        end
    end
end

function genericDeque:headNext()
    return self.head - 1
end

function genericDeque:headCurrent()
    return self.head
end

function genericDeque:headPrev()
    return self.head - 1
end

function genericDeque:tailNext()
    return self.tail + 1
end

function genericDeque:tailCurrent()
    return self.tail
end

function genericDeque:tailPrev()
    return self.tail - 1
end

function genericDeque:new(thisObj)
    thisObj = thisObj or { head = 0, tail = 0 }
    setmetatable(thisObj, { __index = self })

    return thisObj
end

return genericDeque