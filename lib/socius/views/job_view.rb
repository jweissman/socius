module Socius
  class JobView < Metacosm::View
    belongs_to :city_view
    attr_accessor :origin, :dimensions, :citizen_count, :name

    def render(window)
      p [ :render_job_view ]
      # need to render the citizen count
      if citizen_count && citizen_count > 0
        citizen_count.times do |i|
          window.citizen_image.draw(origin.x + 4*i,origin.y,0)
        end
      end
    end
  end
end
