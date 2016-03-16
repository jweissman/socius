module Socius
  class PlayerAdmittedEventListener < Metacosm::EventListener
    def receive(game_id:, player_details:, world_map:, world_id:)
      p [ :player_joined!, world_id: world_id, game_id: game_id ]
      game_view = GameView.where(game_id: game_id).first_or_create
      create_player_view(game_view, game_id, world_id, world_map, player_details.to_h)
    end

    def create_player_view(game_view, game_id, world_id, world_map, player_id:, player_name:, player_color:, city_id:, city_name:, city_location:)
      player_view = game_view.create_player_view(player_id: player_id, name: player_name, color: player_color)

      player_view.create_world_view(world_id: world_id, tile_map: world_map)

      player_view.create_city_view(city_id: city_id, city_name: city_name, location: city_location)

      fire(ScrollToLocationCommand.create(player_id: player_id, game_id: game_id, location: city_location))
    end
  end
end
