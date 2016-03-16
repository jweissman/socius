Thread.abort_on_exception = true

module Socius
  class GameServer
    include Geometer::DimensionHelpers

    def boot!
      t0 = Time.now
      p [ :game_server_boot! ]
      simulation.on_event :publish_to => :socius_event_stream
      cmd_thread = simulation.subscribe_for_commands :channel => :socius_command_queue
      simulation.disable_local_events

      p [:setup_game]
      simulation.fire(setup_game_command)

      p [ :conduct_sim ]
      simulation.conduct!
      p [ :game_server_booted!, elapsed: Time.now - t0 ]

      cmd_thread.join
    end

    def setup_game_command
      SetupGameCommand.create(
        game_id:      game_id,
        player_id:    SecureRandom.uuid,
        city_id:      SecureRandom.uuid,
        player_name:  "Caesar",
        city_name:    "Rome",
        dimensions:   World.standard_dimensions
      )
    end

    def player_one_id
      @player_one_id ||= SecureRandom.uuid
    end

    def game_id
      @game_id ||= SecureRandom.uuid
    end

    def simulation
      @sim ||= ::Socius::GameSimulation.current
    end
  end
end

class Socius::GameSimulation < Metacosm::Simulation
  def redis_connection
    # p [ :socius_sim_redis_conn ]
    Redis.new
  end
end

class Metacosm::Model
  def emit(event)
    ::Socius::GameSimulation.current.receive(event)
  end
end


