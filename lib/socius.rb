require 'socius/version'
require 'metacosm'
require 'gosu'

require 'socius/models/job'
require 'socius/models/citizen'

module Socius
  class City < Metacosm::Model
    attr_accessor :name
    belongs_to :society
    has_many :citizens
    after_create { create_citizen }
  end

  class Society < Metacosm::Model
    attr_accessor :name, :production, :game_id

    belongs_to :world
    belongs_to :player
    has_many :cities
    has_many :citizens, :through => :cities

    after_create { @production = 0; create_city }

    def iterate
      aggregate_production!
      emit(SocietyIteratedEvent.create(society_id: id, production: @production, player_id: player.id))
    end

    protected
    def aggregate_production!
      @production += citizens.sum :production
    end
  end

  class SocietyIteratedEvent < Metacosm::Event
    attr_accessor :society_id, :production, :player_id
  end

  class SocietyIteratedEventListener < Metacosm::EventListener
    def receive(society_id:, production:, player_id:)
      player_view = PlayerView.find_by(player_id: player_id)
      player_view.production = production
    end
  end

  class World < Metacosm::Model
    attr_accessor :name, :dimensions
    belongs_to :game
    has_many :societies
    has_many :cities, :through => :societies

    def iterate
      p [ :world, :iterate ]
      societies.each(&:iterate)
    end
  end

  class Player < Metacosm::Model
    attr_accessor :name
    belongs_to :game
    has_one :society
  end

  class PlayerView < Metacosm::View
    attr_accessor :name, :player_id, :production
    belongs_to :game_view

    def render(window)
      window.font.draw("Production (#{name}): #{production}", 100, 100, 1)
    end
  end

  class Game < Metacosm::Model
    attr_accessor :dimensions
    has_one :world
    has_many :players

    STEP_LENGTH_IN_TICKS = 100

    def setup(player_name: "Alice", player_id:)
      create_world
      player_one = create_player(id: player_id, name: player_name)
      player_one.create_society(world_id: world.id)

      @ticks = 0
      emit(GameSetupEvent.create(game_id: self.id, player_id: player_one.id, player_name: player_name))
    end

    def tick
      p [ :game, :tick! ]

      @ticks += 1
      progress_towards_step = ((@ticks%STEP_LENGTH_IN_TICKS) / STEP_LENGTH_IN_TICKS.to_f)

      if (@ticks % STEP_LENGTH_IN_TICKS) == 0
        world.iterate 
        # emit iteration event?
      end

      emit(TickEvent.create(game_id: self.id, progress_towards_step: progress_towards_step))
    end
  end

  class GameView < Metacosm::View
    attr_accessor :game_id, :dimensions, :progress_towards_step
    has_many :player_views

    def render(window)
      window.font.draw("Welcome to Socius", 100, 10, 1)
      window.font.draw("#{(progress_towards_step*100.0).to_i}%", 100, 40, 1) if progress_towards_step
      player_views.each do |player_view|
        player_view.render(window)
      end
    end
  end

  class GameWindow < Gosu::Window
    SCALE = 16
    attr_accessor :width, :height, :font
    def initialize
      self.width = 512
      self.height = 512
      super(self.width, self.height)
      self.caption = "Socius #{Socius::VERSION}"
      @font = Gosu::Font.new(20)

      simulation.apply(create_game)
      simulation.apply(setup_game)
      simulation.conduct!

      @background_image = Gosu::Image.new("media/mockup.png") #, :tileable => true)
    end

    def update
      simulation.fire(TickCommand.create(game_id: game_id))
    end

    def draw
      @background_image.draw(0,0,0)
      game_view = GameView.find_by(game_id: game_id)
      game_view.render(self) if game_view
    end

    protected
    def create_game
      CreateGameCommand.create(
        game_id: game_id,
        dimensions: [(self.width/SCALE).to_i, (self.height/SCALE).to_i]
      )
    end

    def setup_game
      SetupGameCommand.create(game_id: game_id, player_id: SecureRandom.uuid)
    end

    private
    def game_id
      @game_id ||= SecureRandom.uuid
    end

    def simulation
      @sim ||= Metacosm::Simulation.current
    end
  end

  class CreateGameCommand < Metacosm::Command
    attr_accessor :game_id, :dimensions
  end

  class CreateGameCommandHandler
    def handle(game_id:, dimensions:)
      Game.create(id: game_id, dimensions: dimensions)
    end
  end

  class GameCreatedEvent < Metacosm::Event
    attr_accessor :game_id, :dimensions
  end

  class GameCreatedEventListener < Metacosm::EventListener
    def receive(game_id:, dimensions:)
      p [ :game_created_event_listener ]
      GameView.create(game_id: game_id, dimensions: dimensions)
    end
  end

  class SetupGameCommand < Metacosm::Command
    attr_accessor :game_id, :player_id
  end

  class SetupGameCommandHandler
    def handle(game_id:, player_id:)
      game = Game.find(game_id)
      game.setup(player_id: player_id)
    end
  end

  class GameSetupEvent < Metacosm::Event
    attr_accessor :game_id, :player_id, :player_name
  end

  class GameSetupEventListener < Metacosm::EventListener
    def receive(game_id:, player_id:, player_name:)
      game_view = GameView.find_by(game_id: game_id)
      game_view.create_player_view(player_id: player_id, name: player_name)
    end
  end

  class TickCommand < Metacosm::Command
    attr_accessor :game_id
  end

  class TickCommandHandler
    def handle(game_id:)
      # p [ :tick_command_handler ]
      game = Game.find(game_id)
      game.tick
    end
  end

  class TickEvent < Metacosm::Event
    attr_accessor :game_id, :progress_towards_step
  end

  class TickEventListener < Metacosm::EventListener
    def receive(game_id:, progress_towards_step:)
      # p [ :tick_event_listener ]
      game_view = GameView.find_by(game_id: game_id)
      game_view.update(progress_towards_step: progress_towards_step)
    end
  end
end
