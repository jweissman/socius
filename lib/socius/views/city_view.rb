module Socius
  class CityView < Metacosm::View
    extend Forwardable

    include Geometer::PointHelpers
    include Geometer::DimensionHelpers

    attr_accessor :city_id, :city_name
    attr_accessor :growth_progress, :starving

    has_one :job_tallies_widget
    def_delegators :job_tallies_widget, :farm_tally, :mine_tally, :pray_tally, :trade_tally, :study_tally, :dream_tally

    after_create { create_job_tallies_widget(origin: coord(160,0)) }

    belongs_to :player_view
    has_many   :job_views, :through => :job_tallies_widget

    def render(window)
      # TODO if focused...
      job_tallies_widget.render(window)

      window.city_image.draw(304,156,1)

      if growth_progress
        anim = window.growth_meter_animation
        progress = growth_progress
        frame = if progress == 0.0
                  anim.size - 1
                else
                  1 + ((1.0 - progress) * (anim.size-1).to_f).to_i
                end
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
