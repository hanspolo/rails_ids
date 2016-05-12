require 'rails_helper'

RSpec.describe RailsIds::Responses::LockPage do
  it 'locks page' do
    expect { RailsIds::Responses::LockPage.run }.to raise_exception('You are locked out')
  end
end
