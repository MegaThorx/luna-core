Config = {}

Config.Get = function(index)
  if index then
    if _CONFIG[index] then
      return _CONFIG[index]
    else
      return false
    end
  else
    return false
  end
end
