module Socius
  class CreateGameCommandHandler
    def handle(game_id:, dimensions:)
      Game.create(id: game_id, dimensions: dimensions)
    end
  end
end
