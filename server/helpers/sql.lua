SQL = {}

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
  return dbQuery(SQL.connection, query, ...)
end

SQL.Poll = function(queryHandle, timeout, multipleResults)
  return dbPoll(queryHandle, timeout, multipleResults)
end

SQL.Free = function(queryHandle)
  return dbFree(queryHandle)
end

SQL.Exec = function(query, ...)
  return dbExec(SQL.connection, query, ...)
end

SQL.PrepareString = function(query, ...)
  return dbPrepareString(SQL.connection, query, ...)
end
