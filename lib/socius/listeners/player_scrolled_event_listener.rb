module Socius
  class PlayerScrolledEventListener < Metacosm::EventListener
    def receive(game_id:, location:)
      game_view = GameView.find_by(game_id: game_id)
      game_view.world_view.update(center: location)

      city_view = game_view.city_views.all.detect do |view|
        view.location == location
      end

      if city_view
        game_view.player_view.update(focused_city_id: city_view.city_id)
      else
        game_view.player_view.update(focused_city_id: nil)
      end
    end
  end
end
