module Socius
  class CitizenPickedUpEventListener < Metacosm::EventListener
    def receive(game_id:, player_id:)
      game_view = GameView.find_by(game_id: game_id)
      player_view = game_view.player_views.where(player_id: player_id).first
      player_view.update(holding_citizen: true)
    end
  end
end
