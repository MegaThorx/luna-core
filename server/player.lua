Player = {}

Player.Spawn = function(player)
  -- TODO add multipler spawns u know bruh?
  spawnPlayer(player, -1983 + math.random(-5, 5), 138 + math.random(-5, 5), 28)
  fadeCamera(player, true)
  setCameraTarget(player, player)
end
