module Socius
  class SocietyIteratedEventListener < Metacosm::EventListener
    def receive(society_id:, production:, player_id:)
      player_view = PlayerView.find_by(player_id: player_id)
      player_view.update(production: production)
    end
  end
end
