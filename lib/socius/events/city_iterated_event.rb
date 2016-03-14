module Socius
  class CityIteratedEvent < Metacosm::Event
    attr_accessor :society_id, :city_id
    attr_accessor :citizen_ids_by_job, :growth_progress, :starving
    attr_accessor :location
  end
end
