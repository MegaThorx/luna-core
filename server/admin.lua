Admin = {}

Admin.ClickKill = function(button, state, player)
  if button == "right" and state == "down" then
    if getElementType(source) == "player" then
      if player == source then return end
      if ElementData.Get(player, "accounts.adminlevel") >= 10 then
        killPed(source, player)
        outputChatBox("Du wurdest von "..ElementData.Get(player, "accounts.username").."  gekillt!", source, 255, 0, 0)
        outputChatBox("Du hast "..ElementData.Get(source, "accounts.username").." gekillt!", player, 0, 255, 0)
      end
    end
  end
end
addEventHandler("onElementClicked", root, Admin.ClickKill)
