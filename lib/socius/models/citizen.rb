module Socius
  class Citizen < Metacosm::Model
    extend Forwardable

    attr_accessor :name
    belongs_to :city
    belongs_to :job

    after_create { self.job = Job.farmer; self.city.claim_tile }
    after_destroy { self.city.lose_tile }

    def production; (job && job.production) || 0 end
    def gold;       (job && job.gold) || 0 end
    def food;       (job && job.food) || 0 end
    def research;   (job && job.research) || 0 end
    def faith;      (job && job.faith) || 0 end
    def culture;    (job && job.culture) || 0 end
  end
end
