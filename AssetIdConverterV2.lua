local assetPropertyNames = {"Texture", "TextureId", "SoundId", "MeshId", "SkyboxUp", "SkyboxLf", "SkyboxBk", "SkyboxRt", "SkyboxFt", "SkyboxDn", "PantsTemplate", "ShirtTemplate", "Graphic", "Frame", "ImageLabel", "GuiMain", "Image", "LinkedSource", "AnimationId"}
local variations = {"http://www%.roblox%.com/asset/%?id=", "http://www%.roblox%.com/asset%?id=", "http://%.roblox%.com/asset/%?id=", "http://%.roblox%.com/asset%?id="}

function GetDescendants(o)
	local allObjects = {}
	function FindChildren(Object)
		for _,v in pairs(Object:GetChildren()) do
			table.insert(allObjects,v)
			FindChildren(v)
		end
	end
	FindChildren(o)
	return allObjects
end

local replacedProperties = 0--Amount of properties changed
local replacedSourceCodes = 0

for i, v in pairs(GetDescendants(game)) do
	if v.ClassName == 'Script' or v.ClassName == 'LocalScript' then
		local SourceCode = v.Source
		if SourceCode then
			for _, variation in pairs(variations) do
				local String, Number = string.gsub(SourceCode, variation, "http://www%.morblox%.us/asset/%?id=")
				SourceCode = String
				if Number > 0 then
					replacedSourceCodes = replacedSourceCodes + Number
				end
			end
			v.Source = SourceCode
		end
	end
	
	for _, property in pairs(assetPropertyNames) do
		pcall(function()
			if v[property] and not v:FindFirstChild(property) then --Check for property, make sure we're not getting a child instead of a property
				assetText = string.lower(v[property])
				for _, variation in pairs(variations) do
					v[property], matches = string.gsub(assetText, variation, "http://www%.morblox%.us/asset/%?id=")
					if matches > 0 then
						replacedProperties = replacedProperties + 1
						print("Replaced " .. property .. " asset link for " .. v.Name)
						break
					end
				end
			end
		end)
	end
end

print("Updated " .. replacedProperties .. " AssetIds")
print("Changed " .. replacedSourceCodes .. " lines of code")