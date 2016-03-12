module Socius
  class CityIteratedEvent < Metacosm::Event
    attr_accessor :society_id, :city_id, :citizen_ids_by_job
  end
end
