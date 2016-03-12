module Socius
  class CityView < Metacosm::View
    include Geometer::PointHelpers
    include Geometer::DimensionHelpers

    attr_accessor :city_id, :city_name
    attr_reader :farm_tally

    belongs_to :player_view
    has_many   :job_views

    after_create {
      @farm_tally = create_job_view(name: 'farm', origin: coord(0,0), dimensions: dim(80,80), citizen_count: 0)
    }

    def render(window)
      job_views.each do |job_view|
        job_view.render(window)
      end
    end
  end
end
