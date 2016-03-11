module Socius
  class PlayerView < Metacosm::View
    attr_accessor :name, :player_id, :production
    belongs_to :game_view
    # has_many :resource_meter_views

    def render(window, progress_towards_step)
      window.font.draw("Production (#{name}): #{production}", 100, 100, 1)
      cell_animation = window.production_cell_animation


      # origin of the first cell of prod meter
      x0,y0 = 8, 124

      ResourceMeterView.new.render(window, cell_animation: cell_animation, origin: [x0,y0], progress: progress_towards_step, resource_count: production)
      # render each prod cell
      # if production
      #   full_cell = anim[0]
      #   production.times do |i|
      #     x = x0 + i * 24
      #     y = y0
      #     full_cell.draw(x, y, 1, 1, 1)
      #   end
      # end

      # # render next prod cell
      # if progress_towards_step && (production && production < Society::PRODUCTION_LIMIT)
      #   if progress_towards_step == 0.0
      #     frame = anim.size - 1
      #   else
      #     frame = 1 + ((1.0-progress_towards_step) * (anim.size-1).to_f).to_i
      #   end
      #   p [ :progress, frame: frame, progress_towards_step: progress_towards_step ]
      #   img = anim[frame]
      #   x,y = x0 + production*24, y0
      #   img.draw(x, y, 1, 1, 1)
      # end
    end
  end
end
