Inventory = {}
Inventory.data = nil
Inventory.isHidden = true
Inventory.isEnabled = true
Inventory.isInitalized = false
Inventory.slots = {}
Inventory.slotBtn = {}
Inventory.movinItem = -1

Inventory.Init = function()
  Binds.Bind("INVENTORY", "down", Inventory.Toggle)
  Inventory.screenX, Inventory.screenY = guiGetScreenSize()

  Inventory.RecalculateSize()
  Inventory.CreateSlotButtons()

  addEventHandler("onClientRender", root, Inventory.Draw)
end

Inventory.CreateSlotButtons = function()
  for i, v in pairs(Inventory.slots) do
    Inventory.slotBtn[i] = guiCreateButton (Inventory.posX + v.x - 1, Inventory.posY + v.y - 1, Inventory.itemsX + 1, Inventory.itemsY + 1, i, false)

    addEventHandler("onClientGUIMouseUp", Inventory.slotBtn[i], Inventory.OnSlotClickUp)
    addEventHandler("onClientGUIMouseDown", Inventory.slotBtn[i], Inventory.OnSlotClickDown)

    guiSetAlpha(Inventory.slotBtn[i], 0)
  end
end

Inventory.DestroySlotButtons = function()
  for i, v in pairs(Inventory.slotBtn) do
    removeEventHandler("onClientGUIMouseUp", v, Inventory.OnSlotClickUp)
    removeEventHandler("onClientGUIMouseDown", v, Inventory.OnSlotClickDown)

    destroyElement(v)
  end
end

Inventory.GetPlaceMouseOver = function()
  local mx,my = getCursorPosition()
  local screenX, screenY = guiGetScreenSize()
  if mx==false then Inventory.Hide() return end
  mx,my = mx*screenX, my*screenY
  for k, v in pairs(Inventory.slots) do
    if((Inventory.posX + v.x <= mx and Inventory.posX + v.x + Inventory.itemsX >= mx) and (Inventory.posY + v.y <= my and Inventory.posY + v.y+ Inventory.itemsY >= my))then
      return k
    end
  end
  return false
end

Inventory.OnSlotClickUp = function(button)
  local target = Inventory.GetPlaceMouseOver()
  if not target then target = Inventory.movinItem end

  if(Inventory.movinItem ~= -1 and Inventory.movinItem ~= target)then
    --[[
    local typ1 = items[target]["type"]
    local typ2 = items[movinItem]["type"]
    setElementData(lp, "InventorySlot"..target, typ2)
    setElementData(lp, "InventorySlot"..movinItem, typ1)
    items[target]["type"] = typ2
    items[movinItem]["type"] = typ1
    ]]

    local tmp = Inventory.data.data[target]
    Inventory.data.data[target] = Inventory.data.data[Inventory.movinItem]
    Inventory.data.data[Inventory.movinItem] = tmp
    -- TODO: sync with server
  end

  Inventory.movinItem = -1
end

Inventory.OnSlotClickDown = function(button)
  local src = nil
  for k,v in pairs(Inventory.slotBtn) do
    if v == source then
      src = k
      break
    end
  end
  if(src==nil)then return end

  if(button ~= "left") then
    --onItemUse(items[src]["type"], src)
    outputChatBox("ITEM BENUTZT")
    return
  end

  local data = Inventory.data.data[src]
  if data.itemId ~= "none" then
    local mX, mY = getCursorPosition()
    local sX, sY = guiGetScreenSize()
    mX, mY = mX * sX, mY * sY

    local pos = Inventory.slots[src]
    Inventory.dragX, Inventory.dragY = mX - (Inventory.posX + pos.x), mY - (Inventory.posY + pos.y)
    Inventory.movinItem = src
  end
end

