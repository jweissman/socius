module Socius
  class SocietyIteratedEventListener < Metacosm::EventListener
    def receive(society_id:, player_id:, resources:)
      # p [ :society_iterated, player_id: player_id, resources: resources ]
      player_view = PlayerView.find_by(player_id: player_id) #.first_or_create # ??
      update_resource_meters(player_view, resources) if player_view
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

      # p [ :updating_player_view, player_view ]
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
