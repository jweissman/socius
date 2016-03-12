module Socius
  class GameCreatedEventListener < Metacosm::EventListener
    def receive(game_id:, dimensions:)
      p [ :game_created_event_listener ]
      GameView.create(game_id: game_id, dimensions: dimensions)
    end
  end
end
