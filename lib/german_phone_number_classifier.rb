# frozen_string_literal: true

require 'phony'
require 'german_phone_number_classifier/version'

# module providing classifier method for phone numbers
module GermanPhoneNumberClassifier
  class Error < StandardError; end

  def self.classify(phone_number)
    cc, *_national_parts = Phony.split(Phony.normalize(phone_number))

    return :non_german_phone_number unless cc == '49'
  rescue ArgumentError
    :no_phone_number
  end
end
