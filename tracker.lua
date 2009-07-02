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

	local link = GetQuestLink(qid)
	if(link) then
		qid = tonumber(link:match("|Hquest:(%d+):"))
		iiWatcherDB.quests[qid] = true
	end
end)
hooksecurefunc('RemoveQuestWatch', function(qid)
	if(not loaded) then return end

	local link = GetQuestLink(qid)
	if(link) then
		qid = tonumber(link:match("|Hquest:(%d+):"))
		iiWatcherDB.quests[qid] = nil
	end
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

		loaded = true
		self:UnregisterEvent'ADDON_LOADED'
		self.ADDON_LOADED = nil

		if(not self:IsEventRegistered'QUEST_LOG_UPDATE') then self:SetScript('OnEvent', nil) end
	end
end

function frame:QUEST_LOG_UPDATE()
	for qid in next, iiWatcherDB.quests do
		AddQuestWatch(qid)
	end
	self:UnregisterEvent'QUEST_LOG_UPDATE'
	self.QUEST_LOG_UPDATE = nil

	if(not self:IsEventRegistered'ADDON_LOADED') then self:SetScript('OnEvent', nil) end
end

frame:RegisterEvent'ADDON_LOADED'
frame:RegisterEvent'QUEST_LOG_UPDATE'
