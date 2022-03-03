# frozen_string_literal: true

require 'phony'
require 'german_phone_number_classifier/version'

# module providing classifier method for phone numbers
# as specified by the Bundesnetzagentur
# https://www.bundesnetzagentur.de/DE/Sachgebiete/Telekommunikation/Unternehmen_Institutionen/Nummerierung/start.html
module GermanPhoneNumberClassifier
  class Error < StandardError; end

  def self.classify(phone_number)
    cc, *national_blocks = Phony.split(Phony.normalize(phone_number))

    return :non_german_phone_number unless cc == '49'

    classify_national_blocks(prepend_zero(national_blocks))
  rescue ArgumentError
    :no_phone_number
  end

  def self.classify_national_blocks(national_phone_number)
    p national_phone_number
  end

  def self.prepend_zero(national_blocks)
    national_blocks.dup.prepend('0').join
  end

  private_class_method :prepend_zero, :classify_national_blocks
end
