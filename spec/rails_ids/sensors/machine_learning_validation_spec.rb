require 'rails_helper'

RSpec.describe RailsIds::Sensors::MachineLearningValidation do
  def import_examples
    require 'csv'
    CSV.foreach('example_import.csv') do |row|
      row = row.to_a
      RailsIds::MachineLearningExample.create!(classifier: row[0], text: row[1], status: 'active')
    end
  end

  it 'classifies after training with the imported examples' do
    import_examples
    RailsIds::Sensors::MachineLearningValidation.analyze_examples(RailsIds::MachineLearningExample.where(status: 'active'))

    request = ActionDispatch::Request.new(nil)
    RailsIds::Sensors::MachineLearningValidation.run(request, { text: 'This looks nice to me' }, nil, 'identifier')
    expect(RailsIds::Event.all.count).to eq(0)

    request = ActionDispatch::Request.new(nil)
    RailsIds::Sensors::MachineLearningValidation.run(request, { text: '<script>alert("oh oh, attack")' }, nil, 'identifier')
    expect(RailsIds::Event.all.count).to eq(1)
  end
end
