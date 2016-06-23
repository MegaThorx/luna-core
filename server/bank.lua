Bank = {}
Bank.bankTypesCache = {}
Bank.bankTypeCached = 0

Bank.Init = function()
  setTimer(Bank.ProcessTransactions, Config.Get("bank.transactionProcesserCheckTime"), 0)
end

Bank.ProcessTransactions = function()
  local handle = SQL.Query("SELECT * FROM bank_transactions WHERE state = 0")
  local result = SQL.Poll(handle, -1)
end

Bank.CreateAccount = function(player, typ)
end

Bank.CloseAccount = function(player, id)

end

Bank.GetMainAccount = function(player)

end

Bank.GetTransactionFeed = function(player, id, amount)
  if not amount then amount = Config.Get("bank.transactionFeed") end

end

Bank.Transfer = function(player, id, target, amount)

end

Bank.Payout = function(player, id, amount)
end

Bank.Payin = function(player, id, amount)

end

Bank.GetAccountTypes = function(force)
  if Bank.bankTypeCached < getTickCount() - Config.Get("bank.cacheRefreshTime") or force then
     Bank.bankTypeCached = true
     local handle = SQL.Query("SELECT * FROM bank_types")
     local result = SQL.Poll(handle, -1)
     if result then
       Bank.bankTypesCache = result
     end
  end

  return Bank.bankTypesCache
end
