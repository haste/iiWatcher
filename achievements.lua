-- Env. proxy. This way we most likely won't have to re-implement tons of stuff
-- every patch something changes.
local env = setmetatable({
	GetAchievementInfo = function(...)
		if(select('#', ...) == 1) then
			local id, name, points, completed, month, day, year, description, flags, icon, rewardText = GetAchievementInfo(...)

			-- We might want to cache the following information, but who knows.
			local numCriteria = GetAchievementNumCriteria(id)
			local completed = 0
			for i=1, numCriteria do
				local _, _, criteriaCompleted = GetAchievementCriteriaInfo(id, i)
				if(criteriaCompleted) then
					completed = completed + 1
				end
			end

			return id, ('%s [%d/%d]'):format(name, completed, numCriteria), points, completed, month, day, year, description, flags, icon, rewardText
		end
	end,
}, {__index = _G})

setfenv(WatchFrame_DisplayTrackedAchievements, env)
