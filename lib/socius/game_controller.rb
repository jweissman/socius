module Socius
  class GameController < Struct.new(:window, :player_name)
    include Geometer::PointHelpers
    include Geometer::DimensionHelpers

    def prepare(headless)
      @headless = headless
      window.caption = "Socius #{Socius::VERSION}"
      prepare_assets unless headless?
      prepare_sim_and_view
      self
    end

    def prepare_sim_and_view
      GameView.create(game_id: game_id)
      simulation.conduct!
      simulation.fire(setup_game)
    end

    def update
      simulation.fire(TickCommand.create(game_id: game_id))
    end

    def draw
      if headless?
        puts "WARNING: asked game controller to #draw while headless (which is a no-op)"
      else
        # p [ :drawing, game_view: game_view ]
        # t0 = Time.now
        if game_view
          game_view.render(window, player_id: active_player_id) 
        else
          empty_game_view.render(window, player_id: active_player_id)
        end
        # p [ :render_complete, elapsed: Time.now - t0 ]
      end
    end

    def empty_game_view
      @empty_view ||= GameView.create
    end

    def button_down(id)
      if id == Gosu::MsLeft then
        click!
      end
    end

    def click!
      return unless game_view
      # p [ :simulation, simulation ]
      # binding.pry
      cmd = game_view.command_for_click(window, at: mouse_position, player_id: active_player_id) #, sim: simulation)bbbb
      simulation.apply(cmd) if cmd
    end

    protected
    def prepare_assets
      t0 = Time.now
      p [ :loading_assets ]
      window.font = Gosu::Font.new(20)

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

    def setup_game
      SetupGameCommand.create(game_id: game_id, player_id: active_player_id, city_id: SecureRandom.uuid, player_name: player_name, city_name: "Cerulean City", dimensions: World.standard_dimensions)
    end

    def active_player_id
      @active_player_id ||= SecureRandom.uuid
    end

    def game_view
      GameView.find_by(game_id: game_id)
    end

    def game_id
      @game_id ||= SecureRandom.uuid
    end

    def simulation
      @sim ||= Metacosm::Simulation.current
    end
  end
end
