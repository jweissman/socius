module Socius
  class ResourceMeterWidget < Metacosm::View
    include Geometer::PointHelpers

    attr_accessor :origin
    belongs_to :player_view
    has_many :resource_meter_views
    after_create :create_meters

    def render(window)
      window.resource_meters_image.draw(origin.x,origin.y,0)
      resource_meter_views.each do |resource_meter_view|
        resource_meter_view.render(window)
      end
    end

    def gold_meter
      resource_meter_views.where(resource: 'gold').first
    end

    def research_meter
      resource_meter_views.where(resource: 'research').first
    end

    def production_meter
      resource_meter_views.where(resource: 'production').first
    end

    def faith_meter
      resource_meter_views.where(resource: 'faith').first
    end

    def culture_meter
      resource_meter_views.where(resource: 'culture').first
    end

    protected
    def create_meters
      create_resource_meter_view(resource: 'production', origin: origin.translate(coord(8,44)), color: 0xff_b0d0f0)
      create_resource_meter_view(resource: 'gold',       origin: origin.translate(coord(8,196)), color: 0xff_f0f0a0)
      create_resource_meter_view(resource: 'research',   origin: origin.translate(coord(8,120)), color: 0xff_a0a0f0)
      create_resource_meter_view(resource: 'faith',      origin: origin.translate(coord(8,272)), color: 0xff_f0f0f0)
      create_resource_meter_view(resource: 'culture',    origin: origin.translate(coord(8,348)), color: 0xff_f0a0f0)
    end
  end
end


