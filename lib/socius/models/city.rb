module Socius
  class City < Metacosm::Model
    attr_accessor :name
    belongs_to :society
    has_many :citizens
    after_create do
      2.times { create_citizen }
    end

    def iterate
      # TODO aggregate food + grow!

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

    def iteration_event
      CityIteratedEvent.create(
        city_id: self.id,
        society_id: society.id,
        citizen_ids_by_job: citizen_jobs_ids_hash
      )
    end
  end
end
