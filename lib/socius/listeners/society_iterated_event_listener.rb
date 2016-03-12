module Socius
  class SocietyIteratedEventListener < Metacosm::EventListener
    def receive(society_id:, production:, player_id:, micro_production:, gold:, micro_gold:, research:, micro_research:)
      p [ :society_iterated, micro_production: micro_production, micro_gold: micro_gold, micro_research: micro_research ]
      player_view = PlayerView.find_by(player_id: player_id)

      player_view.gold_meter.
        update(progress: (micro_gold/100.0), resource_count: gold)

      player_view.research_meter.
        update(progress: (micro_research/100.0), resource_count: research)

      player_view.production_meter.
        update(progress: (micro_production/100.0), resource_count: production)

    end
  end
end
