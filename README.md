**We assume no responsibility	for security flaws in your application!**

**rails_ids is not stable yet!**

# Table of Contents
* [Description](#description)
* [Installation](#installation)
* [Required work](#required-work)
  * [Design](#design)
  * [Implementation](#implementation)
  * [Verification](#verification)
  * [Deployment](#deployment)
* [Confiugration](#configuration)
* [Additional](#additional)
  * [Contribute](#contribute)
  * [License](#license)

# Description
[OWASP AppSensor](https://www.owasp.org/index.php/AppSensor) is a documentation to implement intrusion detection and automated response into applications.
rails_ids is a template to implement your own rules and comes with some generic ones.

rails_ids and OWASP AppSensor are no firewalls, antivirus or security scanner.
It does not make your application secure against attacks.
It just helps to detect attacks to your site and respond to and monitor them.
You should secure your application as good as possible and use rails_ids or OWASP AppSensor as addition.

To understand how to use IDS or AppSensor correctly and get a correct image of what it is, please read the [OWASP AppSensor Guide](https://www.owasp.org/index.php/File:Owasp-appsensor-guide-v2.pdf).

# Installation
Add the next line to your Gemfile:
`gem 'rails_ids', github: 'hanspolo/rails_ids'`

Afterwards run `rails g rails_ids:install` and `rails g rails_ids:initialize rails_ids` to initialize the application and the database.

# Required work
## Design
* Strategic requirements
* Detection point selection
  Mark the routes in you application, that need a verification. See [how to set detection points](#how-to-set-detection-points)
* Response action selection
  How do you wan't to respond to attackers? See [available responses](#available-responses).
* Treshold definition
  How critical is you application?

## Implementation


## Verification
Verify that your application still works normal for users, that don't use the application in a malicious way.

## Deployment
Deploy your application.

## Operation
Check logs, the dashboard etc. to make sure, that the application works as you want it, and use the knowledge, you win through this logs, to make your sensors and responses better.

# Configuration
## Initialize rails_ids
Call `rails g rails_ids:initialize rails_ids` to copy the default initializer.

## How to set detection points
To set a detection point, you call the method `ids_detect` inside your action or set it in class scope.
In class scope you can call it like `before_action` and give it an argument `only: [...]` or `except: [...]`.
In both cases you should add an argument `sensors: [...]`, so it can detect events.

```ruby
class MyController < ApplicationController
  ids_detect only: [:show, :new], sensors: [RailsIds::Sensors::BlacklistInputValidation, MySensor]
  ids_detect except: [:index], sensors: [OhMySensor]
  before_action :load_stuff, only: [:show]

  def index
    ids_detect sensors: [MyOtherSensor]
    ...
  end

  def show
    ...
  end

  def new
    ...
  end

  def create
    ...
  end
end
```

To get an overview what sensors are available, have a look on [available sensors](#available-sensors) and [write-your-own-sensors](#write-your-own-sensors).

When an event is detected, it analyzes it and if an attack is detected, it responds to it.
See [available responses](#available-responses) and [write your own responses](#write-your-own-responses) to learn more about responses.

## Available sensors

## Write your own sensors
More theory about responses in the [wiki](/wiki/Sensors)

## Available responses

## Write your own responses
More theory about responses in the [wiki](/wiki/Responses)

# Additional
## Contribution

## License
This project rocks and uses MIT-LICENSE.
