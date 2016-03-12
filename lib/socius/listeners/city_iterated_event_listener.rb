module Socius
  class CityIteratedEventListener < Metacosm::EventListener
    def receive(society_id:,city_id:,citizen_jobs:)
      city_view = CityView.find_by(city_id: city_id)
      update_job_tallies(city_view, citizen_jobs)
    end

    def update_job_tallies(city_view,farm:,trade:0,pray:0,dream:0,study:0)
      city_view.farm_tally.update(citizen_count: farm)
    end
  end
end
