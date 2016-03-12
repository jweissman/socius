module Socius
  class SocietyIteratedEventListener < Metacosm::EventListener
    def receive(society_id:, production:, player_id:, micro_production:, gold:, micro_gold:, research:, micro_research:)
      p [ :society_iterated, micro_production: micro_production, micro_gold: micro_gold, micro_research: micro_research ]
      player_view = PlayerView.find_by(player_id: player_id)
      player_view.update(
        production: production,
        production_progress: micro_production/100.0,
        gold: gold,
        gold_progress: micro_gold/100.0,
        research: research,
        research_progress: micro_research/100.0
      )
    end
  end
end
