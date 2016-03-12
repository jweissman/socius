module Socius
  class Citizen < Metacosm::Model
    extend Forwardable

    attr_accessor :name
    belongs_to :city
    belongs_to :job

    after_create { self.job = Job.farmer }

    def_delegators :job, :production, :gold, :food
  end
end
