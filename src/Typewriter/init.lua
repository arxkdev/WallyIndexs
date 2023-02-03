local LocalizationService = game:GetService("LocalizationService");
local Players = game:GetService("Players");

--// Constants
local SOURCE_LOCALE = "en";
local CANCEL = false;

--// Variables
local player = Players.LocalPlayer
local translator = nil
local Typewriter = { }

--// Get the translating
pcall(function()
	translator = LocalizationService:GetTranslatorForPlayerAsync(player);
end)

--// CHeck if the translator is valid
if not translator then
	pcall(function()
		translator = LocalizationService:GetTranslatorForLocaleAsync(SOURCE_LOCALE);
	end);
end
 
local DefaultConfig = {
	DelayTime = 0.02,
	ExtraDelayOnSpace = false
};
 
function Typewriter.configure(configurations)
	for key, value in pairs(DefaultConfig) do
		local newValue = configurations[key];
		
		if (newValue ~= nil) then
			DefaultConfig[key] = newValue;
		else
			warn(key .. " is not a valid configuration for TypeWriter module");
		end;
	end;
end
 
function Typewriter.typeWrite(guiObject, text, delayBetweenChars, originalTextBeforeRichText)
	local originalTextBeforeRichTextLength = string.len(originalTextBeforeRichText);
	guiObject.Visible = true;
	guiObject.AutoLocalize = false;
	
	local displayText = text;

	if (translator) then
		displayText = translator:Translate(guiObject, text);
	end;

	displayText = displayText:gsub("<br%s*/>", "\n");
	displayText:gsub("<[^<>]->", "");

	guiObject.Text = displayText;

	local index = 0;
	
	for first, last in utf8.graphemes(displayText) do
		index = index + 1;
		guiObject.MaxVisibleGraphemes = index;

		-- Incase it uses richtext, we need to determine the length of the string, and stop at that
		if (index >= originalTextBeforeRichTextLength) then
			break;
		end;

		task.wait(delayBetweenChars);
	end;
end

function Typewriter.cancel()
	CANCEL = true;
end
 
return Typewriter