local isBlocked = false
Account = {}

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

Account.BlurStart = function()
  Account.x, Account.y = guiGetScreenSize()
  Account.shader = dxCreateShader("files/shaders/blur.fx")

  if not Account.shader then
    outputDebugString("Failed to create blur shader")
    return false
  end

  Account.renderTarget = dxCreateRenderTarget(Account.x, Account.y, true)

  if not Account.renderTarget then
    destroyElement(Account.shader)
    Account.shader = false
    outputDebugString("Failed to create a render target for blur shader")
    return false
  end

  Account.screenSource = dxCreateScreenSource(Account.x, Account.y)

  if not Account.screenSource then
    destroyElement(Account.renderTarget)
    destroyElement(Account.shader)
    Account.shader = false
    Account.renderTarget = false
    outputDebugString("Failed to create a screen source for blur shader")
    return false
  else
    dxSetShaderValue(Account.shader, 'texture0', Account.renderTarget)
  end
  Account.strength = 99
  Account.alpha = 150
  addEventHandler("onClientRender", root, Account.BlurRender, true, "high")
  return true
end

Account.BlurEnd = function()
  removeEventHandler("onClientRender", root, Account.BlurRender)
end

Account.BlurRender = function()
  -- Update screen source
  dxUpdateScreenSource(Account.screenSource, true)

  -- Switch rendering to our render target
  dxSetRenderTarget(Account.renderTarget, false)

  -- Prepare render target content
  dxDrawImage(0, 0, Account.x, Account.y, Account.screenSource)

  -- Repeat shader align on the image inside the render target
  for i = 0, 8 do
    dxSetShaderValue(Account.shader, 'factor', 0.0020 * Account.strength + (i / 8 * 0.001 * Account.strength))
    dxDrawImage(0, 0, Account.x, Account.y, Account.shader)
  end

  -- Restore the default render target
  dxSetRenderTarget()

  dxDrawImage(0, 0, Account.x, Account.y, Account.renderTarget, 0, 0, 0, tocolor(255, 255, 255, Account.alpha))
end

addEvent("showAccountLogin", true)
addEvent("showAccountRegister", true)
addEvent("successAccountLogin", true)
addEvent("errorAccountLogin", true)
addEvent("errorAccountRegister", true)
addEvent("setAutologin", true)
addEvent("removeAutologin", true)

addEventHandler("showAccountRegister", root, function()
  outputChatBox("Hello World2!")
  GUI.ExecuteJavascript('$("#modal-register").openModal({dismissible: false, opacity: 0.0, in_duration: 0});')
  --GUI.ExecuteJavascript('UIkit.modal("#register-window").show();')
  setCameraMatrix(-1331.3973388672, 792.6044921875, 97.74829864502, -1332.3908691406, 792.50506591797, 97.692855834961, 0, 70)
  Account.BlurStart()
  Cursor.Show()
  Cursor.BlockBinds()
end)

addEventHandler("showAccountLogin", root, function()
  outputChatBox("Hello World!")
  GUI.ExecuteJavascript('$("#modal-login").openModal({dismissible: false, opacity: 0.0, in_duration: 0});')
  setCameraMatrix(-1331.3973388672, 792.6044921875, 97.74829864502, -1332.3908691406, 792.50506591797, 97.692855834961, 0, 70)
  Account.BlurStart()

  Cursor.Show()
  Cursor.BlockBinds()
end)



addEventHandler("successAccountLogin", root, function()
  isBlocked = false
  Cursor.Hide()
  Cursor.UnblockBinds()
  Account.BlurEnd()
  GUI.ExecuteJavascript('UIkit.modal("#login-window").hide();')
  GUI.ExecuteJavascript('UIkit.modal("#register-window").hide();')

  bindKey("m", "down", function()
    if not Cursor.IsShowing() then
      Cursor.Show()
    else
      Cursor.Hide()
    end
  end)

  GUI.LoadPage("gui")
  Toast.Add(4000, "SUCCESSFULLY_LOGGEDIN")
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
  Toast.Add(4000, error)
end)

addEventHandler("errorAccountRegister", root, function(error)
  isBlocked = false
  Toast.Add(4000, error)
end)
