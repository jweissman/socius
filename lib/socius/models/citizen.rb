module Socius
  class Citizen < Metacosm::Model
    attr_accessor :name
    belongs_to :city
    belongs_to :job

    after_create { self.job = Job.farmer }

    def production
      job.production
    end

    def food
      job.food
    end
  end
end
