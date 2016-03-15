module Socius
  class ScrollToLocationCommandHandler < Metacosm::Command
    def handle(game_id:, location:)
      game = Game.find(game_id)
      game.scroll(location)
      # emit(PlayerScrolledEvent.create(game_id: game_id, location: location))
    end
  end
end
