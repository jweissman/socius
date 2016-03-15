module Socius
  class Game < Metacosm::Model
    attr_accessor :dimensions, :mode, :currently_held_citizen
    has_one :world
    has_many :players

    # TODO de-overload this... it no longer really means this
    #      it's like 'how hard it is to get a resource' (other than food which
    #      now has it's own logic...)
    STEP_LENGTH_IN_TICKS = 100

    def setup(player_name:, player_id:, city_name:, city_id:)
      w = create_world(dimensions: dimensions)
      player_one = create_player(id: player_id, name: player_name)
      society = player_one.create_society(world_id: world.id)
      capital = society.create_city(name: city_name, id: city_id)

      @ticks = 0
      emit(GameSetupEvent.create(world_id: w.id, world_map: w.tile_map, game_id: self.id, player_id: player_one.id, player_name: player_name, city_id: capital.id, city_name: city_name))
    end

    def tick
      @ticks += 1
      world.iterate
    end

    def pickup(citizen)
      self.currently_held_citizen = citizen
      self.currently_held_citizen.job_id = nil

      emit(CitizenPickedUpEvent.create(game_id: self.id))
    end

    def drop_citizen(new_job)
      self.currently_held_citizen.job_id = new_job.id
      self.currently_held_citizen = nil

      emit(CitizenDroppedEvent.create(game_id: self.id))
    end

    def scroll(location)
      emit(PlayerScrolledEvent.create(game_id: self.id, location: location))
    end
  end
end
