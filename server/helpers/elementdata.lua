ElementData = {}
local data = {}
local sync = {}
local cupd = {}

ElementData.Set = function(theElement, key, value, synchronize, clientUpdate)
  if not value then
    return ElementData.Delete(theElement, key, value)
  end

  if(synchronize)then
    if not sync[theElement] then
      sync[theElement] = {}
    end

    if clientUpdate then
      if not cupd[theElement] then
        cupd[theElement] = {}
      end
      cupd[theElement][key] = clientUpdate
    end

    sync[theElement][key] = synchronize
    setElementData(theElement, key, value, synchronize)
  end

  if not data[theElement] then
    data[theElement] = {}
  end

  data[theElement][key] = value
end

ElementData.Get = function(theElement, key, inherit)
  if not data[theElement] then
    return false
  end

  if not data[theElement][key] then
    return false
  end

  return data[theElement][key]
end

ElementData.Delete = function(theElement, key)
  if not data[theElement] then
    return false
  end

  if not data[theElement][key] then
    return false
  end

  data[theElement][key] = nil

  if #data[theElement]==0 then
    data[theElement] = nil
  end

  if sync[theElement] then
    if sync[theElement][key] then
      sync[theElement][key] = nil
      setElementData(theElement, key, nil, true)
    end

    if #sync[theElement]==0 then
      sync[theElement] = nil
    end
  end

  return true
end

addEventHandler("onElementDataChange", root, function(theName, theOldValue)
  -- source = element, client, sourceResource

  if ElementData.Get(source, theName) then
    if cupd[source] then
      if cupd[source][theName] then
        local newVal = getElementData(source, theName)
        ElementData.Set(source, theName, newVal, true, true)
      else
        -- manipulation
      end
    else
      -- manipulation
    end
  end
end)
