Scoreboard = {}
Scoreboard.isHidden = true
Scoreboard.scrollPos = 1
Scoreboard.scrollSpeed = 2
Scoreboard.maxPerSite = 20


Scoreboard.Init = function()
  Binds.Bind("SCOREBOARD", "both", Scoreboard.Toggle)
  Binds.Bind("SCOREBOARD_UP", "down", Scoreboard.ScrollUp)
  Binds.Bind("SCOREBOARD_DOWN", "down", Scoreboard.ScrollDown)

  addEventHandler("onClientRender", root, Scoreboard.Draw)
end


Scoreboard.Draw = function()
  if Scoreboard.isHidden then return end



  --Time.FormatPlaytime(Player)
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

Scoreboard.GetPlayersOnline = function()
	local players = #getElementsByType ( "player" )
	return players
end

Scoreboard.Show = function()
  Scoreboard.isHidden = false
end

Scoreboard.Hide = function()
  Scoreboard.isHidden = true
end

Scoreboard.IsVisible = function()
  return Scoreboard.isHidden
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
