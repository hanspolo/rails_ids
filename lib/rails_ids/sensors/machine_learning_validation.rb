require 'rails_ids/sensors/sensor.rb'

module RailsIds
  module Sensors
    ##
    # A implementation of an input validation sensor based on machine learning algorithms.
    #
    class MachineLearningValidation < Sensor
      SENSOR = 'MachineLearningValidation'.freeze
      TYPE = 'AUTOMATICALLY_RECOGNIZED'.freeze

      def self.run(request, params, user = nil, identifier = nil)
        svm = Hml::Method::SVM.new(b: 0, w: MachineLearningResult.where(a: 1).map(&:w))
        suspicious = params.flatten.any? { |param| suspicious?(svm, param) }

        if suspicious
          event_detected(type: TYPE, weight: 'suspicious'.freeze,
                         log: '',
                         sensor: SENSOR, request: request, params: params,
                         user: user, identifier: identifier)
        end
      end

      def self.suspicious?(svm, str)
        tokens  = Hml::FeatureExtraction::BagOfWords.tokenize(str)
        feature = Hml::FeatureExtraction::BagOfWords.vectorize(tokens, words_vector)
        svm.classify(feature) == 1
      end

      def self.words_vector
        MachineLearningToken.active.map(&:token)
      end
    end
  end
end
