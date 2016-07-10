Log = {}
Log.basedir = "logs/"

Log.PrintSQL = function(action, field, table)
  Log.Print({["action"] = action, ["field"] = field, ["table"] = table}, "sql")
end

Log.PrintServer = function(message, ...)
  outputServerLog(string.format(message, ...))
  Log.Print({["message"] = string.format(message, ...)}, "server")
end

Log.PrintCheatAttempt = function(message, client)
  --outputServerLog(string.format(message, client))
  local serial = getPlayerSerial(client)
  local id = ElementData.Get(client, "id")

  Log.Print({["message"] = string.format(message), ["serial"] = serial, ["account"] = tostring(id)}, "cheaters")
end

Log.Print = function(entry, dir)
  local content = {}
  local file
  if not(fileExists(Log.basedir..dir.."/"..Time.GetDateShort()..".json")) then
  	file = fileCreate(Log.basedir..dir.."/"..Time.GetDateShort()..".json")
  else
    file = fileOpen(Log.basedir..dir.."/"..Time.GetDateShort()..".json")
    content = fromJSON(fileRead(file, fileGetSize(file)))

    fileClose(file)
    fileDelete(Log.basedir..dir.."/"..Time.GetDateShort()..".json")
    file = fileCreate(Log.basedir..dir.."/"..Time.GetDateShort()..".json")
  end

  entry["timestamp"] = Time.GetTimestamp()

  table.insert(content, entry)

  fileSetPos(file, 0)
  fileWrite(file, toJSON(content))

  fileFlush(file)
  fileClose(file)
end

addEventHandler("onDebugMessage", root, function(message, level, file, line)
  Log.Print({["message"] = message, ["level"] = level, ["file"] = file, ["line"] = line}, "error")
end)

-- Doesnt work :(
Log.Traceback = function()
  local level = 4
  local result = {}

  while true do
    local info = debug.getinfo(level, "Sln")
    if not info then break end
    if info.what ~= "C" then
      table.insert(result, {["src"] = info.short_src, ["line"] = info.currentline, ["function"] = info.name})
    end
    level = level + 1
  end

  return result
end
