module Socius
  class MultiplayerGameController < GameController
    def game_view
      @game_view ||= GameView.find_by(player_views: { player_id: active_player_id })
    end

    def update
      simulation.fire(ping) unless game_view.nil?
    end

    def prepare_sim_and_view
      simulation.conduct!
      simulation.fire(play_multiplayer_game)
    end

    def simulation
      @sim ||= RemoteGame.new
    end

    def play_multiplayer_game
      PlayMultiplayerGameCommand.create(player_name: player_name, player_id: active_player_id)
    end

    def ping
      PingCommand.create(
        player_name: player_name,
        player_id: active_player_id,
        game_id: game_view.game_id
      )
    end
  end

  class RemoteGame < Metacosm::RemoteSimulation
    def initialize
      super(:socius_command_queue, :socius_event_stream)
    end

    def redis_connection
      Redis.new
    end
  end
end
