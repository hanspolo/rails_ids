require 'rails_ids/sensors/sensor.rb'

require 'hml/dataset'
require 'hml/feature_extraction/bag_of_words'
require 'hml/method/svm'

module RailsIds
  module Sensors
    ##
    # A implementation of an input validation sensor based on machine learning algorithms.
    #
    class MachineLearningValidation < Sensor
      SENSOR = 'MachineLearningValidation'.freeze
      TYPE = 'AUTOMATICALLY_RECOGNIZED'.freeze

      ##
      #
      #
      def self.run(request, params, user = nil, identifier = nil)
        results =  MachineLearningResult.where(a: 1)
        svm = Hml::Method::SVM.new(a: Hmath::Vector.from_array(results.map(&:a)), b: 0, w: Hmath::Vector.from_array(results.map(&:w)))
        suspicious = params.flatten.any? { |param| suspicious?(svm, param) if param.is_a? String }

        if suspicious
          event_detected(type: TYPE, weight: 'suspicious'.freeze,
                         log: '',
                         sensor: SENSOR, request: request, params: params,
                         user: user, identifier: identifier)
        end
      end

      ##
      #
      #
      def self.suspicious?(svm, str)
        tokens  = Hml::FeatureExtraction::BagOfWords.tokenize(str)
        feature = Hml::FeatureExtraction::BagOfWords.vectorize(tokens, words_vector)
        svm.classify(feature) == 1
      end

      ##
      #
      #
      def self.words_vector
        MachineLearningToken.all.map(&:token)
      end

      ##
      #
      #
      #
      #
      def self.analyze_examples(examples)
        dataset = Hml::DataSet.new
        tokens_list = []
        MachineLearningResult.where(status: 'active').each { |r| r.update(status: 'old') }
        examples.each do |ex|
          tokens_list << Hml::FeatureExtraction::BagOfWords.tokenize(ex.text, [])
        end
        tokens_list.flatten.each { |token| MachineLearningToken.find_or_create_by(token: token) }
        examples.each do |ex|
          tokens = tokens_list.shift
          values = Hml::FeatureExtraction::BagOfWords.vectorize(tokens, words_vector)
          dataset << Hml::DataPoint.new(values, ex.classifier)
        end
        svm = Hml::Method::SVM.new
        svm.train(dataset)
        (0...svm.w.size).each do |i|
          MachineLearningResult.create(status: 'new', a: svm.a[i], w: svm.w[i])
        end
        MachineLearningResult.where(status: 'new').each { |r| r.update(status: 'active') }
      end
    end
  end
end
