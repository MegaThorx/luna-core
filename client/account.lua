local isBlocked = false

GUI.AddAjaxGetHandler("login", function(k, post)
  if isBlocked then return end
  isBlocked = true

  local username = HTML.Decode(post["username"])
  local password = HTML.Decode(post["password"])
  local autologin = false
  if post["autologin"] then
    autologin = true
  end

  if(username == "" or password == "")then
    -- TODO add errors
  else
    triggerServerEvent("tryLogin", localPlayer, username, password, autologin)
  end
end)

GUI.AddAjaxGetHandler("register", function(k, post)
  if isBlocked then return end
  isBlocked = true

  local username = HTML.Decode(post["username"])
  local email = HTML.Decode(post["email"])
  local password = HTML.Decode(post["password"])
  local password2 = HTML.Decode(post["password2"])
  local rules = HTML.Decode(post["rules"])

  if(username == "" or email == "" or password == "" or password2 == ""  or not rules)then
    -- TODO add errors
  else
    triggerServerEvent("tryRegister", localPlayer, username, email, password, password2, rules)
  end
end)


addEvent("showAccountLogin", true)
addEvent("showAccountRegister", true)
addEvent("successAccountLogin", true)
addEvent("errorAccountLogin", true)
addEvent("errorAccountRegister", true)
addEvent("setAutologin", true)
addEvent("removeAutologin", true)

addEventHandler("showAccountRegister", root, function()
  GUI.ExecuteJavascript('UIkit.modal("#register-window").show();')

  Cursor.Show()
  Cursor.BlockBinds()
end)

addEventHandler("showAccountLogin", root, function()
  GUI.ExecuteJavascript('UIkit.modal("#login-window").show();')

  Cursor.Show()
  Cursor.BlockBinds()
end)


addEventHandler("successAccountLogin", root, function()
  isBlocked = false
  Cursor.Hide()
  Cursor.UnblockBinds()
  GUI.ExecuteJavascript('UIkit.modal("#login-window").hide();')
  GUI.ExecuteJavascript('UIkit.modal("#register-window").hide();')

  bindKey("m", "down", function()
    if not Cursor.IsShowing() then
      Cursor.Show()
    else
      Cursor.Hide()
    end
  end)

  GUI.LoadPage("gui_new")

end)

addEventHandler("setAutologin", root, function(token)
  if fileExists("autologin.dat") then
    fileDelete("autologin.dat")
  end

  local autologin = fileCreate("autologin.dat")
  fileWrite(autologin, token)
  fileClose(autologin)
end)

addEventHandler("removeAutologin", root, function()
  if fileExists("autologin.dat") then
    fileDelete("autologin.dat")
  end
end)

addEventHandler("errorAccountLogin", root, function(error)
  isBlocked = false
end)

addEventHandler("errorAccountRegister", root, function(error)
  outputChatBox(error)
  isBlocked = false
end)


addCommandHandler("showit", function()
  GUI.ExecuteJavascript('UIkit.modal("#register-window").show();')

  Cursor.Show()
end)

addCommandHandler("showit2", function()
  GUI.ExecuteJavascript('UIkit.modal("#login-window").show();')

  Cursor.Show()
end)
