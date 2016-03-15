module Socius
  class WorldView < Metacosm::View
    include Geometer::PointHelpers
    include Geometer::DimensionHelpers

    attr_accessor :world_id, :tile_map, :center
    belongs_to :game_view

    SCALE = 64

    def render(window) #, center: coord(0,0))
      if tile_map && center
        # p [ :render_world_view, center: center ]
        tiles = window.terrain_tiles
        sz = SCALE
        screen_center = coord(window.width/2,window.height/2)
        offset = screen_center.translate(-center*sz)

        # visible_tiles(window, center)
        grass, water = *tiles
        visible_tiles(center).each do |(loc,terrain)|
          frame = case terrain
                  when 'grass' then grass
                  when 'water' then water
                  end
          # img = tiles[frame]

          pos = (loc*sz).translate(offset)
          frame.draw(pos.x,pos.y, 0)
        end

        game_view.city_views.each do |city_view|
          city_view.render_city_view(window, offset: offset)
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

    def visible_tiles(center)
      @visible_tile_set ||= {}
      @visible_tile_set[center] ||= compute_visible_tiles_for(center)
    end

    def compute_visible_tiles_for(center)
      p [ :recomputing_visible_tiles, center: center ]
      screen_box ||= Geometer::Rectangle.new(center.translate(coord(-7,-5)), dim(14,10))
      tile_map.select do |loc,_|
        screen_box.contains?(loc)
      end
    end
  end
end
