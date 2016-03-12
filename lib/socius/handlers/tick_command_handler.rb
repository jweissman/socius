module Socius
  class TickCommandHandler
    def handle(game_id:)
      # p [ :tick_command_handler ]
      game = Game.find(game_id)
      game.tick
    end
  end
end
