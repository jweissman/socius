module Socius
  class PickupCitizenCommandHandler
    def handle(game_id:, citizen_id:, player_id:)
      p [ :pickup_citizen, game_id: game_id, citizen_id: citizen_id, player_id: player_id ]

      game = Game.find(game_id)
      citizen = Citizen.find(citizen_id)

      game.pickup(citizen, player_id: player_id)
    end
  end
end
