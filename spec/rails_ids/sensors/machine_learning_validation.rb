require 'rails_helper'

RSpec.describe RailsIds::Sensors::MachineLearningValidation do
  def init_examples
    MachineLearningExample.create(text: ' = \'\' OR 1=1;--', classifier: 0, status: 'active')
    MachineLearningExample.create(text: '<script>alert(\'Hi, my name is slim shady\')</script>', classifier: 0, status: 'active')
    MachineLearningExample.create(text: '&& cat /etc/shadow', classifier: 0, status: 'active')
    MachineLearningExample.create(text: '<!--#exec cmd="ls" -->', classifier: 0, status: 'active')
    MachineLearningExample.create(text: '<!--#exec cmd="cd /root/dir/">', classifier: 0, status: 'inactive')
    MachineLearningExample.create(text: 'Hi, my name is slim shady', classifier: 1, status: 'active')
    MachineLearningExample.create(text: 'The commands used to inject SSI vary according to the server operational system in use. The following commands represent the syntax that should be used to execute OS commands.', classifier: 1, status: 'active')
    MachineLearningExample.create(text: 'Blind SQL (Structured Query Language) injection is a type of SQL Injection attack that asks the database true or false questions and determines the answer based on the applications response. This attack is often used when the web application is configured to show generic error messages, but has not mitigated the code that is vulnerable to SQL injection.', classifier: 1, status: 'active')
    MachineLearningExample.create(text: 'The two hometown winners beamed throughout their victory speeches, but it was Mr. Trump who particularly seemed like a different candidate. As he spoke in the lobby of Trump Tower, there were no freewheeling presentations of steaks and bottled water, as in the past. There was no reference to “Lyin’ Ted” or “Crooked Hillary”; he called his opponent “Senator Cruz” instead, and made no mention of Mrs. Clinton. He also took no questions from the news media.', classifier: 1, status: 'active')
    MachineLearningExample.create(text: 'Trump and Clinton Win New York Easily', classifier: 1, status: 'inactive')
  end

  def import_examples
    require 'csv'
    CSV.foreach('example_import.csv') do |row|
      row = row.to_a
      MachineLearningExample.create!(classifier: row[0], text: row[1], status: 'active')
    end
  end

  it 'trains the machine learning algorithm' do
    init_examples
    RailsIds::Sensors::MachineLearningValidation.analyze_examples(MachineLearningExample.where(status: 'active'))
    expect(RailsIds::Event.all.count).to eq(0)

    request = ActionDispatch::Request.new(nil)
    RailsIds::Sensors::MachineLearningValidation.run(request, { text: 'This looks nice to me' }, nil, 'identifier')
    expect(RailsIds::Event.all.count).to eq(0)

    request = ActionDispatch::Request.new(nil)
    RailsIds::Sensors::MachineLearningValidation.run(request, { text: '<script>alert("oh oh, attack")' }, nil, 'identifier')
    expect(RailsIds::Event.all.count).to eq(1)
  end

  it 'classifies after training' do
    import_examples
    RailsIds::Sensors::MachineLearningValidation.analyze_examples(MachineLearningExample.where(status: 'active'))

    request = ActionDispatch::Request.new(nil)
    RailsIds::Sensors::MachineLearningValidation.run(request, { text: 'This looks nice to me' }, nil, 'identifier')
    expect(RailsIds::Event.all.count).to eq(0)

    request = ActionDispatch::Request.new(nil)
    RailsIds::Sensors::MachineLearningValidation.run(request, { text: '<script>alert("oh oh, attack")' }, nil, 'identifier')
    expect(RailsIds::Event.all.count).to eq(1)
  end
end
