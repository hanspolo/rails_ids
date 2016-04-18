require 'rails_ids/sensors/sensor.rb'

module RailsIds
  module Sensors
    ##
    # A implementation of an input validation sensor based on machine learning algorithms.
    #
    class MachineLearningValidation < Sensor
      SENSOR = 'MachineLearningValidation'.freeze

      def self.run(request, params, user = nil, identifier = nil)
        results = MachineLearningResult.where(a: 1)
        svm = Hml::Method::SVM.new(b: 0, w: results.map(&:w))
        suspicious = false

        params.flatten.each do |param|
          tokens  = Hml::FeatureExtraction::BagOfWords.tokenize(params[])
          feature = Hml::FeatureExtraction::BagOfWords.vectorize(tokens, words_vector)
          suspicious ||= (svm.classify(feature) == 1)
        end

        if suspicious
          event_detected(type: , weight: 'suspicious'.freeze,
                         log: "",
                         sensor: SENSOR, request: request, params: params,
                         user: user, identifier: identifier)
       end

       def self.words_vector
         MachineLearningToken.all.map(&:token)
       end
      end
    end
  end
end
