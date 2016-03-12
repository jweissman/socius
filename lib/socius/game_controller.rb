module Socius
  # wrap around a window
  class GameController < Struct.new(:window)
    include Geometer::PointHelpers

    # scale of the map?
    SCALE = 16

    def prepare(headless)
      @headless = headless

      window.caption = "Socius #{Socius::VERSION}"
      prepare_assets unless headless?
      conduct_sim
      self
    end

    def update
      simulation.fire(TickCommand.create(game_id: game_id))
    end

    def draw
      if headless?
        puts "WARNING: asked to #draw in headless mode, which is a no-op"
      else
        window.background_image.draw(0,0,0)
        game_view.render(window) if game_view
      end
    end

    def button_down(id)
      if id == Gosu::MsLeft then
        # TODO include geometer and point helpers
        command = game_view.clicked(at: coord(window.mouse_x, window.mouse_y))
        if command
          simulation.fire(command)
        end
      end
    end

    protected
    def headless?
      @headless == true
    end

    def conduct_sim
      simulation.apply(create_game)
      simulation.apply(setup_game)
      simulation.conduct!
    end

    def create_game
      CreateGameCommand.create(
        game_id: game_id,
        dimensions: [(window.width/SCALE).to_i, (window.height/SCALE).to_i]
      )
    end

    def setup_game
      SetupGameCommand.create(game_id: game_id, player_id: SecureRandom.uuid)
    end

    private
    def game_id
      @game_id ||= SecureRandom.uuid
    end

    def prepare_assets
      window.font = Gosu::Font.new(20)
      window.background_image = Gosu::Image.new("media/mockup.png")
      window.production_cell_animation = Gosu::Image::load_tiles("media/production_cell.png", 32, 32)
    end

    def simulation
      @sim ||= Metacosm::Simulation.current
    end

    def game_view
      GameView.find_by(game_id: game_id)
    end
  end
end
