module Socius
  class City < Metacosm::Model
    attr_accessor :name, :food_amount, :starving, :location

    belongs_to :society
    has_many :citizens
    has_many :tiles

    after_create do
      @food_amount = 1_000

      available_site = society.world.random_available_new_city_site
      @location ||= available_site

      claim_tile(at: @location)
      3.times { create_citizen }
    end

    def claim_tile(at: pick_tile_to_claim)
      tile_to_claim = society.world.tiles.where.at(at).first
      tiles << tile_to_claim
    end

    def lose_tile
      tiles.reject { |t| t == home_tile }.sample.city_id = nil #destroy
    end

    def iterate
      if !citizens.any?
        # TODO if it's the capital, the game is over for this player
        #      (investigate why this doesn't seem to run?)
        destroy
      else
        growth = citizens.sum(:food)
        @starving = growth < 0
        @food_amount += growth
        to_grow = food_required_to_grow
        if @food_amount >= to_grow
          @food_amount -= to_grow
          create_citizen
        elsif @food_amount < 0
          @food_amount = (to_grow / 2.0).to_i
          citizens.last.destroy
        end
      end

      emit(iteration_event)
    end

    protected
    def home_tile
      Tile.where.at(@location).first
    end

    def pick_tile_to_claim
      (tiles.flat_map(&:neighbors).uniq - tiles.all - society.world.claimed_tiles).
        min_by { |t| t.distance_to(home_tile) }.
        location
    end

    def citizen_jobs_ids_hash
      citizens.all.inject({}) do |hash,citizen|
        if citizen.job.nil?
          hash
        else
          job_sym = citizen.job.name.to_sym
          hash[job_sym] ||= []
          hash[job_sym] << citizen.id
          hash
        end
      end
    end

    def growth_progress
      @food_amount / food_required_to_grow.to_f
    end

    def food_required_to_grow
      1_000 + ((5*citizens.count) ** 2)
    end

    def iteration_event
      CityIteratedEvent.create(
        city_id: self.id,
        society_id: society.id,
        player_id: society.player.id,
        player_color: society.player.color,
        game_id: society.player.game.id,
        citizen_ids_by_job: citizen_jobs_ids_hash,
        growth_progress: growth_progress,
        starving: starving,
        location: location,
        claimed_territory: tiles.pluck(:location)
      )
    end
  end
end
