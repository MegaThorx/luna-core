GUI = {}
GUI.handlers = {}
GUI.closeHandlers = {}
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

  GUI.AddAjaxGetHandler("window", function(_, data)
    if GUI.closeHandlers[data["window"]] then
      return GUI.closeHandlers[data["window"]]()
    end
  end)

  return GUI.browser
end

GUI.InitRendering = function()
  loadBrowserURL(GUI.browser, "http://mta/" .. getResourceName(getThisResource()) .. "/files/html/login.html")
  if(Config.Get("browserdebugging") and getPlayerName(localPlayer) == "MegaThorx")then
    toggleBrowserDevTools(GUI.browser, true)
  end
  setBrowserAjaxHandler(GUI.browser, "ajax.htm", GUI.AjaxHandler)
  addEventHandler("onClientRender", root, GUI.Render)
end


GUI.LoadPage = function(page)
  loadBrowserURL(GUI.browser, "http://mta/" .. getResourceName(getThisResource()) .. "/files/html/"..page..".html")
end

GUI.GetCurrentPage = function()
  local url = getBrowserURL(GUI.browser)
  local page = string.gsub(url, "http://mta/" .. getResourceName(getThisResource()) .. "/files/html/", "")
  page = string.gsub(page, ".html", "")
  if isBrowserLoading(GUI.browser) then page = "" end
  return page
end

GUI.IsLoading = function()
  return isBrowserLoading(GUI.browser)
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


GUI.AddWindowCloseHandler = function(key, func)
  if not GUI.closeHandlers[key] then
    GUI.closeHandlers[key] = func
    return true
  end
  return false
end

GUI.RemoveWindowCloseHandler = function(key)
    if GUI.closeHandlers[key] then
      GUI.closeHandlers[key] = nil
      return true
    end
    return false
end
