module Socius
  class SocietyIteratedEventListener < Metacosm::EventListener
    def receive(
      society_id:,
      player_id:, 
      production:, 
      production_progress:, 
      gold:, 
      gold_progress:, 
      research:, 
      research_progress:)

      player_view = PlayerView.find_by(player_id: player_id)

      player_view.gold_meter.
        update(progress: gold_progress, resource_count: gold)

      player_view.research_meter.
        update(progress: research_progress, resource_count: research)

      player_view.production_meter.
        update(progress: production_progress, resource_count: production)

    end
  end
end
