-- Env. proxy. This way we most likely won't have to re-implement tons of stuff
-- every patch something changes.

local damnTextures = {
	['Interface\\MoneyFrame\\UI-GoldIcon'] = 'g',
	['Interface\\MoneyFrame\\UI-SilverIcon'] = 's',
	['Interface\\MoneyFrame\\UI-CopperIcon'] = 'c',
}

local env = setmetatable({
	GetAchievementInfo = function(...)
		if(select('#', ...) == 1) then
			local id, name, points, completed, month, day, year, description, flags, icon, rewardText = GetAchievementInfo(...)

			-- We might want to cache the following information, but who knows.
			local numCriteria = GetAchievementNumCriteria(id)
			local numCompleted = 0
			for i=1, numCriteria do
				local _, _, criteriaCompleted, _, _, _, flags = GetAchievementCriteriaInfo(id, i)
				if(criteriaCompleted and flags ~= 1) then
					numCompleted = numCompleted + 1
				end
			end

			if(numCriteria > 0) then
				description = ''
			end

			if(numCompleted > 0) then
				name = ('%s [%d/%d]'):format(name, numCompleted, numCriteria)
			end

			return id, name, points, completed, month, day, year, description, flags, icon, rewardText
		end
	end,

	GetAchievementCriteriaInfo = function(...)
		local description, type, completed, quantity, requiredQuantity, characterName, flags, assetID, quantityString, criteriaID, eligible = GetAchievementCriteriaInfo(...)
		quantityString = quantityString:gsub('|T(.-):.-|t', damnTextures):gsub('/', ' / ')

		return description, type, completed, quantity, requiredQuantity, characterName, flags, assetID, quantityString, criteriaID, eligible
	end,
}, {__index = _G})

setfenv(WatchFrame_DisplayTrackedAchievements, env)
