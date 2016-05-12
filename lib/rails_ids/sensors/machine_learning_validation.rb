require 'rails_ids/sensors/sensor.rb'
require 'libsvm'

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

        problem = Libsvm::Problem.new
        parameter = Libsvm::SvmParameter.new

        parameter.cache_size = 1 # in megabytes
        parameter.eps = 0.001
        parameter.c = 10

        problem.set_examples(labels, examples)
        svm = Libsvm::Model.train(problem, parameter)

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
        tokens = BagOfWords.tokenize(str)
        vector = BagOfWords.vectorize(tokens, words_vector)
        svm.predict(Libsvm::Node.features(vector)) == 0
      end

      ##
      #
      #
      def self.examples
          @examples_cache ||= MachineLearningExample.where(status: 'active').map do |ex|
            tokens = BagOfWords.tokenize(ex.text)
            vector = BagOfWords.vectorize(tokens, words_vector)
            Libsvm::Node.features(vector)
          end
      end

      def self.labels
        @labels_cache ||= MachineLearningExample.where(status: 'active').map(&:classifier)
      end

      ##
      #
      #
      def self.words_vector
        @words_vector_cache ||= MachineLearningToken.all.map(&:token)
      end

      ##
      #
      #
      #
      #
      def self.analyze_examples(examples)
        # dataset = Hml::DataSet.new
        tokens_list = []
        MachineLearningResult.where(status: 'active').each { |r| r.update(status: 'old') }
        examples.each do |ex|
          tokens_list << BagOfWords.tokenize(ex.text)
        end
        tokens_list.flatten.each { |token| MachineLearningToken.find_or_create_by(token: token) }
        # examples.each do |ex|
        #   tokens = tokens_list.shift
        #   values = BagOfWords.vectorize(tokens, words_vector)
        #   # dataset << Hml::DataPoint.new(values, ex.classifier)
        # end
        # svm = Hml::Method::SVM.new
        # svm.train(dataset)
        # (0...svm.w.size).each do |i|
        #   MachineLearningResult.create(status: 'new', a: svm.a[i], w: svm.w[i])
        # end
        # MachineLearningResult.where(status: 'new').each { |r| r.update(status: 'active') }
      end
    end # class MachineLearningValidation

    class BagOfWords
      ##
      #
      #
      # @param text
      # @return Array
      #
      def self.tokenize(text)
        raise '' unless text.is_a? String
        text.gsub!(/([^\w\s])/, ' \1 ')
        text.strip!
        text.downcase!
        text.split(' ')
      end

      ##
      #
      #
      # @param tokens
      # @param words
      # @return Array
      #
      def self.vectorize(tokens, words)
        raise '' unless tokens.is_a? Array
        raise '' unless words.is_a? Array
        v = {}
        words.each do |w|
          v[w] = 0
        end
        tokens.each do |t|
          v[t] += 1 if v.include?(t)
        end
        v.values
      end
    end
  end # module Sensors
end # module RailsIds
