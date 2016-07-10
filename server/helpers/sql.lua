SQL = {}
SQL.count = -1
SQL.requestServingTime = -1
SQL.servingTimeStarts = {}

SQL.Connect = function()
  local host = "host="..Config.Get("db.host")
  local options = ""

  if(Config.Get("db.port"))then
    host = host..";port="..Config.Get("db.port")
  end

  if(Config.Get("db.dbname"))then
    host = host..";dbname="..Config.Get("db.dbname")
  end

  if(Config.Get("db.autoreconnect"))then
     if not options=="" then
       options = options..";"
     end
     options = options.."autoreconnect=1"
  end

  if(Config.Get("db.charset"))then
     if not options=="" then
       options = options..";"
     end
     options = options.."autoreconnect="..Config.Get("db.charset")
  end

  SQL.connection = dbConnect(Config.Get("db.type"), host, Config.Get("db.username"), Config.Get("db.password"), options)

  if(SQL.connection)then
    return true
  end

  return false
end

SQL.Query = function(query, ...)
  if SQL.count ~= -1 then SQL.count = SQL.count + 1 end

  local handle = false

  if SQL.requestServingTime ~= -1 then
    local start = getTickCount()
    handle = dbQuery(SQL.connection, query, ...)
    SQL.servingTimeStarts[handle] = start
  else
    handle = dbQuery(SQL.connection, query, ...)
  end

  return handle
end

SQL.Poll = function(queryHandle, timeout, multipleResults)

  if SQL.requestServingTime ~= -1 then
    result, count, result2 = dbPoll(queryHandle, timeout, multipleResults)
    if SQL.servingTimeStarts[queryHandle] then
      local diff = getTickCount() - SQL.servingTimeStarts[queryHandle]
      table.insert(SQL.requestServingTime, diff)
      SQL.servingTimeStarts[queryHandle] = nil
    end
  else
    result, count, result2 = dbPoll(queryHandle, timeout, multipleResults)
  end
  return result, count, result2
end

SQL.Free = function(queryHandle)
  return dbFree(queryHandle)
end

SQL.Exec = function(query, ...)
  if SQL.count ~= -1 then SQL.count = SQL.count + 1 end
  local result = false

  if SQL.requestServingTime ~= -1 then
    local start = getTickCount()
    result = dbExec(SQL.connection, query, ...)
    local diff = getTickCount() - start
    table.insert(SQL.requestServingTime, diff)
  else
    result = dbExec(SQL.connection, query, ...)
  end

  return result
end

SQL.PrepareString = function(query, ...)
  return dbPrepareString(SQL.connection, query, ...)
end

SQL.StartCounter = function()
  SQL.count = 0
end

SQL.StopCounter = function()
  local count = SQL.count
  SQL.count = -1
  return count
end

SQL.StartCollectionServingTime = function()
  SQL.servingTimeStarts = {}
  SQL.requestServingTime = {}
end

SQL.StopCollectionServingTime = function()
  local times = SQL.requestServingTime
  SQL.requestServingTime = -1
  SQL.servingTimeStarts = {}
  return times
end
