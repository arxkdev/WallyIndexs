--[[
	
	Based on the ReplicatedTweening module by SteadyOn
		https://github.com/Steadyon/TweenServiceV2
	
	ReplicatedTween
		Constructors
			ReplicatedTween.new(object, tweenInfo, propertyTable)
			ReplicatedTween:Create(object, tweenInfo, propertyTable)
	
--]]

local RunService = game:GetService("RunService");
local HttpService = game:GetService("HttpService");
local TweenService = game:GetService("TweenService");

local INTERNAL_PLAYBACK_STATE = {
	Begin = 0,
	Play = 1,
	Reverse = 2,
	Done = 3,
};

local tweenEvent do
	if ((not tweenEvent) and RunService:IsServer()) then
		tweenEvent = Instance.new("RemoteEvent");
		tweenEvent.Name = "TweenEvent";
		tweenEvent.Parent = script;
	else
		tweenEvent = script:WaitForChild("TweenEvent");
	end;
end

local function tweenInfoConvert(tweenInfo)
	local tIType = typeof(tweenInfo);

	if (tIType == "TweenInfo") then
		return {
			tweenInfo.Time,
			tweenInfo.EasingStyle,
			tweenInfo.EasingDirection,
			tweenInfo.RepeatCount,
			tweenInfo.Reverses,
			tweenInfo.DelayTime
		}
	elseif (tIType == "table") then
		return TweenInfo.new(unpack(tweenInfo));
	else
		error("Cannot convert " .. tIType .. " in the context of TweenInfo");
	end;
end

local ReplicatedTween = {};

local masterTimer;
local timerCallbacks = {};

masterTimer = RunService.Heartbeat:Connect(function(step)
	for _, callback in pairs(timerCallbacks) do
		callback(step);
	end;
end)

local function construct(object, tweenInfo, propertyTable)
	local self = {
		Instance = object,
		TweenInfo = tweenInfo,
		PropertyTable = propertyTable,
		PlaybackState = Enum.PlaybackState.Begin,
		UniqueId = HttpService:GenerateGUID(false),
	};
	setmetatable(self, {__index = ReplicatedTween});

	local completedEvent = Instance.new("BindableEvent");
	self.CompletedEvent = completedEvent;
	self.Completed = completedEvent.Event;

	local playbackStateChangedEvent = Instance.new("BindableEvent");
	self.PlaybackStateChangedEvent = playbackStateChangedEvent;
	self.PlaybackStateChanged = playbackStateChangedEvent.Event;

	self.SetPlaybackState = function(newState)
		if (self.PlaybackState == newState) then return; end;

		self.PlaybackState = newState;
		self.PlaybackStateChangedEvent:Fire(newState);
	end;

	do
		local elapsed = 0;
		local nextCheckpoint = 0;
		local repeatCount = 0;
		local isPlaying = false;

		local internalState = INTERNAL_PLAYBACK_STATE.Begin;
		local nextInternalState = nil;

		local function sync()
			for propertyName, propertyValue in pairs(propertyTable) do
				object[propertyName] = propertyValue;
			end;
		end;

		local function pause()
			isPlaying = false;
		end;

		local function reset()
			elapsed = 0;
			nextCheckpoint = 0;
			repeatCount = 0;
			isPlaying = false;

			internalState = INTERNAL_PLAYBACK_STATE.Begin;
			nextInternalState = nil;

			self.PlaybackState = Enum.PlaybackState.Begin;
		end;

		local function scheduleCallback()
			local playbackState = self.PlaybackState;
			local tweenInfo = self.TweenInfo;

			local isDelayed = (tweenInfo.DelayTime > 0);
			local reverses = tweenInfo.Reverses;
			local repeats = (tweenInfo.RepeatCount ~= 0);

			if (internalState == INTERNAL_PLAYBACK_STATE.Begin) then
				if repeats then
					if ((repeatCount == (tweenInfo.RepeatCount + 1)) and (tweenInfo.RepeatCount > 0)) then
						internalState = INTERNAL_PLAYBACK_STATE.Done
						scheduleCallback();
						return;
					else
						repeatCount = repeatCount + 1;
					end;
				end;

				if isDelayed then
					self.SetPlaybackState(Enum.PlaybackState.Delayed);

					nextCheckpoint = tweenInfo.DelayTime;
					nextInternalState = INTERNAL_PLAYBACK_STATE.Play;
				else
					internalState = INTERNAL_PLAYBACK_STATE.Play;
					scheduleCallback();
				end
			elseif (internalState == INTERNAL_PLAYBACK_STATE.Play) then
				self.SetPlaybackState(Enum.PlaybackState.Playing);
				nextCheckpoint = tweenInfo.Time;

				if reverses then
					nextInternalState = INTERNAL_PLAYBACK_STATE.Reverse;
				else
					if repeats then
						nextInternalState = INTERNAL_PLAYBACK_STATE.Begin;
					else
						nextInternalState = INTERNAL_PLAYBACK_STATE.Done;
					end;
				end;
			elseif (internalState == INTERNAL_PLAYBACK_STATE.Reverse) then
				nextCheckpoint = tweenInfo.Time;

				if repeats then
					nextInternalState = INTERNAL_PLAYBACK_STATE.Begin;
				else
					nextInternalState = INTERNAL_PLAYBACK_STATE.Done;
				end;
			elseif (internalState == INTERNAL_PLAYBACK_STATE.Done) then
				self.SetPlaybackState(Enum.PlaybackState.Completed);
				self.CompletedEvent:Fire(Enum.PlaybackState.Completed);

				sync();
				reset();
				return;
			end;
		end;

		local function resume()
			scheduleCallback();

			isPlaying = true;
		end;

		timerCallbacks[self.UniqueId] = function(step)
			if (not isPlaying) then return; end;

			elapsed = elapsed + step;

			if (elapsed >= nextCheckpoint) then
				internalState = nextInternalState;

				scheduleCallback();
				elapsed = 0;
				return;
			end;
		end;

		self.__pauseTimer = pause;
		self.__resumeTimer = resume;
		self.__resetTimer = reset;

		self.__destroyTimer = function()
			timerCallbacks[self.UniqueId] = nil;
			RunService.Heartbeat:Wait();

			pause = nil;
			resume = nil;
			reset = nil;

			self.__pauseTimer = nil;
			self.__resumeTimer = nil;
			self.__resetTimer = nil;

			elapsed = nil;
			nextCheckpoint = nil;
			isPlaying = nil;
		end;
	end;

	return self;
