module Socius
  class GameSetupEventListener < Metacosm::EventListener
    def receive(world_id:, world_map:, game_id:, game_dimensions:, player_one_details:, player_two_details:)
      game_view = GameView.where(game_id: game_id).first_or_create
      game_view.update(dimensions: game_dimensions)

      p [ :creating_player_views ]
      create_player_view(game_id, game_view, world_id, world_map, player_two_details.to_h)
      create_player_view(game_id, game_view, world_id, world_map, player_one_details.to_h)
    end

    def create_player_view(game_id, game_view, world_id, world_map, player_id:, player_name:, player_color:, city_id:, city_name:, city_location:)
      player_view = game_view.create_player_view(player_id: player_id, name: player_name, color: player_color)

      player_view.create_world_view(world_id: world_id, tile_map: world_map)

      player_view.create_city_view(city_id: city_id, city_name: city_name, location: city_location)
      p [ :creating_city_view, city_id: city_id, city_location: city_location ]
      # player_view.focused_city_id = city_id

      fire(ScrollToLocationCommand.create(player_id: player_id, game_id: game_id, location: city_location))
    end
  end
end
