-- Imports
local Signal = require(script.Parent.Signal);
local SleitnickTimer = require(script.Parent.Timer);

--[=[
    The TimerCountdown class that returns a new TimerCountdown object with functions to create timers and countdowns.
    @class TimerCountdown
]=]
local TimerCountdown = {};
TimerCountdown.__index = TimerCountdown;

--[=[
    Creates a new timer object.
    @return TimerCountdown
]=]
function TimerCountdown.new()
    local self = setmetatable({}, TimerCountdown);
    self._timers = {};
    self._countdowns = {};
    return self;
end

--[=[
    Uses Sleitnicks Timer module to create a ``Simple`` timer that counts down from ``start`` to 0.
    Returns a signal that fires when the countdown is finished.

    If ``stopAtZero`` is true, the countdown will stop at 0. If it is false, the countdown will stop at 1.
    Countdown is automatically disconnected at the end of the countdown.

    @param countdownName string
    @param start number
    @param interval number
    @param updateFn function
    @param stopAtZero boolean
    @return Signal
]=]
function TimerCountdown:Countdown(countdownName, start, interval, updateFn, stopAtZero)
    local finished = Signal.new();
    local currTime = start;

    --// Check for current one with same name
    if (self._countdowns[countdownName]) then
        self._countdowns[countdownName]:Disconnect();
    end;

    local cn
    cn = SleitnickTimer.Simple(interval, function()
        updateFn(currTime);
        currTime -= interval;
        local stopAt = if (stopAtZero) then -1 else 0;
        if (currTime <= stopAt) then
            finished:Fire();
            cn:Disconnect();
        end;
    end, true);

    self._countdowns[countdownName] = cn;
    return finished;
end

--[=[
    @param timerName string
    @param endT number
    @param interval number
    @param updateFn function

    Uses Sleitnicks Timer module to create a ``Simple`` timer that counts up from 0 to ``endT``.
    Returns a signal that fires when the timer is finished.
    Timer is automatically disconnected at the end of the timer.
    
    @return Signal
]=]
function TimerCountdown:Timer(timerName, endT, interval, updateFn)
    local finished = Signal.new();
    local currTime = 0;

    --// Check for current one with same name
    if (self._timers[timerName]) then
        self._timers[timerName]:Disconnect();
    end;

    local cn
    cn = SleitnickTimer.Simple(interval, function()
        updateFn(currTime);
        currTime += interval;
        if (currTime >= endT) then
            finished:Fire();
            cn:Disconnect();
        end;
    end, true);

    self._timers[timerName] = cn;
    return finished;
end

--[=[
    @param name string
    Destroys the timer/countdown with the name ``name``.
]=]
function TimerCountdown:DestroyWithName(name)
    if (self._timers[name]) then
        self._timers[name]:Disconnect();
        self._timers[name] = nil;
    end;
    if (self._countdowns[name]) then
        self._countdowns[name]:Disconnect();
        self._countdowns[name] = nil;
    end;
end

--[=[
    Destroys all timers/countdowns.
]=]
function TimerCountdown:DestroyAll()
    for _, cn in pairs(self._timers) do
        cn:Disconnect();
    end;
    for _, cn in pairs(self._countdowns) do
        cn:Disconnect();
    end;
    table.clear(self._timers);
    table.clear(self._countdowns);
end

--[=[
    Destroys the TimerCountdown object.
]=]
function TimerCountdown:Destroy()
    self:DestroyAll();
    setmetatable(self, nil);
end

return table.freeze(TimerCountdown);