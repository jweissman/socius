module Socius
  class GameSetupEventListener < Metacosm::EventListener
    def receive(world_id:, world_map:, game_id:, player_id:, player_name:, city_id:, city_name:, game_dimensions:)
      game_view = GameView.where(game_id: game_id).first_or_create
      game_view.update(dimensions: game_dimensions)

      player_view = game_view.create_player_view(player_id: player_id, name: player_name)
      player_view.create_city_view(city_id: city_id, city_name: city_name)

      # start off with focus on capital
      player_view.focused_city_id = city_id

      # create world view
      game_view.create_world_view(world_id: world_id, tile_map: world_map)
    end
  end
end
