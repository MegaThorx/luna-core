PlayerHouse = {}

PlayerHouse.shadows = {
  "andydark",
  "ah_yelplnks",
  "ah_wdpanel",
  "ah_walltile5",
  "ah_pnwainscot",
  "ah_flroortile8",
  "ah_cheapredcarpet"
}

PlayerHouse.Init = function()
  --[[
  local texture = dxCreateRenderTarget(900, 900, true)
  dxSetRenderTarget(texture, true)
  dxDrawRectangle(0, 0, 900, 900)
  dxSetRenderTarget()
  local shader, technique = dxCreateShader("files/shaders/texture_rep.fx", 0, 0, false, "vehicle")
  local texture = dxCreateTexture("files/images/textures/camo.jpg")
  outputDebugString(technique)
  dxSetShaderValue(shader, "Tex", texture)
  for i,v in ipairs(PlayerHouse.shadows) do
    outputDebugString(tostring(engineApplyShaderToWorldTexture(shader, v)))
    outputChatBox(v)
  end]]
end
addCommandHandler("again", PlayerHouse.Init)
