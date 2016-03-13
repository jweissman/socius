module Socius
  class JobTalliesWidget < Metacosm::View
    include Geometer::PointHelpers
    include Geometer::DimensionHelpers
    attr_accessor :origin
    attr_reader :farm_tally, :mine_tally, :pray_tally, :trade_tally, :study_tally, :dream_tally
    belongs_to :city_view
    has_many :job_views
    after_create :create_job_views

    def render(window)
      window.job_view_menu_image.draw(origin.x,origin.y,0)

      job_views.each do |job_view|
        job_view.render(window)
      end
    end

    def create_job_views
      @farm_tally  = create_job_view(name: 'farm',  origin: origin.translate(coord(0,0)),   dimensions: dim(80,80))
      @mine_tally  = create_job_view(name: 'mine',  origin: origin.translate(coord(80,0)),  dimensions: dim(76,80))
      @pray_tally  = create_job_view(name: 'pray',  origin: origin.translate(coord(156,0)), dimensions: dim(72,80))
      @trade_tally = create_job_view(name: 'trade', origin: origin.translate(coord(228,0)), dimensions: dim(89,80))
      @study_tally = create_job_view(name: 'study', origin: origin.translate(coord(316,0)), dimensions: dim(89,80))
      @dream_tally = create_job_view(name: 'dream', origin: origin.translate(coord(404,0)), dimensions: dim(109,80))
    end
  end
end
