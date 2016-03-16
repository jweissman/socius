module Socius
  class CitizenDroppedEventListener < Metacosm::EventListener
    def receive(game_id:, player_id:)
      game_view = GameView.find_by(game_id: game_id)
      player_view = game_view.player_views.where(player_id: player_id).first

      player_view.update(holding_citizen: false)

      # TODO need to update the player view
      # game_view.update holding_citizen: false
    end
  end
end
