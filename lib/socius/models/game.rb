module Socius
  class Game < Metacosm::Model
    attr_accessor :dimensions
    has_one :world
    has_many :players

    STEP_LENGTH_IN_TICKS = 100

    def setup(player_name: "Alice", player_id:)
      create_world
      player_one = create_player(id: player_id, name: player_name)
      player_one.create_society(world_id: world.id)

      @ticks = 0
      emit(GameSetupEvent.create(game_id: self.id, player_id: player_one.id, player_name: player_name))
    end

    def tick
      p [ :game, :tick! ]

      @ticks += 1
      progress_towards_step = ((@ticks%STEP_LENGTH_IN_TICKS) / STEP_LENGTH_IN_TICKS.to_f)

      if (@ticks % STEP_LENGTH_IN_TICKS) == 0
        world.iterate
        # emit iteration event?
      end

      emit(TickEvent.create(game_id: self.id, progress_towards_step: progress_towards_step))
    end
  end
end
