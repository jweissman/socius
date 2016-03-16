require 'spec_helper'
require 'metacosm/support/spec_harness'
require 'pry'
require 'socius'

describe Socius do
  it "should have a VERSION constant" do
    expect(subject.const_get('VERSION')).to_not be_empty
  end
end

describe World do
  include Geometer::DimensionHelpers
  subject(:world) { World.create(name: "Ea", dimensions: dim(2,2)) }

  it 'should have a name' do
    expect(world.name).to eq("Ea")
  end
end

describe Society do
  subject(:society) { Society.create(name: "Romans", game_id: 'game_id') }
  it 'should have a name' do
    expect(society.name).to eq("Romans")
  end
end

describe TickCommand do
  include Geometer::DimensionHelpers
  subject(:tick_command) do
    TickCommand.create(game_id: 'game_id')
  end

  let(:setup_game_command) do
    SetupGameCommand.create(game_id: 'game_id', player_id: 'player_id', player_name: 'Thomas', city_name: 'London', city_id: 'city_id', dimensions: dim(10,10))
  end

  let(:society_iterated_event) {
    SocietyIteratedEvent.create(
      society_id: society.id, player_id: 'player_id',
      resources: {
        production: 0, production_progress: 0.00,
        gold: 0,  gold_progress: 0.00,
        research: 0, research_progress: 0.0,
        faith: 0, faith_progress: 0.0,
        culture: 0, culture_progress: 0.0
      }
    )
  }

  let(:citizen_count) { 3 }

  let(:society) { Society.last }

  let(:sim) { Metacosm::Simulation.current }

  before do
    sim.apply setup_game_command
  end

  it 'should trigger a society iteration event' do
    expect(tick_command).to trigger_event(society_iterated_event)
  end

  let(:ticks_per_step) { Game::STEP_LENGTH_IN_TICKS }
  it 'should accumulate production', speed: :slow do
    expect {ticks_per_step.times { sim.apply(tick_command)}}.to change{society.production.amount}.by(society.citizens.sum(:production))
  end
end

describe GameController do
  subject(:game_controller) { GameController.new(window) }
  let(:window)              { instance_double(Gosu::Window, mouse_x: 0, mouse_y: 0) }
  let(:left_mouse_btn)      { Gosu::MsLeft }
  let(:game_view)           { instance_spy(GameView) }
  let(:command)             { :some_command }
  let(:sim)                 { instance_double(Metacosm::Simulation) }

  it 'should trigger game view processing on clicks' do
    allow(game_controller).to receive(:game_view).and_return(game_view)
    allow(game_controller).to receive(:simulation).and_return(sim)
    allow(game_view).to receive(:command_for_click).once.and_return(command)

    expect(sim).to receive(:apply).with(command)

    game_controller.button_down(left_mouse_btn)
  end
end
