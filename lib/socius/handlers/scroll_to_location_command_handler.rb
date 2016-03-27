module Socius
  class ScrollToLocationCommandHandler
    def handle(game_id:, player_id:, location:)
      game = Game.find(game_id)
      game.scroll(location, player_id)
    end
  end
end
