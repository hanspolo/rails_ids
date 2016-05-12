require 'libsvm'

module RailsIds
  module Sensors
    ##
    # A implementation of an input validation sensor based on machine learning algorithms.
    # Using rb-libsvm to classify the data.
    #
    class MachineLearningValidation < Sensor
      TYPE = 'AUTOMATICALLY_RECOGNIZED'.freeze
      FILE = File.expand_path(File.join('tmp', 'rails_ids_svm'), Rails.env.test? ? '/' : Rails.root)

      ##
      # Executes the classification on all parameters and
      # create event if any is suspicious
      #
      # @param request The Rails request object
      # @param params The params from the controller
      # @param user An optional user object
      # @param identifier An optional identifier to recognize users without an id
      #
      def self.run(request, params, user, identifier)
        @svm ||= Libsvm::Model.load(FILE)
        suspicious = params.flatten.any? { |param| suspicious?(@svm, param) if param.is_a? String }

        if suspicious
          event_detected(type: TYPE, weight: 'suspicious'.freeze,
                         log: '', request: request, params: params,
                         user: user, identifier: identifier)
        end
      end

      ##
      # Check if the text looks suspicious.
      # Uses the svm classifier to decide it.
      #
      # @param svm Libsvm::Model object, that is already trained
      # @param str A string containing the text, that will be classified
      # @return Boolean that returns true, if the text is classified as suspicious
      #
      def self.suspicious?(svm, str)
        tokens = BagOfWords.tokenize(str)
        vector = BagOfWords.vectorize(tokens, words_vector)
        svm.predict(Libsvm::Node.features(vector)) == 0
      end

      ##
      # Load all examples from the database and store the vectorized text in Libsvm::Nodes.
      #
      # @return Array<Libsvm::Node>
      #
      def self.features
          @examples_cache ||= MachineLearningExample.where(status: 'active').map do |ex|
            tokens = BagOfWords.tokenize(ex.text)
            vector = BagOfWords.vectorize(tokens, words_vector)
            Libsvm::Node.features(vector)
          end
      end

      ##
      # Load all examples from the database and return an array of classifiers.
      #
      # @return Array<Object>
      #
      def self.labels
        @labels_cache ||= MachineLearningExample.where(status: 'active').map(&:classifier)
      end

      ##
      # Load all tokens from the database and return them as array.
      #
      # @return Array<String>
      #
      def self.words_vector
        @words_vector_cache ||= MachineLearningToken.all.map(&:token)
      end

      ##
      # Trains the svm classifier.
      # Tokenizes and vectorizes all examples, stores new tokens in the database
      # and uses them to learn.
      #
      # @param examples List of MachineLearningExamples
      #
      def self.analyze_examples(examples)
        manage_tokens(examples)

        problem = Libsvm::Problem.new
        parameter = Libsvm::SvmParameter.new

        parameter.cache_size = 1 # in megabytes
        parameter.eps = 0.001
        parameter.c = 10

        problem.set_examples(labels, features)
        svm = Libsvm::Model.train(problem, parameter)
        svm.save(FILE)
      end

      def self.manage_tokens(examples)
        tokens_list = []
        MachineLearningResult.where(status: 'active').each { |r| r.update(status: 'old') }
        examples.each { |d| tokens_list << BagOfWords.tokenize(d.text) }
        tokens_list.flatten.each { |token| MachineLearningToken.find_or_create_by(token: token) }
      end
      private_class_method :manage_tokens
    end # class MachineLearningValidation

    ##
    # Bag of Words is a way to get a text into a vector.
    #
    class BagOfWords
      ##
      #
      #
      # @param text
      # @return Array
      #
      def self.tokenize(text)
        raise '' unless text.is_a? String
        text.gsub!(%r(([^\w\s])), ' \1 ')
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
    end # class BagOfWords
  end # module Sensors
end # module RailsIds
