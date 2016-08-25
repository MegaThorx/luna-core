Tuning = {}
Tuning.camPos = {
  ["front"] = {-1995.435546875, 163.38859558105, 51.488899230957, -1995.4877929688, 162.39610290527, 51.378253936768},
  ["back"] = {-1995.5224609375, 145.61529541016, 51.464298248291, -1995.4674072266, 146.61335754395, 51.435459136963},
  ["right"] = {-1986.6071777344, 154.4801940918, 51.475700378418, -1987.6048583984, 154.48731994629, 51.408626556396},
  ["left"] = {-2004.3941650391, 154.59410095215, 51.467399597168, -2003.3991699219, 154.50219726563, 51.427631378174},
  ["top"] = {-1995.2438964844, 153.07389831543, 63.311256408691, -1994.9595947266, 162.12322998047, -36.278045654297}
}

Tuning.upgradeSlotNames = {
  [0] = "VEH_UPGRADE_HOOD",
  [1] = "VEH_UPGRADE_VENT",
  [2] = "VEH_UPGRADE_SPOILER",
  [3] = "VEH_UPGRADE_SIDESKIRT",
  [4] = "VEH_UPGRADE_FRONT_BULLBARS",
  [5] = "VEH_UPGRADE_REAR_BULLBARS",
  [6] = "VEH_UPGRADE_HEADLIGHTS",
  [7] = "VEH_UPGRADE_ROOF",
  [8] = "VEH_UPGRADE_NITRO",
  [9] = "VEH_UPGRADE_HYDRAULICS",
  [10] = "VEH_UPGRADE_STEREO",
  [11] = "VEH_UPGRADE_UNKOWN",
  [12] = "VEH_UPGRADE_WHEELS",
  [13] = "VEH_UPGRADE_EXHAUST",
  [14] = "VEH_UPGRADE_FRONT_BUMPER",
  [15] = "VEH_UPGRADE_REAR_BUMPER",
  [16] = "VEH_UPGRADE_MISC"
}
Tuning.currentMenu = "category"

--[[

Tuning.camPos = {
  ["front"] = {-1995.25390625, 162.26243591309, 51.778945922852, -2002.6253662109, 62.671863555908, 46.546337127686},
  ["back"] = {-1995.8482666016, 145.80703735352, 51.639602661133, -1992.1895751953, 245.60299682617, 46.406993865967},
  ["right"] = {-1985.9364013672, 153.75267028809, 51.677310943604, -2085.5356445313, 156.91165161133, 43.311100006104},
  ["left"] = {-2004.5252685547, 154.01948547363, 51.886009216309, -1904.8430175781, 149.8719329834, 45.085762023926},
  ["top"] = {-1995.2438964844, 153.07389831543, 63.311256408691, -1994.9595947266, 162.12322998047, -36.278045654297}
}

]]
GUI.AddAjaxGetHandler("tuning", function(_, data)
  local veh = getPedOccupiedVehicle(localPlayer)

  if veh then
    if data.id == "category" then
      Tuning.currentMenu = "category"
      GUI.ExecuteJavascript("clearTunings();")
      for i=0, 16 do
        local upgrades = getVehicleCompatibleUpgrades(veh, i)

        if #upgrades > 0 then
          GUI.ExecuteJavascript('addTuning("'..Translations.Translate(Tuning.upgradeSlotNames[i])..'", "category-'..i..'");')
        end
      end
      GUI.ExecuteJavascript("addCloseTuning('Schließen', 'close');")
    elseif data.id == "close" then
      GUI.ExecuteJavascript("hideTuning();")
    else
      local tmp = split(data.id, '-')
      outputDebugString(data.id)
      if tmp[1] == "category" then

        if tmp[2] == "close" then

        else
          Tuning.currentMenu = tmp[1]

          GUI.ExecuteJavascript("clearTunings();")
          local upgrades = getVehicleCompatibleUpgrades(veh, tonumber(tmp[2]))

          for k, v in pairs(upgrades) do
            if Tuning.tuningNames[v] then
              GUI.ExecuteJavascript('addTuning("'..Tuning.tuningNames[v]..'", "tuning-'..v..'");')
            else
              outputChatBox("Cannot find "..v)
            end
          end
          GUI.ExecuteJavascript("addCloseTuning('Zurück', 'category');")
        end
      elseif tmp[1] == "tuning" then
        addVehicleUpgrade(veh, tonumber(tmp[2]))
      end
      outputChatBox("button clicked "..tostring(data.id))
    end
  else
    GUI.ExecuteJavascript("hideTuning();")
  end
end)

