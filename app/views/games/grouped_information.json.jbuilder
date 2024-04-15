json.games @games do |game|
  json.id game.id
  json.total_kills game.total_kills
  json.players game.players
  json.kills game.kills
end
