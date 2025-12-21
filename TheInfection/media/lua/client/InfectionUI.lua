-- The Onslaught - UI Timer Display
require "InfectionConfig"
require "InfectionUtils"
require "InfectionClient"
require "ISUI/ISPanel"

InfectionUI = ISPanel:derive("InfectionUI")

-- Create UI instance
function InfectionUI:new(x, y, width, height)
    local o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.backgroundColor = {r=0, g=0, b=0, a=0.5}
    o.borderColor = {r=1, g=1, b=1, a=0.8}
    return o
end

-- Initialize UI
function InfectionUI:initialise()
    ISPanel.initialise(self)
end

-- Render UI
function InfectionUI:render()
    ISPanel.render(self)
    
    if not InfectionConfig.ShowUITimer then
        return
    end
    
    local player = getSpecificPlayer(0)
    if not player then return end
    
    -- Draw background
    self:drawRect(0, 0, self:getWidth(), self:getHeight(), self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b)
    self:drawRectBorder(0, 0, self:getWidth(), self:getHeight(), self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b)
    
    local textY = 10
    local textX = 10
    
    -- Display appropriate timer
    if not InfectionClient.onslaughtTriggered then
        -- Setup phase timer
        local timeStr = InfectionUtils.formatTime(InfectionClient.timeUntilOnslaught)
        self:drawText("ONSLAUGHT IN: " .. timeStr, textX, textY, 1, 1, 0.2, 1, UIFont.Medium)
        self:drawText("Prepare your defenses!", textX, textY + 20, 1, 1, 1, 1, UIFont.Small)
        
    elseif not InfectionClient.onslaughtComplete then
        -- Active onslaught timer
        local timeStr = InfectionUtils.formatTime(InfectionClient.timeRemainingInOnslaught)
        self:drawText("ONSLAUGHT: " .. timeStr, textX, textY, 1, 0.2, 0.2, 1, UIFont.Medium)
        self:drawText("Wave: " .. InfectionClient.currentWave, textX, textY + 20, 1, 1, 1, 1, UIFont.Small)
        self:drawText("Hold the line!", textX, textY + 35, 1, 1, 1, 1, UIFont.Small)
        
    else
        -- Post-onslaught
        self:drawText("ONSLAUGHT SURVIVED", textX, textY, 0.2, 1, 0.2, 1, UIFont.Medium)
        self:drawText("Stragglers remain...", textX, textY + 20, 1, 1, 1, 1, UIFont.Small)
    end
end

-- Global UI instance
InfectionUI.instance = nil

-- Create and add UI to screen
function InfectionUI.createUI()
    if InfectionUI.instance then
        return
    end
    
    local screenWidth = getCore():getScreenWidth()
    local screenHeight = getCore():getScreenHeight()
    
    -- Position in top-right corner
    local uiWidth = 250
    local uiHeight = 70
    local x = screenWidth - uiWidth - 20
    local y = 20
    
    InfectionUI.instance = InfectionUI:new(x, y, uiWidth, uiHeight)
    InfectionUI.instance:initialise()
    InfectionUI.instance:addToUIManager()
    InfectionUI.instance:setVisible(true)
    
    InfectionUtils.log("UI created")
end

-- Initialize UI on game start
function InfectionUI.onGameStart()
    InfectionUI.createUI()
end

-- Initialize
Events.OnGameStart.Add(InfectionUI.onGameStart)

return InfectionUI
