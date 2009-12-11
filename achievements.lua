-- Env. proxy. This way we most likely won't have to re-implement tons of stuff
-- every patch something changes.
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

			if(numCompleted > 0) then
				name = ('%s [%d/%d]'):format(name, numCompleted, numCriteria)
			end

			return id, name, points, completed, month, day, year, description, flags, icon, rewardText
		end
	end,
}, {__index = _G})

setfenv(WatchFrame_DisplayTrackedAchievements, env)
