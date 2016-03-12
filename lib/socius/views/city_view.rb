module Socius
  class CityView < Metacosm::View
    include Geometer::PointHelpers
    include Geometer::DimensionHelpers

    attr_accessor :city_id, :city_name
    attr_reader :farm_tally, :mine_tally, :pray_tally, :trade_tally, :study_tally, :dream_tally

    belongs_to :player_view
    has_many   :job_views

    after_create {
      @farm_tally  = create_job_view(name: 'farm',  origin: coord(0,0),   dimensions: dim(80,80))
      @mine_tally  = create_job_view(name: 'mine',  origin: coord(80,0),  dimensions: dim(80,80))
      @pray_tally  = create_job_view(name: 'pray',  origin: coord(160,0), dimensions: dim(80,80))
      @trade_tally = create_job_view(name: 'trade', origin: coord(240,0), dimensions: dim(88,80))
      @study_tally = create_job_view(name: 'study', origin: coord(328,0), dimensions: dim(88,80))
      @dream_tally = create_job_view(name: 'dream', origin: coord(416,0), dimensions: dim(90,80))
    }

    def render(window)
      job_views.each do |job_view|
        job_view.render(window)
      end
    end

    def job_view_bounding_boxes
      job_views.all.inject({}) do |hash, job_view|
        hash[job_view] = job_view.bounding_box
        hash
      end
    end
  end
end
