module Socius
  class CitizenPickedUpEventListener < Metacosm::EventListener
    def receive(game_id:)
      game_view = GameView.find_by(game_id: game_id)
      game_view.update(holding_citizen: true)
    end
  end
end
