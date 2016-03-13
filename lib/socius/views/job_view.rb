module Socius
  class JobView < Metacosm::View
    belongs_to :city_view
    attr_accessor :origin, :dimensions, :citizen_ids, :name

    after_create { @citizen_ids = [] }

    def citizen_count
      citizen_ids.length
    end

    def render(window)
      if citizen_count && citizen_count > 0
        citizen_count.times do |i|
          window.citizen_image.draw(origin.x + 16*i,origin.y,0)
        end
      end
    end

    def bounding_box
      Geometer::Rectangle.new(origin, dimensions)
    end
  end
end
