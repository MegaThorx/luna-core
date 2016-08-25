Inventory = {}
Inventory.inventories = {}

Items = {}
table.insert(Items, {
    id = "item.stroh",
    stackAble = true
  })

Inventory.Init = function()

end

Inventory.CacheInventory = function(player)
  local inventory = Inventory.GetInventory(player)
  if not inventory then
    Inventory.CreateInventory(player)
    inventory = Inventory.GetInventory(player)
  end

  inventory.CopyDataToElement(player)
  triggerClientEvent(player, "onInventorySync", player, inventory.GetInventory())
  Inventory.inventories[player] = inventory
end

Inventory.GetInventory = function(player)
  local account = DbAccounts.GetFromElement(player)
  local inventory = DbInventory.FindOneByAccount(account)
  if inventory then
    return inventory
  end
  return false
end

Inventory.SetInventory = function(player, inv)
  local account = DbAccounts.GetFromElement(player)
  local inventory = DbInventory.FindOneByAccount(account)
  if inventory then
    inventory.SetInventory(toJSON(inv))
    inventory.Persist()
    return true
  end
  return false
end

Inventory.CreateInventory = function(player)
  local inventory = DbInventory.Create()
  local account = DbAccounts.GetFromElement(player)
  if inventory then
    local inv = {}

    inv.size = Config.Get("inventory.defaultSize")
    inv.data = {}

    for i=1,inv.size do
      inv.data[i] = {}
      inv.data[i].itemId = "none"
      inv.data[i].itemAmount = 0
    end

    inventory.SetAccount(account)
    inventory.SetInventory(toJSON(inv))
    inventory.Persist()
    return true
  end
  return false
end

Inventory.GetItemAmount = function(player, itemName)

end

Inventory.AddItem = function(player, itemName, amount)
  --local account = DbAccounts.GetFromElement(player)
  local inventory = DbInventory.GetFromElement(player)
  local inv = fromJSON(inventory.GetInventory())

  local found = false
  for k, v in pairs(inv) do
    if v.name == itemName then
      v.amount = v.amount + amount
      inv[k] = v
      found = true
      break
    end
  end

  if not found then
    table.insert(inv, {name = itemName, amount = amount})
  end

  inventory.SetInventory(toJSON(inv))
  inventory.Persist()

  Inventory.CacheInventory(player)
end

addCommandHandler("tester", function(pl)
    Inventory.AddItem(pl, "Stroh", 123)
  end)

Inventory.FindItemByName = function(player, itemName, amount)
  local inventory = DbInventory.GetFromElement(player)
  local inv = fromJSON(inventory.GetInventory())

  for k, v in pairs(inv) do
    if v.name == itemName then
      if v.amount >= amount then
        return v
      end
    end
  end

end

Inventory.RemoveItem = function(player, itemName, amount)
  for k,v in pairs(table_name) do
    -- body...
  end
end
