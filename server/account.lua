Account = {}
Account.timers = {}

Account.Login = function(player, username, password, autologin)
  local handle = SQL.Query("SELECT * FROM accounts WHERE LCASE(username) = LCASE(?)", username)
  local result = SQL.Poll(handle, -1)

  if(#result==0)then
    -- TODO trigger error "NO_SUCH_ACCOUNT"
    triggerClientEvent(player, "errorAccountLogin", player, "NO_SUCH_ACCOUNT")
    return false
  end

  local result = result[1]

  if(result["password"] == sha256(sha256(password)..result["salt"]))then

    Account.SetLoginData(player, result)
    triggerClientEvent(player, "successAccountLogin", player)

    if autologin then
        local token = sha256(result["username"]..Random.GenerateString(math.random(2, 10))..getPlayerSerial(player)..Random.GenerateString(math.random(2, 10)))

        SQL.Exec("UPDATE accounts SET autologin_token = ?, autologin_serial = ? WHERE id = ?", token, getPlayerSerial(player), result["id"])

        triggerClientEvent(player, "setAutologin", player, token)
    end

    return true
  else
    triggerClientEvent(player, "errorAccountLogin", player, "PASSWORD_IS_INCORRECT")
  end
end

Account.Autologin = function(player, autologin)
  local handle = SQL.Query("SELECT * FROM accounts WHERE LCASE(autologin_token) = LCASE(?)", autologin)
  local result = SQL.Poll(handle, -1)

  if(#result==0)then
    triggerClientEvent(player, "removeAutologin", player)
    return false
  end

  local result = result[1]

  if(getPlayerSerial(player) == result["autologin_serial"])then

      Account.SetLoginData(player, result)
      triggerClientEvent(player, "successAccountLogin", player)
    return true
  else
    triggerClientEvent(player, "removeAutologin", player)
  end
end

Account.SetLoginData = function(player, data)
  for k,v in pairs(data) do
    if (SQL_STRUCTURE["accounts"][k].custom and (SQL_STRUCTURE["accounts"][k].custom.storeClient or SQL_STRUCTURE["accounts"][k].custom.storeServer)) then
      if SQL_STRUCTURE["accounts"][k].custom.storeClient then
        ElementData.Set(player, k, v, true)
      else
        ElementData.Set(player, k, v, false)
      end
    end
  end

  if Account.timers[player] then
    killTimer(Account.timers[player])
  end

  Account.timers[player] = setTimer(Account.IncresePlaytime, 60 * 1000, 1, player)

  Player.Spawn(player)
end

Account.IncresePlaytime = function(player)
  if isElement(player) then
    ElementData.Set(player, "playtime", ElementData.Get(player, "playtime") + 1)
    Account.SavePlayerData(player)
    Account.timers[player] = setTimer(Account.IncresePlaytime, 60 * 1000, 1, player)
  end
end


Account.SavePlayerData = function(player)

  ElementData.Set(player, "lastonline", Time.GetTimestamp())
  local query = "UPDATE accounts SET "
  for k,v in pairs(SQL_STRUCTURE["accounts"]) do
    if SQL_STRUCTURE["accounts"][k].custom and SQL_STRUCTURE["accounts"][k].custom.autoSave then
      if query ~= "UPDATE accounts SET " then
        query = query..", "
      end
      query = query..SQL.PrepareString(k.." = ?", ElementData.Get(player, k))
    end
  end
  query = query.." WHERE id = ?"

  SQL.Exec(query, ElementData.Get(player, "id"))
end

Account.Register = function(player, username, email, password, password2, rules)
  local handle = SQL.Query("SELECT * FROM accounts WHERE LCASE(username) = LCASE(?) OR LCASE(email) = LCASE(?)", username, email)
  local result = SQL.Poll(handle, -1)

  if(#result > 0)then
    -- TODO trigger error "ACCOUNT_WITH_THIS_NAME_OR_EMAIL_EXISTS"
    triggerClientEvent(player, "errorAccountRegister", player, "ACCOUNT_WITH_THIS_NAME_OR_EMAIL_EXISTS")
    return false
  end

  if not Validator.IsValidEmail(email) then
    -- TODO trigger error "INVALID_EMAIL"
    triggerClientEvent(player, "errorAccountRegister", player, "INVALID_EMAIL")
    return false
  end

  if Validator.IsValidAccountName(username) ~= true then
    -- TODO trigger error Validator.IsValidAccountName(email) returns a string with error
    triggerClientEvent(player, "errorAccountRegister", player, Validator.IsValidAccountName(username))
    return false
  end

  if password ~= password2 then
    -- TODO trigger error "PASSWORD_ISNT_EQUAL"
    triggerClientEvent(player, "errorAccountRegister", player, "PASSWORD_ISNT_EQUAL")
    return false
  end

  local salt = Random.GenerateString(8)
  local serial = getPlayerSerial(player)

  local saltedPassword = sha256(sha256(password)..salt)

  local sql = "INSERT INTO accounts (`username`, `password`, `email`, `salt`, `serial`) VALUES (?, ?, ?, ?, ?)"

  SQL.Exec(sql, username, saltedPassword, email, salt, serial)
  return Account.Login(player, username, password)
end

addEvent("tryLogin", true)
addEvent("tryRegister", true)

addEventHandler("tryLogin", root, function(username, password, autologin)
  Account.Login(client, username, password, autologin)
end)

addEventHandler("tryRegister", root, function(username, email, password, password2, rules)
  Account.Register(client, username, email, password, password2, rules)
end)
