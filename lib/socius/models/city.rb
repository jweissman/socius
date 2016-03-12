module Socius
  class City < Metacosm::Model
    attr_accessor :name
    belongs_to :society
    has_many :citizens
    after_create { create_citizen }

    def iterate
      # TODO aggregate food + grow!

      emit(CityIteratedEvent.create({
        city_id: self.id, 
        society_id: society.id
      }.merge(citizen_jobs: citizen_jobs_hash)))
    end

    def citizen_jobs_hash
      citizens.all.inject({}) do |hash,citizen|
        job_sym = citizen.job.name.to_sym
        hash[job_sym] ||= 0
        hash[job_sym] += 1
        hash
      end
    end
  end
end
