module Socius
  class GameCreatedEventListener < Metacosm::EventListener
    def receive(game_id:, dimensions:)
      GameView.create(game_id: game_id, dimensions: dimensions)
    end
  end
end
