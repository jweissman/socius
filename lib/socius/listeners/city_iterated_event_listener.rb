module Socius
  class CityIteratedEventListener < Metacosm::EventListener
    def receive(society_id:,city_id:,citizen_ids_by_job:)
      city_view = CityView.find_by(city_id: city_id)
      # p [ citizen_ids_by_job: citizen_ids_by_job ]
      update_job_tallies(city_view, citizen_ids_by_job || {})
    end

    def update_job_tallies(city_view,farm:[],trade:[],pray:[],dream:[],study:[])
      city_view.farm_tally.update(citizen_ids: farm)
      city_view.trade_tally.update(citizen_ids: trade)
      city_view.pray_tally.update(citizen_ids: pray)
      city_view.dream_tally.update(citizen_ids: dream)
      city_view.study_tally.update(citizen_ids: study)
    end
  end
end
