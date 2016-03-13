module Socius
  class JobView < Metacosm::View
    belongs_to :job_tallies_widget
    attr_accessor :origin, :dimensions, :citizen_ids, :name

    after_create { @citizen_ids = [] }

    def citizen_count
      citizen_ids.length
    end

    def render(window, debug: false)
      if debug
        color = 0xaf_ffc0c0
        window.draw_quad(origin.x, origin.y, color,
                        origin.x + dimensions.width, origin.y, color,
                        origin.x, origin.y + dimensions.height, color,
                        origin.x + dimensions.width, origin.y + dimensions.height, color)
      end

      if citizen_count && citizen_count > 0
        citizen_count.times do |i|
          n = i % (dimensions.width / 16).to_i
          m = (i / (dimensions.width / 16)).to_i
          window.citizen_image.draw(origin.x + 2 + 16*n,origin.y+2+8*m,0)
        end
      end
    end

    def bounding_box
      Geometer::Rectangle.new(origin, dimensions)
    end
  end
end
