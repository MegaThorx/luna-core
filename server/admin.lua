Admin = {}

Admin.ClickKill = function(button, state, player)
  if button == "right" and state == "down" then
    if getElementType(source) == "player" then
      if ElementData.Get(player, "adminlevel") >= 10 then
        killPed(source, player)
        outputChatBox("Du wurdest von "..ElementData.Get(player, "username").."  gekillt!", source, 125, 0, 0)
        outputChatBox("Du hast "..ElementData.Get(source, "username").." gekillt!", player, 0, 125, 0)
      end
    end
  end
end
addEventHandler("onElementClicked", root, Admin.ClickKill)
