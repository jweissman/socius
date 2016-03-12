module Socius
  class ResourceMeterView < Metacosm::View
    # belongs_to :player_view
    # attr_accessor :resource

    # attr_accessor :resource_name, :player_id
    def render(window, cell_animation:, origin:, progress:, resource_count:, color: 0xff_f00000)

      x0,y0 = *origin
      anim = cell_animation

      # render existing cells
      if resource_count > 0
        full_cell = anim[0]
        resource_count.times do |i|
          x = x0 + i * 24
          y = y0

          full_cell.draw(x,y,1,1,1,color) #,:add)
        end
      end

      # render progress
      if progress && resource_count < Society::RESOURCE_LIMIT
        frame = if progress == 0.0
          anim.size - 1
        else
          1 + ((1.0 - progress) * (anim.size-1).to_f).to_i
        end

        img = anim[frame]
        x,y = x0 + resource_count*24, y0
        img.draw(x,y,1,1,1,color) #,:add)
      end


      # TODO track each resource independently
      #      note that 2 workers need to produce twice as fast as one
    end
  end
end
