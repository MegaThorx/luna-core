Player.TakeMoney = function(player, amount)
  local current = Player.GetMoney(player)
  if current >= amount then
    Player.SetMoney(player, current - amount)
    return true
  else
    return false
  end
end

Player.GiveMoney = function(player, amount)
  local current = Player.GetMoney(player)
  Player.SetMoney(player, current + amount)
  return true
end

Player.GiveBankMoney = function(player, amount, reason)
  local mainAccount = Bank.GetMainAccount(Player.GetId(player))
  if mainAccount then
    return Bank.GiveMoney(mainAccount, amount, reason)
  end
  return false
end

Player.TakeBankMoney = function(player, amount, reason)
  local mainAccount = Bank.GetMainAccount(Player.GetId(player))
  if mainAccount then
    return Bank.TakeMoney(mainAccount, amount, reason)
  end
  return false
end

Player.GetMoney = function(player)
  return ElementData.Get(player, "accounts.money")
end

Player.SetMoney = function(player, amount)
  return ElementData.Set(player, "accounts.money", amount, true)
end

Player.GetId = function(player)
  return ElementData.Get(player, "accounts.id")
end
