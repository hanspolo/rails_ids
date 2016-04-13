require 'spec_helper'
require 'rails_ids/sensors/blacklist_input_validation'

RSpec.describe RailsIds::Sensors::BlacklistInputValidation do
  it 'sql injection detected' do
    request = ActionDispatch::Request.new(nil)
    RailsIds::Sensors::BlacklistInputValidation.run(
      request, { clean: 'Hello World!' }, nil, 'identifier'
    )
    expect(Event.all.count).to eq(0)

    RailsIds::Sensors::BlacklistInputValidation.run(
      request, { suspicious: '\';--' }, nil, 'identifier'
    )
    expect(Event.all.count).to eq(1)
    expect(Event.where(weight: 'attack').count).to eq(0)

    RailsIds::Sensors::BlacklistInputValidation.run(
      request, { attack: 'foo\' OR 1!=2;--' }, nil, 'identifier'
    )
    expect(Event.where(weight: 'attack').count).to eq(1)
  end

  it 'xss detected' do
    request = ActionDispatch::Request.new(nil)

    RailsIds::Sensors::BlacklistInputValidation.run(
      request, { clean: 'Hello World!' }, nil, 'identifier'
    )
    expect(Event.all.count).to eq(0)

    RailsIds::Sensors::BlacklistInputValidation.run(
      request, { suspicious: 'Love < All > Live' }, nil, 'identifier'
    )
    expect(Event.all.count).to eq(1)
    expect(Event.where(weight: 'attack').count).to eq(0)

    RailsIds::Sensors::BlacklistInputValidation.run(
      request, { attack: '<script>alert(\'Attackable\')</script>' }, nil, 'identifier'
    )
    expect(Event.where(weight: 'attack').count).to eq(1)
  end

  it 'unprintable char detected' do
  end

  it 'file access detected' do
    request = ActionDispatch::Request.new(nil)

    RailsIds::Sensors::BlacklistInputValidation.run(
      request, { clean: 'Read more ...' }, nil, 'identifier'
    )
    expect(Event.all.count).to eq(0)

    RailsIds::Sensors::BlacklistInputValidation.run(
      request, { suspicious: '../private.log' }, nil, 'identifier'
    )
    expect(Event.all.count).to eq(1)
    expect(Event.where(weight: 'attack').count).to eq(0)
  end
end
