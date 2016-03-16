module Socius
  class CityIteratedEvent < Metacosm::Event
    attr_accessor :society_id, :city_id, :player_id, :game_id
    attr_accessor :player_color
    attr_accessor :citizen_ids_by_job, :growth_progress, :starving
    attr_accessor :location, :claimed_territory
  end
end
