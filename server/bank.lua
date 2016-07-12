Bank = {}
Bank.bankTypesCache = {}
Bank.bankTypeCached = 0

Bank.Init = function()
  setTimer(Bank.ProcessTransactions, Config.Get("bank.transactionProcesserCheckTime"), 0)
  Bank.ProcessTransactions()
end

Bank.ProcessTransactions = function()
  local handle = SQL.Query("SELECT id FROM bankTransactions WHERE state = 0 AND processingTime <= ?", Time.GetTimestamp())
  local result, count = SQL.Poll(handle, -1)

  for k,v in pairs(result) do
    Bank.ProcessTransaction(v["accounts.id"])
  end
end

Bank.ProcessTransaction = function(id)
  --local handle = SQL.Query("SELECT * FROM bankTransactions WHERE id = ?", id)
  --local result, count = SQL.Poll(handle, -1)
  local bankTransaction = DbBankTransactions.FindOneById(id)

  if bankTransaction then
    if bankTransaction.GetProcessingTime() <= Time.GetTimestamp() then
      SQL.Exec("UPDATE bankTransactions SET state = 1 WHERE id = ?", bankTransaction.GetId())
      local handle = SQL.Query("UPDATE bankAccounts SET balance = balance + ? WHERE accountNumber = ?", bankTransaction.GetAmount(), bankTransaction.GetTo())
      local result, count = SQL.Poll(handle, -1)
      if count == 0 then
        -- TODO add panic
        return false
      else
        return true
      end
    end
  end

  return false
end

Bank.Transfer = function(playerId, fromAccount, toAccount, amount, reason)
  local balance = Bank.GetBalance(fromAccount)
  local transactionTime = Bank.GetTansactionProcessingTime(fromAccount)
  local transactionTimeTo = Bank.GetTansactionProcessingTime(toAccount)
  local playerIdFrom = Bank.GetAccountOwner(fromAccount)
  local playerIdTo = Bank.GetAccountOwner(toAccount)
  local canReceive = Bank.CanReceiveDirectPayments(toAccount)

  if balance and transactionTime and transactionTimeTo and balance >= amount then
    if canReceive == 1 or playerIdFrom == playerIdTo then
      local handle = SQL.Query("UPDATE bankAccounts SET balance = balance - ? WHERE accountNumber = ?", amount, fromAccount)
      local _, count = SQL.Poll(handle, -1)
      if count == 1 then
        local endTime = Time.GetTimestamp() + transactionTime + transactionTimeTo
        local handle = SQL.Query("INSERT INTO bankTransactions (`from`, `to`, amount, reason, creationTime, processingTime) VALUES (?, ?, ?, ?, ?, ?)", fromAccount, toAccount, amount, reason, Time.GetTimestamp(), endTime)
        local _, count = SQL.Poll(handle, -1)
        if count == 1 then
          return true
        end
      end
    end
  end

  return false
end

Bank.TakeMoney = function(accountNumber, amount, reason)
  if amount < 0 or type(amount) ~= "number" then
    return false
  end

  local balance = Bank.GetBalance(accountNumber)

  if balance and balance >= amount then
    local handle = SQL.Query("UPDATE bankAccounts SET balance = balance - ? WHERE accountNumber = ?", amount, accountNumber)
    local _, count = SQL.Poll(handle, -1)
    if count == 1 then
      local handle = SQL.Query("INSERT INTO bankTransactions (`from`, `to`, amount, reason, creationTime, processingTime) VALUES (?, ?, ?, ?, ?, ?)", accountNumber, 0, amount, reason, Time.GetTimestamp(), 0)
      local _, count, id = SQL.Poll(handle, -1)
      if count == 1 then
        Bank.ProcessTransaction(id)
        return true
      end
    end
  end

  return false
end

Bank.GiveMoney = function(accountNumber, amount, reason)
  if amount < 0 or type(amount) ~= "number" then
    return false
  end

  local handle = SQL.Query("INSERT INTO bankTransactions (`from`, `to`, amount, reason, creationTime, processingTime) VALUES (?, ?, ?, ?, ?, ?)", 0, accountNumber, amount, reason, Time.GetTimestamp(), 0)

  local _, count, id = SQL.Poll(handle, -1)

  if count == 1 then
    return Bank.ProcessTransaction(id)
  end

  return false
