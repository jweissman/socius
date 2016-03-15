module Socius
  class ScrollToLocationCommandHandler < Metacosm::Command
    def handle(game_id:, location:)
      game = Game.find(game_id)
      game.scroll(location)
    end
  end
end
