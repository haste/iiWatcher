local loaded

-- Mmmm, smells like laziness
if(not iiWatcherDB) then
	iiWatcherDB = {
		achievements = {},
		quests = {},
	}
end

-- Still lazy...
hooksecurefunc('AddTrackedAchievement', function(aid)
	if(not loaded) then return end
	iiWatcherDB.achievements[aid] = true
end)
hooksecurefunc('RemoveTrackedAchievement', function(aid)
	if(not loaded) then return end
	iiWatcherDB.achievements[aid] = nil
end)

hooksecurefunc('AddQuestWatch', function(qid)
	if(not loaded) then return end
	iiWatcherDB.quests[qid] = true
end)
hooksecurefunc('RemoveQuestWatch', function(qid)
	if(not loaded) then return end
	iiWatcherDB.quests[qid] = nil
end)

local frame = CreateFrame'Frame'
frame:SetScript('OnEvent', function(self, event, ...)
	self[event](self, event, ...)
end)

function frame:ADDON_LOADED(event, addon)
	if(addon == 'iiWatcher') then
		-- We can track these at login.
		for aid in next, iiWatcherDB.achievements do
			AddTrackedAchievement(aid)
		end

		WatchFrame_Update()
		loaded = true
	end
end

function frame:QUEST_LOG_UPDATE()
	for qid in next, iiWatcherDB.quests do
		AddQuestWatch(qid)
	end
	frame:UnregisterEvent'QUEST_LOG_UPDATE'
end

frame:RegisterEvent'ADDON_LOADED'
frame:RegisterEvent'QUEST_LOG_UPDATE'
