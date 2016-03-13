module Socius
  class City < Metacosm::Model
    attr_accessor :name, :food_amount, :starving

    belongs_to :society
    has_many :citizens

    after_create do
      @food_amount = 1_000
      3.times { create_citizen }
    end

    def iterate
      if !citizens.any?
        # TODO we need to destroy this city
        #      (if it's the capital, the game is over for this player)
      else
        growth = citizens.sum(:food)
        @starving = growth < 0

        @food_amount += growth
        if @food_amount >= food_required_to_grow
          @food_amount -= food_required_to_grow
          create_citizen
        elsif @food_amount < 0
          @food_amount = (food_required_to_grow / 2.0).to_i
          citizens.last.destroy
        end
      end

      emit(iteration_event)
    end

    protected
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
      1_200 + ((25*citizens.count) ** 2)
    end

    def iteration_event
      CityIteratedEvent.create(
        city_id: self.id,
        society_id: society.id,
        citizen_ids_by_job: citizen_jobs_ids_hash,
        growth_progress: growth_progress,
        starving: starving
      )
    end
  end
end
