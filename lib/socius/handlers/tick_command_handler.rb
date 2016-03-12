module Socius
  class TickCommandHandler
    def handle(game_id:)
      game = Game.find(game_id)
      game.tick
    end
  end
end
