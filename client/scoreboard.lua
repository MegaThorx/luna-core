Scoreboard = {}
Scoreboard.isHidden = true
Scoreboard.isEnabled = true
Scoreboard.scrollPos = 1
Scoreboard.scrollSpeed = 2
Scoreboard.maxPerSite = 20
Scoreboard.size = {x = 800, y = 400}
Scoreboard.data = {
  {label = "PLAYER", func = Player.GetUsername, s = 3.5},
  {label = "SOCIALSTATE", func = Player.GetSocialState, s = 2.5},
  {label = "PLAYTIME", func = Player.GetPlaytimeFormated, s = 2.5},
  {label = "PHONENUMBER", func = Player.GetPhoneNumber, s = 2},
  {label = "FACTION", func = Player.GetFactionName, s = 2.5},
  {label = "PING", func = Player.GetPing, s = 2}
}

Scoreboard.Init = function()
  Binds.Bind("SCOREBOARD", "both", Scoreboard.Toggle)
  Binds.Bind("SCOREBOARD_UP", "down", Scoreboard.ScrollUp)
  Binds.Bind("SCOREBOARD_DOWN", "down", Scoreboard.ScrollDown)

  Scoreboard.CalculatePositions()
  Scoreboard.renderTarget = dxCreateRenderTarget(Scoreboard.size.x, Scoreboard.size.y, true)

  addEventHandler("onClientRender", root, Scoreboard.Draw)
end

Scoreboard.CalculatePositions = function()
  local divider = 0
  for k, v in pairs(Scoreboard.data) do
    divider = divider + v.s
  end

  local part = Scoreboard.size.x / divider
  local lastpos = 0

  for k, v in pairs(Scoreboard.data) do
    Scoreboard.data[k].sx = lastpos
    lastpos = lastpos + v.s * part
    Scoreboard.data[k].sy = 15
		Scoreboard.data[k].x = lastpos
		Scoreboard.data[k].y = 35
  end


end

Scoreboard.Draw = function()
  if Scoreboard.isHidden then return end
  local sX, sY = guiGetScreenSize()

  dxSetRenderTarget(Scoreboard.renderTarget, true)
  dxDrawRectangle( 0, 0, Scoreboard.size.x, Scoreboard.size.y, tocolor(50,50,50,255) )

  for k, v in pairs(Scoreboard.data)do
    dxDrawRectangle ( v.sx, v.sy, v.x-v.sx, v.y-v.sy, tocolor(75,75,75,255) )
  end

  for k, v in pairs(Scoreboard.data)do
  	local x, y = v.x-v.sx, v.y-v.sy
  	local height = dxGetFontHeight(1.2 ,"default")
  	y = y - height
  	dxDrawText(Translations.Translate(v.label), v.sx+x/2, v.sy+y/2, v.sx+x/2, v.sy+y/2, tocolor(50,200,50,255), 1.2, "default", "left", "top", false)
  end

  local startOffset = 25
  for _,player in ipairs(Scoreboard.GetPlayers()) do
    for k, v in pairs(Scoreboard.data)do
      local x, y = v.x-v.sx, v.y-v.sy
      local height = dxGetFontHeight(1 ,"default")
      y = y - height
      dxDrawText(tostring(v.func(player)), v.sx+x/2, v.sy+y/2 + startOffset, v.sx+x/2, v.sy+y/2 + startOffset, tocolor(50,200,50,255), 1, "default", "left", "top", false)
    end
  end




  dxSetRenderTarget()

  dxDrawImage(sX/2 - Scoreboard.size.x/2, sY/2 - Scoreboard.size.y/2, Scoreboard.size.x, Scoreboard.size.y, Scoreboard.renderTarget, 0, 0, 0, tocolor(255, 255, 255, 200))
end


Scoreboard.ScrollUp = function()
  Scoreboard.scrollPos = Scoreboard.scrollPos - Scoreboard.scrollSpeed
  if Scoreboard.scrollPos < 1 then Scoreboard.scrollPos = 1 end
end

Scoreboard.ScrollDown = function()
  Scoreboard.scrollPos = Scoreboard.scrollPos + Scoreboard.scrollSpeed
	local pls = Scoreboard.GetPlayersOnline()
	if Scoreboard.scrollPos > pls-Scoreboard.maxPerSite+1 then Scoreboard.scrollPos = pls-Scoreboard.maxPerSite+1 end
	if pls < Scoreboard.maxPerSite then Scoreboard.scrollPos = 1 end
end


Scoreboard.GetPlayers = function()
	local players = getElementsByType ( "player" )
	table.sort(players, function(b, a)
		local fa = Player.GetFaction(a)
		local fb = Player.GetFaction(b)
		if not fa then fa = 0 end
		if not fb then fb = 0 end
		return fa > fb
	end)
	return players
end


Scoreboard.GetPlayersOnline = function()
	local players = #getElementsByType ( "player" )
	return players
end

Scoreboard.Show = function()
  if Scoreboard.IsEnabled() then
    Scoreboard.isHidden = false
  end
end

Scoreboard.Hide = function()
  Scoreboard.isHidden = true
end

Scoreboard.IsVisible = function()
  return Scoreboard.isHidden
end

Scoreboard.Disable = function()
  Scoreboard.isEnabled = false
  Scoreboard.Hide()
end

Scoreboard.Enable = function()
  Scoreboard.isEnabled = true
end

Scoreboard.IsEnabled = function()
  return Scoreboard.isEnabled
end

Scoreboard.Toggle = function(_, state)
  if state then
    if state == "down" then
      Scoreboard.Show()
    else
      Scoreboard.Hide()
    end
  else
    if Scoreboard.IsVisible() then
      Scoreboard.Show()
    else
      Scoreboard.Hide()
    end
  end
end
