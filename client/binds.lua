Binds = {}
Binds.keys = {}
Binds.validKeys ={ "mouse1", "mouse2", "mouse3", "mouse4", "mouse5", "mouse_wheel_up", "mouse_wheel_down", "arrow_l", "arrow_u",
                   "arrow_r", "arrow_d", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k",
                   "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "num_0", "num_1", "num_2", "num_3", "num_4", "num_5",
                   "num_6", "num_7", "num_8", "num_9", "num_mul", "num_add", "num_sep", "num_sub", "num_div", "num_dec", "num_enter", "F1", "F2", "F3", "F4", "F5",
                   "F6", "F7", "F8", "F9", "F10", "F11", "F12", "escape", "backspace", "tab", "lalt", "ralt", "enter", "space", "pgup", "pgdn", "end", "home",
                   "insert", "delete", "lshift", "rshift", "lctrl", "rctrl", "[", "]", "pause", "capslock", "scroll", ";", ",", "-", ".", "/", "#", "\\", "=" }

Binds.Init = function()
  Binds.LoadBinds()
end


Binds.LoadBinds = function()
  Binds.keys = {}

  if not fileExists("files/binds.ini") then
    return false
  end

  local file = fileOpen("files/binds.ini", true)
  local tmp = fileRead(file, fileGetSize(file))
  local tmp = split(tmp, '\n')

  for k,v in pairs(tmp) do
    local key = split(v, '=')

    if Binds.keys[key[1]] then
      Debug.Log("Duplicated key entry for %s", key[1])
    else
      if Binds.IsKeyValid(key[2]) then
        Binds.keys[string.upper(key[1])] = string.lower(key[2])
      else
        Debug.Log("Invalid key '%s' for %s", key[2], key[1])
      end
    end
  end

  fileClose(file)
end

Binds.IsKeyValid = function(key)
  for k,v in pairs(Binds.validKeys) do
    if v == string.lower(key) then
      return true
    end
  end
  return false
end


Binds.GetKey = function(key)
  return Binds.keys[string.upper(key)]
end

Binds.Bind = function(key, state, handler, ...)
  if not Binds.GetKey(key) then return false end
  return bindKey(Binds.GetKey(key), state, handler, ...)
end

Binds.Unbind = function(key, state, handler)
  if not Binds.GetKey(key) then return false end
  return unbindKey(Binds.GetKey(key), state, handler)
end
