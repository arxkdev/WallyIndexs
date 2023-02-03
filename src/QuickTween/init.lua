local TweenService = game:GetService("TweenService");

return function(instance, tweenInfo, properties, completedCallback)
	local Tween = TweenService:Create(instance, tweenInfo, properties);
	Tween:Play();
	Tween.Completed:Once(function()
		if (completedCallback) then
			completedCallback();
		end;
		
		Tween:Destroy();
	end);

	return Tween;
end