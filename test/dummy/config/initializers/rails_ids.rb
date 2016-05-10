# Use this setup block to configure all options available in RailsIds.
# The generated configuration contains the default values
RailsIds.setup do |config|
  # If you use a model for your users, how is it called?
  # config.user_class = 'User'.freeze
  config.user_class = nil

  # How many events of type 'attack' can exist, before responding?
  # config.attack_events_threshold = 1

  # How many events of type 'suspicious' can exist, before responding?
  # config.suspicious_events_threshold = 3

  # How long will suspicious events will counted?
  # config.suspicious_timeout = 10.minutes

  # How many events of type 'unsuspicious' can exist, before responding?
  # config.unsuspicious_events_threshold = 10

  # How long will unsuspicious events will counted?
  # config.unsuspicious_timeout = 5.minutes

  # How to responde to attacks
  response_function = lambda do |user: nil, attack:|
    RailsIds::Responses::Debug.run(user: user, attack: attack)
    if user.present?
      RailsIds::Responses::LockUser.run(user: user)
      RailsIds::Responses::LogoutUser.run(user: user)
    else
      RailsIds::Responses::LockPage.run
    end
    attack
  end
end
