module Socius
  class PlayerScrolledEventListener < Metacosm::EventListener
    def receive(game_id:, location:, player_id:)
      p [ :player_scrolled!, player_id: player_id, location: location ]
      game_view = GameView.find_by(game_id: game_id)

      player_view = game_view.player_views.where(player_id: player_id).first

      if player_view && player_view.world_view
        player_view.world_view.update(center: location)

        city_view = player_view.city_views.all.detect do |view|
          view.location == location
        end

        p [ :scrolled_to_city?, city_view: city_view ]

        if city_view
          p [ :updated_focused_city_id, new_focused_city_id: city_view.city_id ]
          player_view.update(focused_city_id: city_view.city_id)
        else
          player_view.update(focused_city_id: nil)
        end
      end
    end
  end
end
