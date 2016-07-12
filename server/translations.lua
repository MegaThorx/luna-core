Translations = {}
Translations.texts = {}

Translations.Init = function()
  for i,v in ipairs(Config.Get("languages")) do
    Translations.LoadTranslation(v)
  end
end


Translations.LoadTranslation = function(language)
  Translations.texts = {}

  if not fileExists("files/translations/"..language..".ini") then
    return false
  end
  local file = fileOpen("files/translations/"..language..".ini", true)
  local tmp = fileRead(file, fileGetSize(file))
  local tmp = split(tmp, '\n')
  Translations.texts[language] = {}
  for k,v in pairs(tmp) do
    local trans = split(v, '=')

    if Translations.texts[language][trans[1]] then
      outputDebugString("Duplicated translation entry for "..trans[1].." in language "..language)
    else
      Translations.texts[language][trans[1]] = trans[2]
    end
  end

  fileClose(file)
end

Translations.Translate = function(player, pharse)
  local language = ElementData.Get("language")
  return Translations.texts[language][pharse]
end