end

Bank.CreateAccount = function(playerId, typ, default)
  if not default then default = 0 end
  local accountNumber = Bank.GetNextAccountNumber()
  local handle = SQL.Query("INSERT INTO bankAccounts (accountNumber, account_id, typ,`default`) VALUES (?, ?, ?, ?)", accountNumber, playerId, typ, default)
  local _, count = SQL.Poll(handle, -1)

  if count == 1 then
    return true
  else
    return false
  end
end

Bank.GetNextAccountNumber = function()
  local handle = SQL.Query("SELECT accountNumber FROM bankAccounts ORDER BY accountNumber DESC LIMIT 1")
  local result, count = SQL.Poll(handle, -1)

  if result and count ~= 0 then
    return result[1]["accountNumber"] + 1
  else
    return 100000
  end
end

Bank.SetMainAccount = function(accountNumber)
  local canReceive = Bank.GetCanReceiveDirectPayments(accountNumber)
  local playerId = Bank.GetAccountOwner(accountNumber)

  if canReceive and playerId and canReceive == 1 then
    SQL.Exec("UPDATE bankAccounts SET `default` = 0 WHERE account_id = ?", playerId)
    local handle = SQL.Query("UPDATE bankAccounts SET `default` = 1 WHERE accountNumber = ?", accountNUmber)
  else
    return false
  end
end

Bank.CloseAccount = function(playerId, accountNumber)
end

Bank.GetMainAccount = function(playerId)
  local handle = SQL.Query("SELECT accountNumber FROM bankAccounts WHERE `default` = 1 AND account_id = ?", playerId)
  local result, count = SQL.Poll(handle, -1)

  if result and count ~= 0 then
    return result[1]["accountNumber"]
  else
    return false
  end
end

Bank.GetTransactionFeed = function(accountNumber, amount)
  if not amount then amount = Config.Get("bank.transactionFeed") end

  local handle = SQL.Query("SELECT * FROM bankTransactions WHERE from = ? OR to = ? LIMIT ?", accountNumber, accountNumber, amount)
  local result = SQL.Poll(handle, -1)

  return result
end

Bank.GetBalance = function(accountNumber)
  local handle = SQL.Query("SELECT balance FROM bankAccounts WHERE accountNumber = ?", accountNumber)
  local result, count = SQL.Poll(handle, -1)

  if result and count ~= 0 then
    return result[1]["balance"]
  else
    return false
  end
end

Bank.GetAccountOwner = function(accountNumber)
  local handle = SQL.Query("SELECT account_id FROM bankAccounts WHERE accountNumber = ?", accountNumber)
  local result, count = SQL.Poll(handle, -1)

  if result and count ~= 0 then
    return result[1]["account_id"]
  else
    return false
  end
end

Bank.GetAccountTyp = function(accountNumber)
  local handle = SQL.Query("SELECT typ FROM bankAccounts WHERE accountNumber = ?", accountNumber)
  local result, count = SQL.Poll(handle, -1)

  if result and count ~= 0 then
    return result[1]["typ"]
  else
    return false
  end
end

Bank.GetTansactionProcessingTime = function(accountNumber)
  local accountType = Bank.GetAccountTyp(accountNumber)
  if accountType then
    local handle = SQL.Query("SELECT transactionProcessingTime FROM bankTypes WHERE id = ?", accountType)
    local result, count = SQL.Poll(handle, -1)

    if result and count ~= 0 then
      return result[1]["transactionProcessingTime"]
    end
  end
  return false
end

Bank.CanReceiveDirectPayments = function(accountNumber)
  local accountType = Bank.GetAccountTyp(accountNumber)
  if accountType then
    local handle = SQL.Query("SELECT canReceiveDirectPayments FROM bankTypes WHERE id = ?", accountType)
    local result, count = SQL.Poll(handle, -1)

    if result and count ~= 0 then
      return result[1]["canReceiveDirectPayments"]
    end
  end
  return false