addCommandHandler("tuneup", function()
  local veh = getPedOccupiedVehicle(localPlayer)

  if veh then
    GUI.ExecuteJavascript("showTuning();")
    Tuning.currentMenu = "category"
    GUI.ExecuteJavascript("clearTunings();")
    for i=0, 16 do
      local upgrades = getVehicleCompatibleUpgrades(veh, i)

      if #upgrades > 0 then
        GUI.ExecuteJavascript('addTuning("'..Translations.Translate(Tuning.upgradeSlotNames[i])..'", "category-'..i..'");')
      end
    end
    GUI.ExecuteJavascript("addCloseTuning('Schließen');")
    --GUI.ExecuteJavascript("setButtonA")
    --local upgrades = getVehicleCompatibleUpgrades(veh)
  end


end)

addCommandHandler("posi", function(cmd, pos)
  if(Tuning.camPos[pos])then
    local x, y, z, lx, ly, lz = Tuning.camPos[pos][1], Tuning.camPos[pos][2], Tuning.camPos[pos][3], Tuning.camPos[pos][4], Tuning.camPos[pos][5], Tuning.camPos[pos][6]
    setCameraMatrix(x, y, z, lx, ly, lz)
  end
end)

addCommandHandler ( "carshowoff", function ( )
	local vehicle = getPedOccupiedVehicle ( localPlayer )
	if vehicle then
    local open = true
		for i=0,5 do
			setVehicleDoorOpenRatio ( vehicle, i, 1 - getVehicleDoorOpenRatio ( vehicle, i ), 2500 )
		end
    setTimer(function()
      if open then
        open = false
    		for i=0,5 do
    			setVehicleDoorOpenRatio ( vehicle, i, 0, 2500 )
    		end
      else
        open = true
    		for i=0,5 do
    			setVehicleDoorOpenRatio ( vehicle, i, 1, 2500 )
    		end
      end
    end, 3000, 0)
	end
end )

local draggingVehicle = nil
local distance = 8
addEventHandler("onClientClick", root, function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedWorld)
  if button == "right" then
    if state == "down" then
      if clickedWorld and not draggingVehicle then
        if getElementType(clickedWorld) == "vehicle" then
          distance = 8
          draggingVehicle = clickedWorld
        end
      end
    elseif state == "up" then
      draggingVehicle = nil
    end
  end
end)

addEventHandler("onClientCursorMove", root, function(cursorX, cursorY, absoluteX, absoluteY, worldX, worldY, worldZ)
  if draggingVehicle then
    local x, y, z = getWorldFromScreenPosition(absoluteX, absoluteY, distance)
    z = getGroundPosition(x, y, z + 20)
    setElementPosition(draggingVehicle, x, y, z + 0.8)
    local rx, ry, rz = getElementRotation(draggingVehicle)
    setElementRotation(draggingVehicle, rx, ry, 0)
  end
end)

bindKey("mouse_wheel_up", "down", function()
  if draggingVehicle then
    distance = distance + 0.8
  end
end)

bindKey("mouse_wheel_down", "down", function()
  if draggingVehicle then
    distance = distance - 0.8
  end
end)


