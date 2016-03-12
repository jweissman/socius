module Socius
  class SetupGameCommandHandler
    def handle(game_id:, player_id:, city_id:, player_name:, city_name:)
      game = Game.find(game_id)
      game.setup(
        player_name: player_name,
        city_name: city_name,
        player_id: player_id,
        city_id: city_id
      )
    end
  end
end
