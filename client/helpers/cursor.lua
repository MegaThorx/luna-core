Cursor = {}

Cursor.Show = function()
  showCursor(true)
  toggleAllControls(false, true, true)
  toggleControl("chatbox", false)
  focusBrowser(GUI.browser)
end

Cursor.Hide = function()
  showCursor(false)
  toggleAllControls(true, true, true)
  toggleControl("chatbox", true)
  focusBrowser(nil)
end

Cursor.BlockBinds = function()
  guiSetInputEnabled(true)
end

Cursor.UnblockBinds = function()
  guiSetInputEnabled(false)
end

Cursor.IsShowing = function()
  return isCursorShowing()
end
