Bank = {}
Bank.atmMarkers = {}

Bank.Init = function()
  for i,v in ipairs(getElementsByType("object", root, true)) do
    if getElementModel(v) == 2942 then
      Bank.CreateAtmMarker(v)
    end
  end

  addEventHandler("onClientElementStreamIn", root, Bank.StreamIn)
  addEventHandler("onClientElementStreamOut", root, Bank.StreamOut)
end

Bank.StreamIn = function()
  if getElementModel(source) == 2942 then
    Bank.CreateAtmMarker(source)
  end
end

Bank.StreamOut = function()
  if getElementModel(source) == 2942 then
    if getElementData(source, "marker") then
      destroyElement(getElementData(source, "marker"))
    end
  end
end

Bank.CreateAtmMarker = function(element)

  local marker = createMarker(0, 0, 0, "cylinder", 1)
  attachElements(marker, element, 0, -1, -1)
  setElementData(element, "marker", marker)
  setObjectBreakable(element, false)

  addEventHandler("onClientMarkerHit", marker, function(player)
    local _, _, mz = getElementPosition(this)
    local _, _, pz = getElementPosition(player)
    local mz = mz - pz
    if mz < 0 then mz = mz * -1 end
    if mz > 2 then return end
    if player ~= localPlayer then return end
    GUI.ExecuteJavascript('openModal("#modal-atm");')
    triggerServerEvent("getAtmBalance", localPlayer)

    Cursor.Show()
    Cursor.BlockBinds()
  end)
end

addEvent("setAtmBalance", true)
addEventHandler("setAtmBalance", root, function(amount)
  GUI.ExecuteJavascript('$("#atm-amount").val(""); $("#atm-amount").removeClass("valid"); $($("#atm-amount").parent().children()[1]).removeClass("active");')
  GUI.ExecuteJavascript('$("#atm-balance").text("'..Formatting.Currency(amount)..'")')
end)

GUI.AddWindowCloseHandler("modal-atm", function()
  Cursor.Hide()
  Cursor.UnblockBinds()
end)

GUI.AddAjaxGetHandler("atmPayout", function(v, data)
  local amount = tostring(data["amount"])
  if amount == tostring(tonumber(amount)) then
    amount = tonumber(amount)
    if amount > 0 then
      triggerServerEvent("takeAtmMoney", localPlayer, amount)
    end
  end
end)

GUI.AddAjaxGetHandler("atmPayin", function(v, data)
  local amount = tostring(data["amount"])
  if amount == tostring(tonumber(amount)) then
    amount = tonumber(amount)
    if amount > 0 then
      triggerServerEvent("giveAtmMoney", localPlayer, amount)
    end
  end
end)
