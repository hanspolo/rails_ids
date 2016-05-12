require 'rails_helper'

RSpec.describe RailsIds::Sensors::BlacklistInputValidation do
  it 'detects sql injection' do
    request = ActionDispatch::Request.new(nil)
    RailsIds::Sensors::BlacklistInputValidation.run(
      request, { clean: 'Hello World!' }, nil, 'identifier'
    )
    expect(RailsIds::Event.all.count).to eq(0)

    RailsIds::Sensors::BlacklistInputValidation.run(
      request, { suspicious: '\';--' }, nil, 'identifier'
    )
    expect(RailsIds::Event.all.count).to eq(1)
    expect(RailsIds::Event.where(weight: 'attack').count).to eq(0)

    RailsIds::Sensors::BlacklistInputValidation.run(
      request, { attack: 'foo\' OR 1!=2;--' }, nil, 'identifier'
    )
    expect(RailsIds::Event.where(weight: 'attack').count).to eq(1)
  end

  it 'detects xss' do
    request = ActionDispatch::Request.new(nil)

    RailsIds::Sensors::BlacklistInputValidation.run(
      request, { clean: 'Hello World!' }, nil, 'identifier'
    )
    expect(RailsIds::Event.all.count).to eq(0)

    RailsIds::Sensors::BlacklistInputValidation.run(
      request, { suspicious: 'Love < All > Live' }, nil, 'identifier'
    )
    expect(RailsIds::Event.all.count).to eq(1)
    expect(RailsIds::Event.where(weight: 'attack').count).to eq(0)

    RailsIds::Sensors::BlacklistInputValidation.run(
      request, { attack: '<script>alert(\'Attackable\')</script>' }, nil, 'identifier'
    )
    expect(RailsIds::Event.where(weight: 'attack').count).to eq(1)
  end

  it 'detects unprintable chars' do
  end

  it 'detects file access' do
    request = ActionDispatch::Request.new(nil)

    RailsIds::Sensors::BlacklistInputValidation.run(
      request, { clean: 'Read more ...' }, nil, 'identifier'
    )
    expect(RailsIds::Event.all.count).to eq(0)

    RailsIds::Sensors::BlacklistInputValidation.run(
      request, { suspicious: '../private.log' }, nil, 'identifier'
    )
    expect(RailsIds::Event.all.count).to eq(1)
    expect(RailsIds::Event.where(weight: 'attack').count).to eq(0)
  end
end
