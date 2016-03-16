module Socius
  class GameWindow < Gosu::Window
    attr_accessor :controller
    attr_accessor :width, :height
    attr_accessor :font
    attr_accessor :production_cell_animation, :citizen_image, :cursor
    attr_accessor :city_image, :growth_meter_animation
    attr_accessor :job_view_menu_image, :resource_meters_image
    attr_accessor :background_image
    attr_accessor :socius_logo, :player_hand, :terrain_tiles, :big_logo

    def initialize(headless: false, player_name:, multiplayer: false)
      self.width  = 800
      self.height = 600
      super(self.width, self.height)
      self.controller = multiplayer ? 
        MultiplayerGameController.new(self, player_name) :
        GameController.new(self, player_name) #, multiplayer)

      self.controller.prepare(headless)
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
