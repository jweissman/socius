module Socius
  class GameWindow < Gosu::Window
    SCALE = 16
    attr_accessor :width, :height, :font, :production_cell_animation
    def initialize
      self.width = 512
      self.height = 512
      super(self.width, self.height)
      self.caption = "Socius #{Socius::VERSION}"
      @font = Gosu::Font.new(20)

      simulation.apply(create_game)
      simulation.apply(setup_game)
      simulation.conduct!

      @background_image = Gosu::Image.new("media/mockup.png")

      @production_cell_animation = Gosu::Image::load_tiles("media/production_cell.png", 32, 32)
    end

    def update
      simulation.fire(TickCommand.create(game_id: game_id))
    end

    def draw
      @background_image.draw(0,0,0)
      game_view = GameView.find_by(game_id: game_id)
      game_view.render(self) if game_view
    end

    protected
    def create_game
      CreateGameCommand.create(
        game_id: game_id,
        dimensions: [(self.width/SCALE).to_i, (self.height/SCALE).to_i]
      )
    end

    def setup_game
      SetupGameCommand.create(game_id: game_id, player_id: SecureRandom.uuid)
    end

    private
    def game_id
      @game_id ||= SecureRandom.uuid
    end

    def simulation
      @sim ||= Metacosm::Simulation.current
    end
  end

end
