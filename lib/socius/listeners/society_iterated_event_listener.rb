module Socius
  class SocietyIteratedEventListener < Metacosm::EventListener
    def receive(society_id:, player_id:, resources:)
      player_view = PlayerView.find_by(player_id: player_id)
      update_resource_meters(player_view, resources)
    end

    def update_resource_meters(player_view,
                               production:,
                               production_progress:,
                               gold:,
                               gold_progress:,
                               research:,
                               research_progress:,
                               culture:,
                               culture_progress:,
                               faith:,
                               faith_progress:)

      player_view.gold_meter.
        update(progress: gold_progress, resource_count: gold)

      player_view.research_meter.
        update(progress: research_progress, resource_count: research)

      player_view.production_meter.
        update(progress: production_progress, resource_count: production)

      player_view.faith_meter.
        update(progress: faith_progress, resource_count: faith)

      player_view.culture_meter.
        update(progress: culture_progress, resource_count: culture)
    end
  end
end
