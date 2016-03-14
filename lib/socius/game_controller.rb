module Socius
  class GameController < Struct.new(:window)
    include Geometer::PointHelpers
    include Geometer::DimensionHelpers

    def prepare(headless)
      @headless = headless

      window.caption = "Socius #{Socius::VERSION}"
      prepare_assets unless headless?

      simulation.conduct!
      simulation.fire(create_game)
      simulation.fire(setup_game)

      self
    end

    def update
      simulation.fire(TickCommand.create(game_id: game_id))
    end

    def draw
      if headless?
        puts "WARNING: asked game controller to #draw while headless (which is a no-op)"
      else
        game_view.render(window) if game_view
      end
    end

    def button_down(id)
      if id == Gosu::MsLeft then
        click!
      end
    end

    def click!
      command = game_view.clicked at: mouse_position
      if command
        simulation.fire(command)
      end
    end

    protected
    def prepare_assets
      t0 = Time.now
      p [ :loading_assets ]
      window.font = Gosu::Font.new(20)
      # window.background_image = Gosu::Image.new("media/mockup.png")
      window.production_cell_animation = Gosu::Image::load_tiles("media/production_cell.png", 32, 32)
      window.citizen_image = Gosu::Image.new("media/citizen.png")

      window.city_image = Gosu::Image.new("media/tower.png")
      window.growth_meter_animation = Gosu::Image.load_tiles("media/growth_meter.png", 56,12)

      window.cursor = Gosu::Image.new("media/cursor.png")

      window.job_view_menu_image = Gosu::Image.new("media/job_views.png")
      window.resource_meters_image = Gosu::Image.new("media/resource_meters.png")
      window.socius_logo = Gosu::Image.new("media/socius_logo.png")
      window.player_hand = Gosu::Image.new("media/player_hand.png")
      window.terrain_tiles = Gosu::Image.load_tiles("media/terrain.png",64,64) #16,16)

      window.big_logo = Gosu::Image.new("media/big_logo.png")

      p [ :asset_load_complete, elapsed: (Time.now-t0) ]
    end

    def mouse_position
      coord(window.mouse_x, window.mouse_y)
    end

    def headless?
      @headless == true
    end

    def create_game
      CreateGameCommand.create(game_id: game_id, dimensions: dim( 40, 40 ))
    end

    def setup_game
      SetupGameCommand.create(game_id: game_id, player_id: SecureRandom.uuid, city_id: SecureRandom.uuid, player_name: "Joe", city_name: "Cerulean City")
    end

    private
    def game_id
      @game_id ||= SecureRandom.uuid
    end


    def simulation
      @sim ||= Metacosm::Simulation.current
    end

    def game_view
      GameView.find_by(game_id: game_id)
    end
  end
end
