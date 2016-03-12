module Socius
  class Citizen < Metacosm::Model
    extend Forwardable

    attr_accessor :name
    belongs_to :city
    belongs_to :job

    after_create { self.job = Job.farmer }

    def production; job&.production || 0 end
    def gold; job&.gold || 0 end
    def food; job&.food || 0 end
    def research; job&.research || 0 end
    def faith; job&.faith || 0 end
    def culture; job&.culture || 0 end
  end
end
