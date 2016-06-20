GUI = {}
GUI.handlers = {}
GUI.isReady = false

GUI.Init = function()
  GUI.browser = createBrowser(screenX, screenY, true, true)

  addEventHandler("onClientClick", root,
  	function(button, state)
  	if state == "down" then
  		injectBrowserMouseDown(GUI.browser, button)
  	else
  		injectBrowserMouseUp(GUI.browser, button)
  	end
  end)

  addEventHandler("onClientKey", root, function(button)
  	if button == "mouse_wheel_down" then
  		injectBrowserMouseWheel( GUI.browser, -40, 0)
  	elseif button == "mouse_wheel_up" then
  		injectBrowserMouseWheel( GUI.browser, 40, 0)
  	end
  end)

  addEventHandler ( "onClientCursorMove" , root , function ( relativeX , relativeY , absoluteX , absoluteY )
  	injectBrowserMouseMove ( GUI.browser , absoluteX , absoluteY )
  end  )

  return GUI.browser
end

GUI.InitRendering = function()
  local rst = loadBrowserURL(GUI.browser, "http://mta/" .. getResourceName(getThisResource()) .. "/files/html/index.html")
  if(Config.Get("browserdebugging") and getPlayerName(localPlayer) == "MegaThorx")then
    toggleBrowserDevTools(GUI.browser, true)
  end
  setBrowserAjaxHandler(GUI.browser, "ajax.htm", GUI.AjaxHandler)
  addEventHandler("onClientRender", root, GUI.Render)
end

GUI.InitReady = function()
  GUI.isReady = true
end

GUI.Render = function()
  dxSetBlendMode("add")
  dxDrawImage(0, 0, screenX, screenY, GUI.browser, 0, 0,  0, tocolor(255, 255, 255, 255), true)
  dxSetBlendMode("blend")
end

GUI.ExecuteJavascript = function(...)
  executeBrowserJavascript(GUI.browser, ...)
end

GUI.AjaxHandler = function(get, post)
  if get then
    for k,v in pairs(get) do
      if GUI.handlers[k] then
        return GUI.handlers[k](v, post)
      end
    end
  end
end

GUI.AddAjaxGetHandler = function(key, func)
  if not GUI.handlers[key] then
    GUI.handlers[key] = func
    return true
  end
  return false
end

GUI.RemoveAjaxGetHandler = function(key)
    if GUI.handlers[key] then
      GUI.handlers[key] = nil
      return true
    end
    return false
end
