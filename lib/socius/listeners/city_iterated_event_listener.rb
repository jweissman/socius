Thread.abort_on_exception = true
module Socius
  class CityIteratedEventListener < Metacosm::EventListener
    def receive(society_id:, city_id:, player_id:, player_color:, game_id:, citizen_ids_by_job:, growth_progress:, starving:, location:, claimed_territory:)
      # p [ :city_iterated_event, city_id: city_id ]
      game_view = GameView.where(game_id: game_id).first_or_create
      player_view = game_view.player_views.where(player_id: player_id, color: player_color).first_or_create
      city_view = player_view.city_views.where(city_id: city_id).first_or_create

      #if city_view
        # p [ :updating_city_view, city_view_id: city_view.id, city_id: city_id, location: location ]

      city_view.update(
        growth_progress: growth_progress,
        starving: starving,
        location: location,
        claimed_territory: claimed_territory
      )

      update_job_tallies(city_view, citizen_ids_by_job || {})
      # p [ :updated_city_view, city_id: city_id ]
      # end
    end

    def update_job_tallies(city_view,farm:[],trade:[],pray:[],dream:[],study:[], mine:[])
      # p [ :updating_job_tallies ]
      city_view.farm_tally.update(citizen_ids: farm)
      city_view.trade_tally.update(citizen_ids: trade)
      city_view.pray_tally.update(citizen_ids: pray)
      city_view.dream_tally.update(citizen_ids: dream)
      city_view.study_tally.update(citizen_ids: study)
      city_view.mine_tally.update(citizen_ids: mine)
    end
  end
end
