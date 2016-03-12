module Socius
  class GameSetupEventListener < Metacosm::EventListener
    def receive(game_id:, player_id:, player_name:)
      game_view = GameView.find_by(game_id: game_id)
      game_view.create_player_view(player_id: player_id, name: player_name) #, production: 0)
    end
  end
end
