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
  subject(:world) { World.create(name: "Ea") }

  it 'should have a name' do
    expect(world.name).to eq("Ea")
  end

  xit 'should have cities' do
    binding.pry
    world.create_city
    expect(world.cities.first).to be_a(City)
  end

  let(:setup_game_command) do
    SetupGameCommand.create(game_id: 'game_id')
  end

  let(:create_game_command) do
    CreateGameCommand.create(game_id: 'game_id', dimensions: 'dimensions')
  end
end

describe Society do
  subject(:society) { Society.create(name: "Romans", game_id: 'game_id') }
  it 'should have a name' do
    expect(society.name).to eq("Romans")
  end
end

describe CreateGameCommand do
  subject(:create_game_command) do
    CreateGameCommand.create(game_id: 'game_id', dimensions: 'dimensions')
  end

  let(:game_created_event) do
    GameCreatedEvent.create(game_id: 'game_id', dimensions: 'dimensions')
  end

  it 'should trigger game creation' do
    expect(create_game_command).to trigger_events(game_created_event)
  end
end

describe SetupGameCommand do
  subject(:setup_game_command) do
    SetupGameCommand.create(game_id: 'game_id', player_id: 'player_id')
  end

  let(:create_game_command) do
    CreateGameCommand.create(game_id: 'game_id', dimensions: 'dimensions')
  end

  let(:game_setup_event) do
    GameSetupEvent.create(game_id: 'game_id', player_id: 'player_id', player_name: "Alice")
  end

  it 'should trigger game steup' do
    Metacosm::Simulation.current.apply(create_game_command)

    expect(setup_game_command).to trigger_event(game_setup_event)
  end
end

describe TickCommand do
  subject(:tick_command) do
    TickCommand.create(game_id: 'game_id')
  end

  let(:setup_game_command) do
    SetupGameCommand.create(game_id: 'game_id', player_id: 'player_id')
  end

  let(:create_game_command) do
    CreateGameCommand.create(game_id: 'game_id', dimensions: 'dimensions')
  end

  let(:society_iterated_event) { 
    SocietyIteratedEvent.create(
      society_id: society.id, player_id: 'player_id',
      production: 0, production_progress: 0.01, 
      gold: 0,  gold_progress: 0.03,
      research: 0, research_progress: 0.02
    )
  }

  let(:society) { Society.last }

  let(:sim) { Metacosm::Simulation.current }

  before do
    sim.apply create_game_command
    sim.apply setup_game_command
  end

  it 'should trigger a society iteration event' do
    expect(tick_command).to trigger_event(society_iterated_event)
  end

  let(:ticks_per_step) { Game::STEP_LENGTH_IN_TICKS }
  it 'should accumulate production' do
    expect {ticks_per_step.times { sim.apply(tick_command)}}.to change{society.production.amount}.by(society.citizens.sum(:production))
  end
end
