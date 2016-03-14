module Socius
  class WorldIteratedEventListener < Metacosm::EventListener
    def receive(world_id:, tile_map:)
      # p [ :world_iterated, tile_map: tile_map ]
      world_view = WorldView.find_by world_id: world_id
      world_view.update tile_map: tile_map
    end
  end
end