end

Bank.GetCanReceiveDirectPayments = function(accountNumber)
  local accountType = Bank.GetAccountTyp(accountNumber)
  if accountType then
    local handle = SQL.Query("SELECT canReceiveDirectPayments FROM bankTypes WHERE id = ?", accountType)
    local result, count = SQL.Poll(handle, -1)

    if result and count ~= 0 then
      return result[1]["canReceiveDirectPayments"]
    end
  end
  return false
end

Bank.GetHaveInterest = function(accountNumber)
  local accountType = Bank.GetAccountTyp(accountNumber)
  if accountType then
    local handle = SQL.Query("SELECT haveInterest FROM bankTypes WHERE id = ?", accountType)
    local result, count = SQL.Poll(handle, -1)

    if result and count ~= 0 then
      return result[1]["haveInterest"]
    end
  end
  return false
end

Bank.GetPlayerAccounts = function(playerId)
  local handle = SQL.Query("SELECT * FROM bankAccounts WHERE account_id = ?", playerId)
  local result, count = SQL.Poll(handle, -1)

  if result and count ~= 0 then
    return result
  else
    return false
  end
end

Bank.GetAccountTypes = function(force)
  if Bank.bankTypeCached < getTickCount() - Config.Get("bank.cacheRefreshTime") or force then
    Bank.bankTypeCached = true
    local handle = SQL.Query("SELECT * FROM bankTypes")
    local result, count = SQL.Poll(handle, -1)

    if result and count ~= 0 then
      Bank.bankTypesCache = result
    end
  end

  return Bank.bankTypesCache
end



-------------------------------------------------------------------

addEvent("getBankAccounts", true)
addEvent("getAccountTransactionFeed", true)
addEvent("takeAccountMoney", true)
addEvent("giveAccountMoney", true)
addEvent("getAtmBalance", true)
addEvent("takeAtmMoney", true)
addEvent("giveAtmMoney", true)

addEventHandler("takeAtmMoney", root, function(amount)
  local id = ElementData.Get(client, "accounts.id")
  local main = Bank.GetMainAccount(id)

  if main then
    local balance = Bank.GetBalance(main)
    if Bank.TakeMoney(main, amount, "ATM") then
      Player.GiveMoney(client, amount)
      Bank.GetAtmBalance()
    end
  end
end)

addEventHandler("giveAtmMoney", root, function(amount)
  local id = ElementData.Get(client, "accounts.id")
  local main = Bank.GetMainAccount(id)
  if main then
    local balance = Player.GetMoney()
    if Player.TakeMoney(client, amount) then
      Bank.GiveMoney(main, amount, "ATM")

      Bank.GetAtmBalance()
    end
  end
end)

addEventHandler("getAtmBalance", root, function()
  Bank.GetAtmBalance()
end)

Bank.GetAtmBalance = function()
    local id = ElementData.Get(client, "accounts.id")
    local main = Bank.GetMainAccount(id)

    if main then
      local balance = Bank.GetBalance(main)
      if balance then
        triggerClientEvent(client, "setAtmBalance", client, balance)
      end
    end
end

addEventHandler("getBankAccounts", root, function()
  local id = ElementData.Get(client, "accounts.id")

  if id then
    Bank.GetPlayerAccounts(id)
  end
end)

addEventHandler("getAccountTransactionFeed", root, function(account, amount)
  local id = ElementData.Get(client, "accounts.id")
  local account_id = Bank.GetAccountOwner(account)

  if id and owner and account_id == id then -- TODO add exeption for admins?
    Bank.GetTransactionFeed(account, amount)
  end
end)


addEventHandler("takeAccountMoney", root, function(account, amount)
  local id = ElementData.Get(client, "accounts.id")
  local account_id = Bank.GetAccountOwner(account)


end)

addEventHandler("giveAccountMoney", root, function(account, amount)
  local id = ElementData.Get(client, "accounts.id")
  local account_id = Bank.GetAccountOwner(account)

end)