Inventory.RecalculateSize = function()
  Inventory.border = 5
  Inventory.itemsX, Inventory.itemsY = 45, 45
  Inventory.itemsCells, Inventory.itemsRows = 7, 4
  Inventory.sizeX, Inventory.sizeY = Inventory.itemsCells*Inventory.itemsX + Inventory.itemsCells*Inventory.border + Inventory.border, Inventory.itemsRows*Inventory.itemsY + Inventory.itemsRows*Inventory.border + Inventory.border
  Inventory.posX, Inventory.posY = Inventory.screenX / 2 - Inventory.sizeX / 2, Inventory.screenY / 2 - Inventory.sizeY / 2
  Inventory.slotCount = Inventory.itemsCells * Inventory.itemsRows

  for i = 1, Inventory.slotCount do
    local x, y = Inventory.GetSlotPosition(i)
    Inventory.slots[i] = {["x"] = x, ["y"] = y}
  end
end

Inventory.GetSlotPosition = function(slot)
  local itemRow = 0
  local itemX = 0
  local itemY = 0
  local posInRow = 0
  local slot = slot - 1

  for row = 1, Inventory.itemsRows+1, 1 do
    if(Inventory.itemsCells*row > slot)then
      itemRow = row-1
      break
    end
  end
  posInRow = slot-itemRow*Inventory.itemsCells
  itemX = Inventory.border*posInRow + Inventory.itemsX*(posInRow) + Inventory.border
  itemY = Inventory.border*itemRow + Inventory.itemsY*itemRow + Inventory.border

  return itemX, itemY
end

addEvent("onInventorySync", true)

Inventory.OnSync = function(data)
  if source ~= localPlayer then return end

  Inventory.data = fromJSON(data)
  -- TODO: allow dynamic inventory sizes...

end
addEventHandler("onInventorySync", root, Inventory.OnSync)

Inventory.Draw = function()
  if not Inventory.isInitalized then return end
  if not Inventory.isEnabled then return end
  if Inventory.isHidden then return end

  dxDrawRectangle(Inventory.posX, Inventory.posY, Inventory.sizeX, Inventory.sizeY, tocolor(0, 0, 0, 200))

  for i,v in ipairs(Inventory.slots) do
    local data = Inventory.data.data[i]
    --data.itemAmount
    if data.itemId == "none" then
      dxDrawRectangle(Inventory.posX + v.x, Inventory.posY + v.y, Inventory.itemsX, Inventory.itemsY, tocolor(194, 194, 194, 200))
    else
      dxDrawRectangle(Inventory.posX + v.x, Inventory.posY + v.y, Inventory.itemsX, Inventory.itemsY, tocolor(194, 194, 194, 200))
      if Inventory.movinItem ~= i then
        dxDrawImage(Inventory.posX + v.x, Inventory.posY + v.y, Inventory.itemsX, Inventory.itemsY, "files/images/inventory/".. data.itemId ..".png")
      end
    end
  end

  if Inventory.movinItem ~= -1 then
    local data = Inventory.data.data[Inventory.movinItem]
    local mX, mY = getCursorPosition()
    local sX, sY = guiGetScreenSize()
    mX, mY = mX * sX, mY * sY

    dxDrawImage(mX - Inventory.dragX, mY - Inventory.dragY, Inventory.itemsX, Inventory.itemsY, "files/images/inventory/".. data.itemId ..".png")
  end
end

Inventory.Show = function()
  if Inventory.IsEnabled() then
    Inventory.isHidden = false
  end
end

Inventory.Hide = function()
  Inventory.isHidden = true
end

Inventory.IsVisible = function()
  return Inventory.isHidden
end

Inventory.Disable = function()
  Inventory.isEnabled = false
  Inventory.Hide()
end

Inventory.Enable = function()
  Inventory.isEnabled = true
end

Inventory.IsEnabled = function()
  return Inventory.isEnabled
end

Inventory.Toggle = function(_, state)
  if Inventory.IsVisible() then
    Inventory.Show()
  else
    Inventory.Hide()
  end
end
