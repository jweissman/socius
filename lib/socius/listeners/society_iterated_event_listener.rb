module Socius
  class SocietyIteratedEventListener < Metacosm::EventListener
    def receive(society_id:, production:, player_id:, micro_production:, gold:, micro_gold:)
      player_view = PlayerView.find_by(player_id: player_id)
      player_view.update(
        production: production, 
        micro_production: micro_production,
        gold: gold,
        micro_gold: micro_gold
      )
    end
  end
end
