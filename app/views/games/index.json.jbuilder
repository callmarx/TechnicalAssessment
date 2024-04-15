json.meta do
  json.current_page @games.current_page
  json.total_pages @games.total_pages
  json.total_count @games.total_count
  json.per_page @games.limit_value
end

json.games @games do |game|
  json.id game.id
  json.total_kills game.total_kills
  json.players game.players
  json.kills game.kills
end
