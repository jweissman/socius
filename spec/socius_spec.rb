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

  # let(:society) { world.create_society(game_id: 'game_id') }

  # it 'should be iterable' do
  #   Metacosm::Simulation.current.apply(create_game_command)
  #   Metacosm::Simulation.current.apply(setup_game_command)
  #   binding.pry
  #   w = World.first
  #   expect {w.iterate}.to change{society.production}.by(society.citizens.sum(:production))
  # end
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
    GameSetupEvent.create(game_id: 'game_id', player_id: 'player_id')
  end

  it 'should trigger game steup' do
    Metacosm::Simulation.current.apply(create_game_command)

    expect(setup_game_command).to trigger_events(game_setup_event)
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

  let(:tick_event) { TickEvent.create(game_id: 'game_id') }

  let(:society) { Society.last }

  let(:sim) { Metacosm::Simulation.current }

  before do
    sim.apply create_game_command
    sim.apply setup_game_command
  end

  it 'should trigger a tick event' do
    expect(tick_command).to trigger_events(tick_event)
  end

  it 'should accumulate production' do
    expect {sim.apply(tick_command)}.to change{society.production}.by(society.citizens.sum(:production))
  end
end

# describe IterateC
## let(:society) { world.create_society(game_id: 'game_id') }

  # it 'should be iterable' do
  #   Metacosm::Simulation.current.apply(create_game_command)
  #   Metacosm::Simulation.current.apply(setup_game_command)
  #   binding.pry
  #   w = World.first
  #   expect {w.iterate}.to change{society.production}.by(society.citizens.sum(:production))
  # end

