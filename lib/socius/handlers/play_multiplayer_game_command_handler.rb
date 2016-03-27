module Socius
  class PlayMultiplayerGameCommandHandler
    include Geometer::DimensionHelpers
    def handle(player_name:, player_id:)
      game = Game.first
      p [ :play_multiplayer_game, player_name: player_name, game_id: game.id ]
      game.admit_player(player_name: player_name, player_id: player_id)
    end
  end
end
