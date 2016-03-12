module Socius
  class GameWindow < Gosu::Window
    attr_accessor :width, :height, :font, :production_cell_animation, :citizen_image
    attr_accessor :background_image
    attr_accessor :controller

    def initialize(headless: false)
      self.width = 512
      self.height = 512
      super(self.width, self.height)
      self.controller = GameController.new(self).prepare(headless)
    end

    def update
      controller.update
    end

    def draw
      controller.draw
    end

    def button_down(id)
      controller.button_down(id)
    end
  end
end
