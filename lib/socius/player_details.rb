module Socius
  class PlayerDetails < Struct.new(:player_id, :player_name, :player_color, :city_id, :city_name, :city_location)
    def to_h
      {
        player_id: player_id,
        player_name: player_name,
        player_color: player_color,
        city_id: city_id,
        city_name: city_name,
        city_location: city_location
      }
    end
  end
end