Tuning.tuningNames = {
  [1000] = "Pro",
  [1001] = "Win",
  [1002] = "Drag",
  [1003] = "Alpha",
  [1004] = "Champ scoop",
  [1005] = "Fury scoop",
  [1006] = "Roof scoop",
  [1007] = "Side skirt Left",
  [1008] = "Nitro 5x",
  [1009] = "Nitro 2x",
  [1010] = "Nitro 10x",
  [1011] = "Race scoop",
  [1012] = "Worx scoop",
  [1013] = "Round fog lamps",
  [1014] = "Champ",
  [1015] = "Race",
  [1016] = "Worx",
  [1017] = "Side skirt Right",
  [1018] = "Upswept",
  [1019] = "Twin",
  [1020] = "Large",
  [1021] = "Medium",
  [1022] = "Small",
  [1023] = "Fury",
  [1024] = "Square fog lamps",
  [1025] = "Offroad",
  [1026] = "Side skirt Left (Alien)",
  [1027] = "Side skirt Right (Alien)",
  [1028] = "Exhaust (Alien)",
  [1029] = "Exhaust (X-flow)",
  [1030] = "Side skirt Right (X-flow)",
  [1031] = "Side skirt Left (X-flow)",
  [1032] = "Roof vent (Alien)",
  [1033] = "Roof vent (X-flow)",
  [1034] = "Side skirt Right (Alien)",
  [1035] = "Side skirt Left (Alien)",
  [1036] = "Exhaust (Alien)",
  [1037] = "Exhaust (X-flow)",
  [1038] = "Side skirt Right (X-flow)",
  [1039] = "Side skirt Left (X-flow)",
  [1040] = "Roof vent (Alien)",
  [1041] = "Roof vent (X-flow)",
  [1042] = "Side skirt Left (Chrome strip)",
  [1043] = "Exhaust (Slamin)",
  [1044] = "Exhaust (Chromer)",
  [1045] = "Side skirt Right (Alien)",
  [1046] = "Side skirt Left (Alien)",
  [1047] = "Exhaust (Alien)",
  [1048] = "Exhaust (X-flow)",
  [1049] = "Side skirt Right (X-flow)",
  [1050] = "Side skirt Left (X-flow)",
  [1051] = "Roof vent (Alien)",
  [1052] = "Roof vent (X-flow)",
  [1053] = "Spoiler (Alien)",
  [1054] = "Spoiler (X-flow)",
  [1055] = "Side skirt Right (Alien)",
  [1056] = "Side skirt Left (Alien)",
  [1057] = "Exhaust (Alien)",
  [1058] = "Exhaust (X-flow)",
  [1059] = "Side skirt Right (X-flow)",
  [1060] = "Side skirt Left (X-flow)",
  [1061] = "Roof vent (Alien)",
  [1062] = "Roof vent (X-flow)",
  [1063] = "Spoiler (Alien)",
  [1064] = "Spoiler (X-flow)",
  [1065] = "Side skirt Right (Alien)",
  [1066] = "Side skirt Left (Alien)",
  [1067] = "Exhaust (Alien)",
  [1068] = "Exhaust (X-flow)",
  [1069] = "Side skirt Right (X-flow)",
  [1070] = "Side skirt Left (X-flow)",
  [1071] = "Roof vent (Alien)",
  [1072] = "Roof vent (X-flow)",
  [1073] = "Shadow",
  [1074] = "Mega",
  [1075] = "Rimshine",
  [1076] = "Wires",
  [1077] = "Classic",
  [1078] = "Twist",
  [1079] = "Cutter",
  [1080] = "Switch",
  [1081] = "Grove",
  [1082] = "Import",
  [1083] = "Dollar",
  [1084] = "Trance",
  [1085] = "Atomic",
  [1086] = "Stereo bass boost",
  [1087] = "Hydraulics",
  [1088] = "Side skirt Right (Alien)",
  [1089] = "Side skirt Left (Alien)",
  [1090] = "Exhaust (Alien)",
  [1091] = "Exhaust (X-flow)",
  [1092] = "Side skirt Right (X-flow)",
  [1093] = "Side skirt Left (X-flow)",
  [1094] = "Roof vent (Alien)",
  [1095] = "Roof vent (X-flow)",
  [1096] = "Ahab",
  [1097] = "Virtual",
  [1098] = "Access",
  [1100] = "Bullbar (Chrome grill)",
  [1101] = "Side skirt Right (Chrome flames)",
  [1102] = "Side skirt Left (Chrome strip)",
  [1103] = "Roof (Convertible roof)",
  [1104] = "Exhaust (Chromer)",
  [1105] = "Exhaust (Slamin)",
  [1106] = "Side skirt Left (Chrome arches)",
  [1107] = "Side skirt Right (Chrome strip)",
  [1108] = "Side skirt Left (Chrome strip)",
  [1109] = "Rear bullbars (Chromer)",
  [1110] = "Rear bullbars (Slamin)",
  [1111] = "Unknown",
  [1112] = "Unknown",
  [1113] = "Exhaust (Chromer)",
  [1114] = "Exhaust (Slamin)",
  [1115] = "Front bullbars (Chromer)",
  [1116] = "Front bullbars (Slamin)",
  [1117] = "Front bumper (Chromer)",
  [1118] = "Side skirt Left (Chrome trim)",
  [1119] = "Side skirt Left (Wheelcovers)",
  [1120] = "Side skirt Right (Chrome trim)",
  [1121] = "Side skirt Right (Wheelcovers)",
  [1122] = "Side skirt Left (Chrome flames)",
  [1123] = "Bullbar (Chrome bars)",
  [1124] = "Side skirt Right (Chrome arches)",
  [1125] = "Bullbar (Chrome lights)",
  [1126] = "Exhaust (Chromer)",
  [1127] = "Exhaust (Slamin)",
  [1128] = "Roof (Vinyl hardtop)",
  [1129] = "Exhaust (Chromer)",
  [1130] = "Roof (Hardtop)",
  [1131] = "Roof (Softtop)",
  [1132] = "Exhaust (Slamin)",
  [1133] = "Side skirt Left (Chrome strip)",
  [1134] = "Side skirt Left (Chrome strip)",
  [1135] = "Exhaust (Slamin)",
  [1136] = "Exhaust (Chromer)",
  [1137] = "Side skirt Right (Chrome strip)",
  [1138] = "Spoiler (Alien)",
  [1139] = "Spoiler (X-flow)",
  [1140] = "Rear bumper (X-flow)",
  [1141] = "Rear bumper (Alien)",
  [1142] = "Oval vents Right",
  [1143] = "Oval vents Left",
  [1144] = "Square vents Right",
  [1145] = "Square vents Left",
  [1146] = "Spoiler (Alien)",
  [1147] = "Spoiler (X-flow)",
  [1148] = "Rear bumber (X-flow)",
  [1149] = "Rear bumber (Alien)",
  [1150] = "Rear bumber (X-flow)",
  [1151] = "Rear bumber (Alien)",
  [1152] = "Front bumper (Alien)",
  [1153] = "Front bumper (X-flow)",
  [1154] = "Rear bumber (X-flow)",
  [1155] = "Rear bumber (Alien)",
  [1156] = "Front bumper (Alien)",
  [1157] = "Front bumper (X-flow)",
  [1158] = "Spoiler (Alien)",
  [1159] = "Spoiler (X-flow)",
  [1160] = "Rear bumber (X-flow)",
  [1161] = "Rear bumber (Alien)",
  [1162] = "Front bumper (Alien)",
  [1163] = "Spoiler (Alien)",
  [1164] = "Spoiler (X-flow)",
  [1165] = "Rear bumber (X-flow)",
  [1166] = "Rear bumber (Alien)",
  [1167] = "Front bumper (Alien)",
  [1168] = "Front bumper (X-flow)",
  [1169] = "Front bumper (Alien)",
  [1170] = "Front bumper (X-flow)",
  [1171] = "Front bumper (Alien)",
  [1172] = "Front bumper (X-flow)",
  [1173] = "Front bumper (X-flow)",
  [1174] = "Front bumper (Chromer)",
  [1175] = "Front bumper (Slamin)",
  [1176] = "Rear bumper (Chromer)",
  [1177] = "Rear bumper (Slamin)",
  [1178] = "Rear bumper (Slamin)",
  [1179] = "Front bumper (Chromer)",
  [1180] = "Rear bumper (Chromer)",
  [1181] = "Front bumper (Slamin)",
  [1182] = "Front bumper (Chromer)",
  [1183] = "Rear bumper (Slamin)",
  [1184] = "Rear bumper (Chromer)",
  [1185] = "Front bumper (Slamin)",
  [1186] = "Rear bumper (Slamin)",
  [1187] = "Rear bumper (Chromer)",
  [1188] = "Front bumper (Slamin)",
  [1189] = "Front bumper (Chromer)",
  [1190] = "Front bumper (Slamin)",
  [1191] = "Front bumper (Chromer)",
  [1192] = "Rear bumper (Chromer)",
  [1193] = "Rear bumper (Slamin)"
}
