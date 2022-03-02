# frozen_string_literal: true

require 'german_phone_number_classifier/version'

module GermanPhoneNumberClassifier
  class Error < StandardError; end

  def self.classify(phone_number)
    :non_german
  end
end
