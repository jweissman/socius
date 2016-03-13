module Socius
  class CityView < Metacosm::View
    include Geometer::PointHelpers
    include Geometer::DimensionHelpers

    attr_accessor :city_id, :city_name
    attr_reader :farm_tally, :mine_tally, :pray_tally, :trade_tally, :study_tally, :dream_tally

    attr_accessor :growth_progress, :starving

    belongs_to :player_view
    has_many   :job_views

    # TODO render out bounding boxes so we can visually debug offset issues
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

      window.city_image.draw(304,156,1)

      if growth_progress
        anim = window.growth_meter_animation
        progress = growth_progress


        frame = if progress == 0.0
                  anim.size - 1
                else
                  1 + ((1.0 - progress) * (anim.size-1).to_f).to_i
                end
        # p [ :city_view_render, growth_progress: growth_progress, growth_frame: frame, anim_size: anim.size ]
        img = anim[frame]
        img.draw(308,215,1,1,1,growth_meter_color)
      end
    end

    def growth_meter_color
      starving ? 0xf0_f0c0c0 : 0xf0_c0f0c0
    end

    def job_view_bounding_boxes
      job_views.all.inject({}) do |hash, job_view|
        hash[job_view] = job_view.bounding_box
        hash
      end
    end
  end
end
