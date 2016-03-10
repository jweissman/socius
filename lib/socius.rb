require 'socius/version'
require 'metacosm'
require 'gosu'

module Socius
  class Job < Metacosm::Model
    attr_accessor :name
    attr_accessor :production, :food, :research, :gold
    has_many :citizens
    after_create { @production ||= 1 }

    def self.farmer
      @farmer ||= Job.create(name: "Farmer", production: 1, food: 2, research: 0, gold: 0)
    end
  end

  class Citizen < Metacosm::Model
    attr_accessor :name
    belongs_to :city
    belongs_to :job

    after_create { self.job = Job.farmer }

    def production
      job.production
    end
  end

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
      @production += citizens.sum :production
      emit(SocietyIteratedEvent.create(society_id: id, production: @production, player_id: player.id))
    end
  end

  class SocietyIteratedEvent < Metacosm::Event
    attr_accessor :society_id, :production, :player_id
  end

  class SocietyIteratedEventListener < Metacosm::EventListener
    def receive(society_id:, production:, player_id:)
      # find player view?
      player_view = PlayerView.find_by(player_id: player_id) #.first_or_create
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

    def setup(player_id:)
      create_world
      player_one = create_player(id: player_id)
      p1_society = player_one.create_society(world_id: world.id)
      p1_capital = p1_society.create_city
      p1_capital.create_citizen
      emit(GameSetupEvent.create(game_id: self.id, player_id: player_one.id))
    end

    def tick
      p [ :game, :tick! ]
      world.iterate
      emit(TickEvent.create(game_id: self.id))
    end
  end

  class GameView < Metacosm::View
    attr_accessor :game_id, :dimensions
    has_many :player_views

    def render(window)
      window.font.draw("Welcome to Socius", 100, 10, 1)
      player_views.each do |player_view|
        player_view.render(window)
      end
    end
  end

  class GameWindow < Gosu::Window
    SCALE = 16
    attr_accessor :width, :height, :font
    def initialize
      self.width = 640
      self.height = 480
      super(self.width, self.height)
      self.caption = "Socius #{Socius::VERSION}"
      @font = Gosu::Font.new(20)

      simulation.fire(
        CreateGameCommand.create(
          game_id: game_id,
          dimensions: [(self.width/SCALE).to_i, (self.height/SCALE).to_i]
        )
      )

      simulation.conduct!
    end

    def draw
      game_view = GameView.find_by(game_id: game_id)
      game_view.render(self) if game_view
    end

    protected
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
      fire(SetupGameCommand.create(game_id: game_id, player_id: SecureRandom.uuid))
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
    attr_accessor :game_id, :player_id
  end

  class GameSetupEventListener < Metacosm::EventListener
    def receive(game_id:, player_id:)
      p [ :game_setup! ]

      # create a player view
      game_view = GameView.find_by(game_id: game_id)
      game_view.create_player_view(player_id: player_id)

      # kick off circular tick command-event cycle
      fire(TickCommand.create(game_id: game_id))
    end
  end

  class TickCommand < Metacosm::Command
    attr_accessor :game_id
  end

  class TickCommandHandler
    def handle(game_id:)
      p [ :tick_command_handler ]
      game = Game.find(game_id)
      game.tick
    end
  end

  class TickEvent < Metacosm::Event
    attr_accessor :game_id
  end

  class TickEventListener < Metacosm::EventListener
    def receive(game_id:)
      p [ :tick_event_listener ]
      fire(TickCommand.create(game_id: game_id))
    end
  end

  # class CreateWorldCommand < Metacosm::Command
  #   attr_accessor :game_id, :world_id, :dimensions
  # end

  # class CreateWorldCommandHandler
  #   def handle(game_id:, world_id:, dimensions:)
  #     game = Game.find(game_id)
  #     game.create_world(id: world_id) #, dimensions: dimensions)
  #   end
  # end

  # class WorldCreatedEvent < Metacosm::Event
  #   attr_accessor :game_id, :world_id #, :dimensions
  # end

  # class WorldCreatedEventListener < Metacosm::EventListener
  #   def receive(game_id:, world_id:)
  #     # create world view?
  #     fire(
  #       CreatePlayerCommand.create(
  #         name: "Alice",
  #         game_id: game_id,
  #         player_id: SecureRandom.uuid
  #       )
  #     )
  #   end
  # end

  # class CreatePlayerCommand < Metacosm::Command
  #   attr_accessor :game_id, :player_id, :name
  # end

  # class CreatePlayerCommandHandler
  #   def handle(game_id:, player_id:, name:)
  #     p [ :create_player_command_handler ]
  #     game = Game.find(game_id)
  #     game.create_player(name: name, id: player_id, game_id: game_id)
  #   end
  # end

  # class PlayerCreatedEvent < Metacosm::Event
  #   attr_accessor :name, :player_id, :game_id
  # end

  # class PlayerCreatedEventListener < Metacosm::EventListener
  #   def receive(name:, player_id:, game_id:)
  #     p [ :player_created_event_listener ]
  #     game_view = GameView.find_by(game_id: game_id)
  #     game_view.create_player_view(name: name, player_id: player_id, production: 0)

  #     fire(CreateSocietyCommand.create(player_id: player_id, society_id: SecureRandom.uuid, game_id: game_id))
  #   end
  # end

  # class CreateSocietyCommand < Metacosm::Command
  #   attr_accessor :player_id, :society_id, :game_id
  # end

  # class CreateSocietyCommandHandler
  #   def handle(player_id:, society_id:, game_id:)
  #     player = Player.find(player_id)
  #     player.create_society(id: society_id, game_id: game_id)
  #   end
  # end

  # class SocietyCreatedEvent < Metacosm::Event
  #   attr_accessor :society_id, :game_id
  # end

  # class SocietyCreatedEventListener < Metacosm::EventListener
  #   def receive(society_id:, game_id:)
  #     fire(CreateCityCommand.create(game_id: game_id, society_id: society_id, city_id: SecureRandom.uuid))
  #     # fire(TickCommand.create(game_id: game_id))
  #   end
  # end

  # class CreateCityCommand < Metacosm::Command
  #   attr_accessor :game_id, :society_id, :city_id
  # end

  # class CreateCityCommandHandler
  #   def handle(game_id:, society_id:, city_id:)
  #     society = Society.find(society_id)
  #     society.create_city(city_id: city_id, game_id: game_id)
  #   end
  # end

  # class CityCreatedEvent < Metacosm::Event
  #   attr_accessor :city_id, :game_id
  # end

  # class CityCreatedEventListener < Metacosm::EventListener
  #   def receive(city_id:, game_id:)
  #     fire(CreateCitizenCommand.create(city_id: city_id, game_id: game_id, id: SecureRandom.uuid))
  #   end
  # end

  # class CreateCitizenCommand < Metacosm::Command
  #   attr_accessor :city_id, :game_id, :citizen_id
  # end

  # class CreateCitizenCommandHandler
  #   def handle(city_id:, game_id:, citizen_id:)
  #     city = City.find(city_id)
  #     city.create_citizen(game_id: game_id, id: citizen_id)
  #   end
  # end

  # class CitizenCreatedEvent < Metacosm::Event
  #   attr_accessor :citizen_id, :game_id
  # end

  # class CitizenCreatedEventListener < Metacosm::EventListener
  #   def receive(citizen_id:, game_id:)
  #     p [ :citizen_created! ]
  #   end
  # end


end
