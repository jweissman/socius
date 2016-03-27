module Socius
  class Game < Metacosm::Model
    attr_accessor :mode, :currently_held_citizen
    attr_reader :already_setup, :driving

    has_one :world
    has_many :players

    after_create { @ticks=0 }

    STEP_LENGTH_IN_TICKS = 25

    def dimensions
      world.dimensions
    end

    def player_palette
      @player_colors ||= [ 0xf0c0a0f0, 0xf0a0c0a0, 0xf0a0f0c0 ]
    end

    def admit_player(player_name:,player_id:)
      player = create_player(id: player_id, name: player_name, color: player_palette.shift)
      society = player.create_society(world_id: world.id)
      capital = society.create_city(name: "Rome", id: SecureRandom.uuid)

      player_details = PlayerDetails.new(player.id, player.name, player.color, capital.id, capital.name, capital.location)

      emit(player_admitted_event(player_details))
    end

    def setup(dimensions:, player_name:, player_id:, city_name:, city_id:)
      create_world(dimensions: dimensions)

      player_two = create_player(id: SecureRandom.uuid, name: "Enemy AI", color: 0xf0c0a0c0)
      society_two = player_two.create_society(world_id: world.id)
      capital_two = society_two.create_city(name: "Enemy City", id: SecureRandom.uuid)
      player_two_details = PlayerDetails.new(player_two.id, player_two.name, player_two.color, capital_two.id, capital_two.name, capital_two.location)

      player_one = create_player(id: player_id, name: player_name, color: 0xf0a0c0a0)
      society_one = player_one.create_society(world_id: world.id)
      capital_one = society_one.create_city(name: city_name, id: city_id)

      player_one_details = PlayerDetails.new(player_one.id, player_one.name, player_one.color, capital_one.id, capital_one.name, capital_one.location)

      emit(setup_event(player_one_details, player_two_details))
      @already_setup = true
    end

    def tick
      @ticks += 1
      world.iterate
    end

    # TODO move out of model -- maybe it's a command that triggers itself?
    #      really should think about sagas (one for the whole game at least,
    #      since it might be a natural place to process win conditions...)
    def drive!
      @driver = Thread.new do
        while true
          tick
          sleep 0.1
        end
      end
      @driving = true
    end

    def ping(player_name, player_id, time)
      p [ :got_pinged, by: player_name, id: player_id, time: time   ]
    end

    def pickup(citizen, player_id:)
      player = Player.find(player_id)
      player.currently_held_citizen = citizen
      player.currently_held_citizen.job_id = nil

      # TODO move currently_held_citizen onto player obj
      # self.currently_held_citizen = citizen
      # self.currently_held_citizen.job_id = nil

      emit(CitizenPickedUpEvent.create(game_id: self.id, player_id: player_id))
    end

    def drop_citizen(new_job, player_id:)
      player = Player.find(player_id)
      player.currently_held_citizen.job_id = new_job.id
      player.currently_held_citizen = nil

      emit(CitizenDroppedEvent.create(game_id: self.id, player_id: player_id))
    end

    def scroll(location, player_id)
      emit(PlayerScrolledEvent.create(game_id: self.id, location: location, player_id: player_id))
    end

    protected
    def setup_event(player_one_details, player_two_details)
      GameSetupEvent.create(
        game_id: self.id,
        game_dimensions: self.dimensions,
        world_id: world.id,
        world_map: world.tile_map,
        player_one_details: player_one_details,
        player_two_details: player_two_details
      )
    end

    def player_admitted_event(player_details)
      PlayerAdmittedEvent.create(
        game_id: self.id,
        player_details: player_details,
        world_map: world.tile_map,
        world_id: world.id
      )
    end
  end
end
