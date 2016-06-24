Bank = {}
Bank.bankTypesCache = {}
Bank.bankTypeCached = 0

Bank.Init = function()
  setTimer(Bank.ProcessTransactions, Config.Get("bank.transactionProcesserCheckTime"), 0)
  Bank.ProcessTransactions()
end

Bank.ProcessTransactions = function()
  local handle = SQL.Query("SELECT id FROM bank_transactions WHERE state = 0 AND processingTime <= ?", Time.GetTimestamp())
  local result, count = SQL.Poll(handle, -1)

  for k,v in pairs(result) do
    Bank.ProcessTransaction(v["id"])
  end
end

Bank.ProcessTransaction = function(id)
  local handle = SQL.Query("SELECT * FROM bank_transactions WHERE id = ?", id)
  local result, count = SQL.Poll(handle, -1)

  if result[1].processingTime <= Time.GetTimestamp() then
    SQL.Exec("UPDATE bank_transactions SET state = 1 WHERE id = ?", result[1].id)
    local handle = SQL.Query("UPDATE bank_accounts SET balance = balance + ? WHERE accountNumber = ?", result[1].amount, result[1].to)
    local result, count = SQL.Poll(handle, -1)
    if count == 0 then
      -- TODO add panic
      return false
    else
      return true
    end
  end
end

Bank.Transfer = function(playerId, fromAccount, toAccount, amount, reason)
  local balance = Bank.GetBalance(fromAccount)
  local transactionTime = Bank.GetTansactionProcessingTime(fromAccount)
  local transactionTimeTo = Bank.GetTansactionProcessingTime(toAccount)

  if balance and transactionTime and transactionTimeTo and balance >= amount then
    local handle = SQL.Query("UPDATE bank_accounts SET balance = balance - ? WHERE accountNumber = ?", amount, fromAccount)
    local _, count = SQL.Poll(handle, -1)
    if count == 1 then
      local endTime = Time.GetTimestamp() + transactionTime + transactionTimeTo
      local handle = SQL.Query("INSERT INTO bank_transactions (`from`, `to`, amount, reason, creationTime, processingTime) VALUES (?, ?, ?, ?, ?, ?)", fromAccount, toAccount, amount, reason, Time.GetTimestamp(), endTime)
      local _, count = SQL.Poll(handle, -1)
      if count == 1 then
        return true
      end
    end
  end

  return false
end

Bank.TakeMoney = function(accountNumber, amount, reason)
  local balance = Bank.GetBalance(accountNumber)

  if balance and balance >= amount then
    local handle = SQL.Query("UPDATE bank_accounts SET balance = balance - ? WHERE accountNumber = ?", amount, accountNumber)
    local _, count = SQL.Poll(handle, -1)
    if count == 1 then
      local handle = SQL.Query("INSERT INTO bank_transactions (`from`, `to`, amount, reason, creationTime, processingTime) VALUES (?, ?, ?, ?, ?, ?)", accountNumber, 0, amount, reason, Time.GetTimestamp(), 0)
      local _, count, id = SQL.Poll(handle, -1)
      if count == 1 then
        return Bank.ProcessTransaction(id)
      end
    end
  end

  return false
end

Bank.GiveMoney = function(accountNumber, amount, reason)
  local handle = SQL.Query("INSERT INTO bank_transactions (`from`, `to`, amount, reason, creationTime, processingTime) VALUES (?, ?, ?, ?, ?, ?)", 0, accountNumber, amount, reason, Time.GetTimestamp(), 0)

  local _, count, id = SQL.Poll(handle, -1)

  if count == 1 then
    return Bank.ProcessTransaction(id)
  end

  return false
end

Bank.CreateAccount = function(playerId, typ, default)
  if not default then default = 0 end
  local accountNumber = Bank.GetNextAccountNumber()
  local handle = SQL.Query("INSERT INTO bank_accounts (accountNumber, owner, typ,`default`) VALUES (?, ?, ?, ?)", accountNumber, playerId, typ, default)
  local _, count = SQL.Poll(handle, -1)

  if count == 1 then
    return true
  else
    return false
  end
end


Bank.GetNextAccountNumber = function()
  local handle = SQL.Query("SELECT accountNumber FROM bank_accounts ORDER BY accountNumber DESC LIMIT 1")
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
    SQL.Exec("UPDATE bank_accounts SET `default` = 0 WHERE owner = ?", playerId)
    local handle = SQL.Query("UPDATE bank_accounts SET `default` = 1 WHERE accountNumber = ?", accountNUmber)
  else
    return false
  end
end

Bank.CloseAccount = function(playerId, accountNumber)
end

Bank.GetMainAccount = function(playerId)
  local handle = SQL.Query("SELECT accountNumber FROM bank_accounts WHERE `default` = 1 AND owner = ?", playerId)
  local result, count = SQL.Poll(handle, -1)

  if result and count ~= 0 then
    return result[1]["accountNumber"]
  else
    return false
  end
end

Bank.GetTransactionFeed = function(accountNumber, amount)
  if not amount then amount = Config.Get("bank.transactionFeed") end

  local handle = SQL.Query("SELECT * FROM bank_transactions WHERE from = ? OR to = ? LIMIT ?", accountNumber, accountNumber, amount)
  local result = SQL.Poll(handle, -1)

  return result
end

Bank.GetBalance = function(accountNumber)
  local handle = SQL.Query("SELECT balance FROM bank_accounts WHERE accountNumber = ?", accountNumber)
  local result, count = SQL.Poll(handle, -1)

  if result and count ~= 0 then
    return result[1]["balance"]
  else
    return false
  end
end

Bank.GetAccountOwner = function(accountNumber)
  local handle = SQL.Query("SELECT owner FROM bank_accounts WHERE accountNumber = ?", accountNumber)
  local result, count = SQL.Poll(handle, -1)

  if result and count ~= 0 then
    return result[1]["owner"]
  else
    return false
  end
end

Bank.GetAccountTyp = function(accountNumber)
  local handle = SQL.Query("SELECT typ FROM bank_accounts WHERE accountNumber = ?", accountNumber)
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
    local handle = SQL.Query("SELECT transactionProcessingTime FROM bank_types WHERE id = ?", accountType)
    local result, count = SQL.Poll(handle, -1)

    if result and count ~= 0 then
      return result[1]["transactionProcessingTime"]
    end
  end
  return false
end

Bank.GetCanReceiveDirectPayments = function(accountNumber)
  local accountType = Bank.GetAccountTyp(accountNumber)
  if accountType then
    local handle = SQL.Query("SELECT canReceiveDirectPayments FROM bank_types WHERE id = ?", accountType)
    local result, count = SQL.Poll(handle, -1)

    if result and count ~= 0 then
      return result[1]["canReceiveDirectPayments"]
    end
  end
  return false
end

Bank.GetPlayerAccounts = function(playerId)
  local handle = SQL.Query("SELECT * FROM bank_accounts WHERE owner = ?", playerId)
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
    local handle = SQL.Query("SELECT * FROM bank_types")
    local result, count = SQL.Poll(handle, -1)

    if result and count ~= 0 then
      Bank.bankTypesCache = result
    end
  end

  return Bank.bankTypesCache
end
