require 'socius/version'
require 'metacosm'
require 'gosu'

require 'socius/models/job'
require 'socius/models/citizen'
require 'socius/models/city'
require 'socius/models/society'
require 'socius/models/world'
require 'socius/models/player'
require 'socius/models/game'

require 'socius/commands/create_game_command'
require 'socius/handlers/create_game_command_handler'

require 'socius/events/society_iterated_event'
require 'socius/listeners/society_iterated_event_listener'

require 'socius/views/player_view'
require 'socius/views/game_view'
require 'socius/views/partials/resource_meter_view'

require 'socius/game_window'

module Socius
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
      game_view.create_player_view(player_id: player_id, name: player_name, production: 0)
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
