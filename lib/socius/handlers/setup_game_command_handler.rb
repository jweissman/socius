module Socius
  class SetupGameCommandHandler
    def handle(game_id:, player_id:)
      game = Game.find(game_id)
      game.setup(player_id: player_id)
    end
  end
end
