module Socius
  class Game < Metacosm::Model
    attr_accessor :dimensions
    has_one :world
    has_many :players

    STEP_LENGTH_IN_TICKS = 100

    def setup(player_name:, player_id:, city_name:, city_id:)
      create_world
      player_one = create_player(id: player_id, name: player_name)
      society = player_one.create_society(world_id: world.id)
      capital = society.create_city(name: city_name, id: city_id)

      @ticks = 0
      emit(GameSetupEvent.create(game_id: self.id, player_id: player_one.id, player_name: player_name, city_id: capital.id, city_name: city_name))
    end

    def tick
      @ticks += 1
      world.iterate
    end
  end
end
