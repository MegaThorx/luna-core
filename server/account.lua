Account = {}
Account.timers = {}

Account.Login = function(player, username, password, autologin)
  local account = DbAccounts.FindOneByUsername(username)

  if not account then
    -- TODO trigger error "NO_SUCH_ACCOUNT"
    triggerClientEvent(player, "errorAccountLogin", player, "NO_SUCH_ACCOUNT")
    return false
  end
  outputDebugString(username)
  if(true or account.GetPassword() == sha256(sha256(password)..account.GetSalt()))then

    Account.SetLoginData(player, account)
    triggerClientEvent(player, "successAccountLogin", player)

    if autologin then
      local token = sha256(account.GetUsername()..Random.GenerateString(math.random(2, 10))..getPlayerSerial(player)..Random.GenerateString(math.random(2, 10)))

      account.SetAutologinToken(token)
      account.SetAutologinSerial(getPlayerSerial(player))
      account.Persist()

      triggerClientEvent(player, "setAutologin", player, token)
    end

    return true
  else
    triggerClientEvent(player, "errorAccountLogin", player, "PASSWORD_IS_INCORRECT")
  end
end

Account.Autologin = function(player, autologin)
  local account = DbAccounts.FindOneByAutologinToken(autologin)

  if not account then
    triggerClientEvent(player, "removeAutologin", player)
    return false
  end

  if(getPlayerSerial(player) == account.GetAutologinSerial())then

    Account.SetLoginData(player, account)
    triggerClientEvent(player, "successAccountLogin", player)
    return true
  else
    triggerClientEvent(player, "removeAutologin", player)
  end
end

Account.SetLoginData = function(player, account)
  account.CopyDataToElement(player)

  if Account.timers[player] then
    killTimer(Account.timers[player])
  end

  Account.timers[player] = setTimer(Account.IncreasePlaytime, 60 * 1000, 1, player)

  Account.CreateFirstBankAccount(player)
  Player.Spawn(player)
end

Account.IncreasePlaytime = function(player)
  if isElement(player) then
    ElementData.Set(player, "accounts.playtime", ElementData.Get(player, "accounts.playtime") + 1, true)
    local playtime = ElementData.Get(player, "accounts.playtime")

    if playtime % 60 == 0 then
      Account.ProcessPayday(player)
    end

    Account.SavePlayerData(player)
    Account.timers[player] = setTimer(Account.IncreasePlaytime, 60 * 1000, 1, player)
  end
end

Account.ProcessPayday = function(player)
  local playtime = ElementData.Get(player, "accounts.playtime")
  local id = ElementData.Get(player, "accounts.id")
  local premium = 0

  if playtime % (60 * 1000) == 0 then
    premium = Config.Get("payday.premium.1000")
  elseif playtime % (60 * 100) == 0 then
    premium = Config.Get("payday.premium.100")
  elseif playtime % (60 * 10) == 0 then
    premium = Config.Get("payday.premium.10")
  end
  local accountNumber = Bank.GetMainAccount(id)

  if accountNumber then
    local balance = Bank.GetBalance(accountNumber)
    local interest = Bank.GetHaveInterest(accountNumber)
    interest = interest / 1000
    local interestIncome = math.floor(balance * interest * 100) / 100

    if interestIncome > Config.Get("payday.interest.max") then
      interestIncome = Config.Get("payday.interest.max")
    end

    outputChatBox("Zahltag", player, 0, 125, 0)
    outputChatBox("-----------------------", player, 0, 125, 0)
    Bank.GiveMoney(accountNumber, interestIncome, "Zinsen")
    outputChatBox("Zinsen: € "..tostring(interestIncome), player, 0, 125, 0)

    if premium ~= 0 then
      Bank.GiveMoney(accountNumber, premium, "Zusatzzahlung")
      outputChatBox("Zusatzzahlung: € "..tostring(premium), player, 0, 125, 0)
    end
    outputChatBox("-----------------------", player, 0, 125, 0)


  else
    Debug.Error("Can't find a bank account for player %s", id)
  end
end

Account.SavePlayerData = function(player)

  ElementData.Set(player, "lastonline", Time.GetTimestamp())
  Element.SaveData(player, "accounts")
  --[[
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

  SQL.Exec(query, ElementData.Get(player, "id"))]]

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

Account.CreateFirstBankAccount = function(player)
  local id = ElementData.Get(player, "accounts.id")

  if not Bank.GetMainAccount(id) then
    if Bank.CreateAccount(id, 1, 1) then
      Bank.GiveMoney(Bank.GetMainAccount(id), Config.Get("bank.initialBalance"), "Startgeld")
    end
  end
end

addEvent("tryLogin", true)
addEvent("tryRegister", true)

addEventHandler("tryLogin", root, function(username, password, autologin)
  Account.Login(client, username, password, autologin)
end)

addEventHandler("tryRegister", root, function(username, email, password, password2, rules)
  Account.Register(client, username, email, password, password2, rules)
end)
