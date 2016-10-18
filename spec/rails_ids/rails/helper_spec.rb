require 'rails_helper'

RSpec.describe RailsIds::User do
  ############
  # ids_user #
  ############
  it 'returns nil if no current user is found' do
    user = ActionController::Base.new.ids_user

    expect(user).to be(nil)
  end

  #######################
  # ids_user_identifier #
  #######################
end

RSpec.describe RailsIds::Analyzer do
  ###############
  # ids_analyze #
  ###############

  ###############
  # ids_respond #
  ###############
  it 'calls the global response_function' do
    RailsIds.response_function = lambda do |user: nil, attack:|
      'response'
    end

    response = ActionController::Base.new.ids_respond(attack: nil)

    expect(response).to eql('response')
  end

  ###################
  # ids_find_attack #
  ###################
  it 'finds an attack that can be matched to an given identifier' do
    identifier = 'test-1.0'
    RailsIds::Event.create!(identifier: identifier, event_type: 'AUTOMATICALLY_RECOGNIZED',
                            weight: 'attack', attack: RailsIds::Attack.create!)

    attack = ActionController::Base.new.ids_find_attack(identifier: identifier)

    expect(attack).to_not be(nil)
  end

  it 'can\'t find an attack if non is matching an given identifier' do
    RailsIds::Event.create!(identifier: 'test-1.0', event_type: 'AUTOMATICALLY_RECOGNIZED',
                            weight: 'attack', attack: RailsIds::Attack.create!)

    attack = ActionController::Base.new.ids_find_attack(identifier: 'test-1.1')

    expect(attack).to be(nil)
  end

  it 'can\'t find an attack if no identifier or user is given' do
    RailsIds::Event.create!(identifier: 'test-1.0', event_type: 'AUTOMATICALLY_RECOGNIZED',
                            weight: 'attack', attack: RailsIds::Attack.create!)

    expect{ ActionController::Base.new.ids_find_attack }.to raise_error('User or identifier required')
  end

  ###################
  # ids_find_events #
  ###################
  it 'finds events that can be matched to an given identifier' do
    identifier = 'test-1.0'
    other_identifier = 'test-1.1'
    e1 = RailsIds::Event.create!(identifier: identifier, event_type: 'AUTOMATICALLY_RECOGNIZED',
                                 weight: 'unsuspicious')
    e2 = RailsIds::Event.create!(identifier: identifier, event_type: 'CSRF_TOKEN',
                                 weight: 'suspicious')
    e3 = RailsIds::Event.create!(identifier: other_identifier, event_type: 'FILE_ACCESS',
                                 weight: 'suspicious')

    events = ActionController::Base.new.ids_find_events(identifier: identifier)

    expect(events.flatten.uniq).to contain_exactly(e1, e2)
  end

  #########################
  # ids_events_dangerous? #
  #########################
  it 'returns true if dangerous events in form of an attack is found' do
    attacks = [RailsIds::Event.create!(event_type: 'AUTOMATICALLY_RECOGNIZED', weight: 'attack')]
    suspicious_events = []
    unsuspicious_events = []

    dangerous = ActionController::Base.new.ids_events_dangerous?(attacks, suspicious_events, unsuspicious_events)

    expect(dangerous).to be(true)
  end

  it 'returns true if dangerous events in form of 3 suspicious events are found' do
    attacks = []
    suspicious_events = []
    3.times { suspicious_events << RailsIds::Event.create!(event_type: 'AUTOMATICALLY_RECOGNIZED', weight: 'suspicious') }
    unsuspicious_events = []

    dangerous = ActionController::Base.new.ids_events_dangerous?(attacks, suspicious_events, unsuspicious_events)

    expect(dangerous).to be(true)
  end

  it 'returns true if dangerous events in form of 10 unsuspicious events are found' do
    attacks = []
    suspicious_events = []
    unsuspicious_events = []
    10.times { unsuspicious_events << RailsIds::Event.create!(event_type: 'AUTOMATICALLY_RECOGNIZED', weight: 'unsuspicious') }

    dangerous = ActionController::Base.new.ids_events_dangerous?(attacks, suspicious_events, unsuspicious_events)

    expect(dangerous).to be(true)
  end

  it 'returns false if no events are found' do
    attacks = []
    suspicious_events = []
    unsuspicious_events = []

    dangerous = ActionController::Base.new.ids_events_dangerous?(attacks, suspicious_events, unsuspicious_events)

    expect(dangerous).to be(false)
  end

  it 'returns false if not enough events are found' do
    attacks = []
    suspicious_events = []
    2.times { suspicious_events << RailsIds::Event.create!(event_type: 'AUTOMATICALLY_RECOGNIZED', weight: 'suspicious') }
    unsuspicious_events = []
    9.times { unsuspicious_events << RailsIds::Event.create!(event_type: 'AUTOMATICALLY_RECOGNIZED', weight: 'unsuspicious') }

    dangerous = ActionController::Base.new.ids_events_dangerous?(attacks, suspicious_events, unsuspicious_events)

    expect(dangerous).to be(false)
  end
end
