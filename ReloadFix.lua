-- After /reload the server can still believe you are talking to the same mailbox / auctioneer, and refuses to open it again
-- until you use a different one. On a reload, close every such session once the UI is back.
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(_, _, isLogin, isReload)
    if not isReload then return end
    C_Timer.After(0.5, function()
        local function try(fn, ...) if type(fn) == "function" then pcall(fn, ...) end end
        try(CloseMail)
        try(C_AuctionHouse and C_AuctionHouse.CloseAuctionHouse)
        try(CloseAuctionHouse)
        try(CloseMerchant)
        try(CloseTrainer)
        try(CloseGossip)
        try(C_GossipInfo and C_GossipInfo.CloseGossip)
        try(CloseTradeSkill)
        try(CloseBankFrame)
        try(CloseGuildBankFrame)
        try(CloseQuest)
        local pim = C_PlayerInteractionManager
        if pim and pim.ClearInteraction and Enum and Enum.PlayerInteractionType then
            for _, v in pairs(Enum.PlayerInteractionType) do pcall(pim.ClearInteraction, v) end
        end
    end)
end)
