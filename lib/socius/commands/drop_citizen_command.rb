module Socius
  class DropCitizenCommand < Metacosm::Command
    attr_accessor :game_id, :new_job_name, :player_id
  end
end
