SCFToolkit = {
    MAX_DEPTH = 4
}

---toggle traffic system animation/ai
SCFToolkit.toggleTrafficSystemEnabled = function()
    g_currentMission.trafficSystem:setEnabled(not g_currentMission.trafficSystem.enabled)
end

---removes all current vehicles spawned
SCFToolkit.resetTrafficSystem = function()
    g_currentMission.trafficSystem:reset()
end

---toggle whether a shop item can be leased or not
---@param index number
SCFToolkit.toggleItemLeasing = function(index)
    g_storeManager.items[index].allowLeasing = not g_storeManager.items[index].allowLeasing
end

---toggle whether to show item in shop or not
---@param index number
SCFToolkit.toggleShowItem = function(index)
    g_storeManager.items[index].showInStore = not g_storeManager.items[index].showInStore
end

---toggle whether item in shop can be sold or not
---@param index number
SCFToolkit.toggleItemCanBeSold = function(index)
    g_storeManager.items[index].canBeSold = not g_storeManager.items[index].canBeSold
end

---set price of item in shop
---@param index number
---@param price number
SCFToolkit.setItemPrice = function(index, price)
    g_storeManager.items[index].price = price
end

-- TODO - some farms can be empty, need to check if its in use or not .. [loop()->return new table]
---@return table
SCFToolkit.getFarms = function()
    return g_farmManager.farms
end

---set maximum amount of loan a farm can have
---@param index number
---@param value number
SCFToolkit.setFarmMaxLoan = function(index, value)
    g_farmManager.farms[index].MAX_LOAN = value
end

---set farm money
---@param index number
---@param value number
SCFToolkit.setFarmMoney = function(index, value)
    g_farmManager.farms[index].money = value
end

---[TEST] set maximum # of farms
---@param value number
SCFToolkit.setMaxFarms = function(value)
    g_farmManager.MAX_FARM_ID = value
    g_farmManager.MAX_NUM_FARMS = value
end

---find a farm by name
---@param name string
---@return table Returns nil if not found
SCFToolkit.getFarmByName = function(name)
    for i, v in g_farmManager.farms do
        if g_farmManager.farms[i].name == name then
            return g_farmManager.farms[i]
        end
    end
    return nil
end

function SCFToolkit:loadMap() end
function SCFToolkit:update() end
function SCFToolkit:draw() end
function SCFToolkit:deleteMap() end

addModEventListener(SCFToolkit)

SCFToolkit.IClass = IClass
SCFToolkit.log30_Class = log30_Class
SCFToolkit.InspectTable = InspectTable

DebugUtil.SCFToolkit = SCFToolkit