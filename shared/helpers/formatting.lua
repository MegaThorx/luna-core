Formatting = {}

Formatting.Currency = function(clientOrAmount, amount)
  if localPlayer then
    return Formatting.FormatNum(clientOrAmount, 2, "€ ", nil, Translations.GetCurrencyFormat())
  else

  end
end

Formatting.FormatNum = function(amount, decimal, prefix, neg_prefix, decimalPoint)
  local str_amount,  formatted, famount, remain

  decimal = decimal or 2  -- default 2 decimal places
  neg_prefix = neg_prefix or "-" -- default negative sign

  famount = math.abs(Formatting.Round(amount,decimal))
  famount = math.floor(famount)

  remain = Formatting.Round(math.abs(amount) - famount, decimal)

  -- comma to separate the thousands
  if decimalPoint == "," then
    formatted = Formatting.CommaThousands(famount, ".")
  else
    formatted = Formatting.CommaThousands(famount, ",")
  end

  -- attach the decimal portion
  if (decimal > 0) then
    remain = string.sub(tostring(remain),3)
    if decimalPoint == "," then
      formatted = formatted .. "," .. remain ..
      string.rep("0", decimal - string.len(remain))
    else
      formatted = formatted .. "." .. remain ..
      string.rep("0", decimal - string.len(remain))
    end
  end

  -- attach prefix string e.g '$'
  formatted = (prefix or "") .. formatted

  -- if value is negative then format accordingly
  if (amount<0) then
    if (neg_prefix=="()") then
      formatted = "("..formatted ..")"
    else
      formatted = neg_prefix .. formatted
    end
  end

  return formatted
end

function Formatting.CommaThousands(amount, symbol)
  local formatted = amount
  while true do
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1'..symbol..'%2')
    if (k==0) then
      break
    end
  end
  return formatted
end


function Formatting.Round(val, decimal)
  if (decimal) then
    return math.floor( (val * 10^decimal) + 0.5) / (10^decimal)
  else
    return math.floor(val+0.5)
  end
end
