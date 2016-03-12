module Socius
  class Society < Metacosm::Model
    attr_accessor :name, :game_id

    RESOURCE_LIMIT = 6
    RESOURCE_NAMES = %w[ production gold research faith culture ]

    belongs_to :world
    belongs_to :player

    has_many :resources
    has_many :cities
    has_many :citizens, :through => :cities

    after_create do
      RESOURCE_NAMES.each do |resource_name|
        create_resource(name: resource_name)
      end
    end

    def iterate
      resources.each(&:aggregate)
      cities.each(&:iterate)
      emit iteration_event
    end

    RESOURCE_NAMES.each do |resource_name|
      define_method(resource_name.to_sym) do
        resources.where(name: resource_name).first
      end
    end

    protected
    def iteration_event
      SocietyIteratedEvent.create(
        {
          society_id: self.id,
          player_id: player.id
        }.merge(resources: resources_hash)
      )
    end

    def resources_hash
      resources.inject({}) do |hash, resource|
        # resource = send(resource.name.to_sym)
        hash[:"#{resource.name}"] = resource.amount
        hash[:"#{resource.name}_progress"] = resource.progress_as_percent
        hash
      end
    end
  end
end
