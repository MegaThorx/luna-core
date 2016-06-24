Debug = {}

Debug.Log = function(text, ...)
  outputDebugString(string.format(text, ...), 3)
end

Debug.Warning = function(text, ...)
  outputDebugString(string.format(text, ...), 2)
end

Debug.Error = function(text, ...)
  outputDebugString(string.format(text, ...), 1)
end
