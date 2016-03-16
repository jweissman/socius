module Socius
  class MultiplayerGameController < GameController
    def game_view
      @game_view ||= GameView.find_by(player_views: { player_id: active_player_id })
    end
     
    def update; end

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
  end

  class RemoteGame < Metacosm::RemoteSimulation
    def initialize
      super(:socius_command_queue, :socius_event_stream)
    end

    def redis_connection
      # p [ :remote_game_redis_conn ]
      # TODO extract to config?
      #      need to switch dev/prod...
      Redis.new
    end
  end
end
