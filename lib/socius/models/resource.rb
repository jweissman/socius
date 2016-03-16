module Socius
  class Resource < Metacosm::Model
    attr_accessor :name, :amount, :progress
    belongs_to :society
    after_create { @amount = 0; @progress = 0; }

    def aggregate
      if @amount < Society::RESOURCE_LIMIT
        @progress += growth if growth
        if @progress >= step_increment
          @amount += 1
          @progress -= step_increment
        end
      end
    end

    def progress_as_percent
      progress / step_increment.to_f
    end

    def growth
      society.citizens.sum(name.to_sym)
    end

    def step_increment
      Game::STEP_LENGTH_IN_TICKS
    end
  end
end
