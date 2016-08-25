Toast = {}
Toast.toasts = {}

Toast.Init = function()
  setTimer(Toast.Process, 100, 1)
end

Toast.Add = function(time, message, ...)
  local msg = Translations.Translate(message)

  if #{...} > 0 then
    msg = string.format(msg, ...)
  end

  table.insert(Toast.toasts, {time = time, message = msg})

  if not GUI.IsLoading() then
    Toast.Process()
  else
    setTimer(Toast.Process, 100, 1)
  end
end

Toast.Process = function()
  if not GUI.IsLoading() then
    for i, v in ipairs(Toast.toasts) do
      GUI.ExecuteJavascript('Materialize.toast("'..v.message..'", '..v.time..');')
    end
    Toast.toasts = {}
  else
    setTimer(Toast.Process, 100, 1)
  end
end