end

function ReplicatedTween.new(object, tweenInfo, propertyTable)
	return construct(object, tweenInfo, propertyTable);
end

function ReplicatedTween:Create(object, tweenInfo, propertyTable)
	return construct(object, tweenInfo, propertyTable);
end

function ReplicatedTween:Cancel()
	self.__resetTimer();
	self.SetPlaybackState(Enum.PlaybackState.Cancelled);
	self.CompletedEvent:Fire(Enum.PlaybackState.Cancelled);

	tweenEvent:FireAllClients("Cancel", self.UniqueId);
end

function ReplicatedTween:Pause()
	tweenEvent:FireAllClients("Pause", self.UniqueId);

	self.SetPlaybackState(Enum.PlaybackState.Paused);
	self.__pauseTimer();
end

function ReplicatedTween:Play(specificClient)
	tweenEvent:FireAllClients("Play", self.UniqueId, {self.Instance, tweenInfoConvert(self.TweenInfo), self.PropertyTable});
	self.__resumeTimer();
end

function ReplicatedTween:Destroy()
	tweenEvent:FireAllClients("Destroy", self.UniqueId);
	self.__destroyTimer();

	self.CompletedEvent:Destroy();
	self.PlaybackStateChangedEvent:Destroy();

	setmetatable(self, nil);
	self = nil;
end

if RunService:IsClient() then
	local tweens = {};

	tweenEvent.OnClientEvent:Connect(function(action, tweenId, tweenInfo)
		if (not tweens[tweenId]) then
			tweenInfo[2] = tweenInfoConvert(tweenInfo[2]);
			tweens[tweenId] = TweenService:Create(unpack(tweenInfo));
		end;

		local tween = tweens[tweenId];
		if (action == "Play") then
			tween:Play();
		elseif (action == "Pause") then
			tween:Pause();
		elseif (action == "Cancel") then
			tween:Cancel();
		elseif (action == "Destroy") then
			tween:Destroy();
			tweens[tweenId] = nil;
		end;
	end);

	return true;
else
	return ReplicatedTween;
end;