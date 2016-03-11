module Socius
  class CreateGameCommand < Metacosm::Command
    attr_accessor :game_id, :dimensions
  end
end
