module Socius
  class SetupGameCommandHandler
    def handle(dimensions:, game_id:, player_id:, city_id:, player_name:, city_name:)
      p [ :setup_game! ]
      game = Game.create(id: game_id)
      game.setup(
        dimensions: dimensions,
        player_name: player_name,
        city_name: city_name,
        player_id: player_id,
        city_id: city_id
      )
    end
  end
end
