module Socius
  class PingCommandHandler
    def handle(game_id:, player_id:, player_name:)
      game = Game.find(game_id)
      game.ping(player_name, player_id, Time.now)
    end
  end
end
