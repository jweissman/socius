module Socius
  class PickupCitizenCommandHandler
    def handle(game_id:, citizen_id:)
      p [ :pickup_citizen, game_id: game_id, citizen_id: citizen_id ]

      game = Game.find(game_id)
      citizen = Citizen.find(citizen_id)

      game.pickup(citizen)
    end
  end
end
