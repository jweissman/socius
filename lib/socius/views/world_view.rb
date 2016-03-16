module Socius
  class WorldView < Metacosm::View
    include Geometer::PointHelpers
    include Geometer::DimensionHelpers

    attr_accessor :world_id, :tile_map, :center #, :dimensions
    belongs_to :player_view

    SCALE = 64

    def render(window)
      if tile_map && center
        sz = SCALE
        screen_center = coord(window.width/2,window.height/2)
        offset = screen_center.translate(-center*sz)

        tile_map_image(window).draw(offset.x, offset.y, ZOrder::WorldMap)
        
        player_view.game_view.city_views.each do |city_view|
          city_view.render_city_view(window, offset: offset)
        end
      end
    end

    def tile_map_image(window)
      sz = SCALE
      @tile_map_image ||= window.record(sz*100,sz*100) do
        tiles = window.terrain_tiles
        grass, water = tiles[0], tiles[1]
        tile_map.each do |(loc,terrain)|
          frame = case terrain
                  when 'grass' then grass
                  when 'water' then water
                  end
          pos = loc*sz
          frame.draw(pos.x,pos.y, ZOrder::WorldMap)
        end
      end
    end

    def dereference_map_location_from_screen_position(pos, window:)
      sz = SCALE
      screen_center = coord(window.width/2,window.height/2)
      offset = screen_center.translate(-center*sz)

      dereferenced = pos.translate(-offset) / sz
      dereferenced.to_i
    end
  end
end
