# frozen_string_literal: true

require 'phony'
require 'german_phone_number_classifier/version'

# module providing classifier method for phone numbers
# as specified by the Bundesnetzagentur
# https://www.bundesnetzagentur.de/DE/Sachgebiete/Telekommunikation/Unternehmen_Institutionen/Nummerierung/start.html
module GermanPhoneNumberClassifier
  class Error < StandardError; end

  def self.classify(phone_number)
    raise ArgumentError, 'nil phone number' unless phone_number

    scanned = phone_number.scan(/(\+|\d)/).join

    return classify_international(scanned) if scanned.start_with?('+')
    return classify_national(scanned) if scanned.start_with?('0', '1')

    :no_phone_number
  rescue ArgumentError
    :no_phone_number
  end

  def self.classify_international(international_phone_number)
    cc, *national_blocks = Phony.split(
      Phony.normalize(international_phone_number)
    )

    return :non_german_phone_number unless cc == '49'
    return :no_phone_number if national_blocks.join.length.zero?

    classify_national_blocks(prepend_zero(national_blocks))
  end

  def self.classify_national(national_phone_number)
    :authoritative
  end

  def self.prepend_zero(national_blocks)
    national_blocks.dup.prepend('0').join
  end

  private_class_method :prepend_zero, :classify_national,
                       :classify_international
end
