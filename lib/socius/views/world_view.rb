module Socius
  class WorldView < Metacosm::View
    include Geometer::PointHelpers

    attr_accessor :world_id, :tile_map
    belongs_to :game_view

    SCALE = 64

    def render(window, center: coord(0,0))
      if tile_map
        tiles = window.terrain_tiles
        sz = SCALE
        screen_center = coord(window.width/2,window.height/2)
        offset = screen_center.translate(-center*sz)

        tile_map.each do |(loc,terrain)|
          frame = case terrain
                  when 'grass' then 0
                  when 'water' then 1
                  end
          img = tiles[frame]

          pos = (loc*sz).translate(offset)
          img.draw(pos.x,pos.y, 0)
        end

        game_view.city_views.each do |city_view|
          city_view.render_city_view(window, offset: offset)
        end
      end
    end
  end
end
