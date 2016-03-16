module Socius
  class DropCitizenCommandHandler
    def handle(game_id:, new_job_name:, player_id:)
      game = Game.find(game_id)

      new_job = Job.citizen_job_list.detect do |job|
        job.name == new_job_name
      end

      p [ :drop_citizen_command_handler, new_job: new_job ]
      game.drop_citizen(new_job, player_id: player_id)
    end
  end
end
