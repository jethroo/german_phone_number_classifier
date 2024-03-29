# frozen_string_literal: true

require 'phony'
require 'german_phone_number_classifier/version'
require 'german_phone_number_classifier/german_landline_prefixes'

# module providing classifier method for phone numbers
# as specified by the Bundesnetzagentur
# https://www.bundesnetzagentur.de/DE/Sachgebiete/Telekommunikation/Unternehmen_Institutionen/Nummerierung/start.html
module GermanPhoneNumberClassifier
  class Error < StandardError; end

  def self.classify(phone_number)
    raise ArgumentError, 'nil phone number' unless phone_number

    scanned = phone_number.scan(/(\+|\d)/).join

    return classify_international(scanned) if scanned.start_with?('+', '00')
    return classify_national(scanned) if scanned.start_with?('0', '1')

    :no_phone_number
  rescue ArgumentError
    :no_phone_number
  end

  def self.landline_location(phone_number)
    return unless classify(phone_number) == :landline

    scanned = phone_number.scan(/(\+|\d)/).join
    national_number = if scanned.start_with?('+', '00')
                        _cc, *national_blocks = Phony.split(
                          Phony.normalize(scanned)
                        )
                        prepend_zero(national_blocks)
                      else
                        scanned
                      end

    return unless national_number.length > 5

    (3..6).each do |n|
      hit = landline_lookup(national_number, n)
      return hit if hit
    end

    nil
  end

  # private class methods

  def self.classify_international(international_phone_number)
    cc, *national_blocks = Phony.split(
      Phony.normalize(international_phone_number)
    )

    return :non_german_phone_number unless cc == '49'
    return :no_phone_number if national_blocks.join.empty?

    classify_national(prepend_zero(national_blocks))
  end

  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/AbcSize, Metrics/PerceivedComplexity
  def self.classify_national(national_phone_number)
    return :authoritative if authoritive?(national_phone_number)
    return :provider_selection if national_phone_number.match(/^010\d+$/)
    return :high_connection if national_phone_number.match(/^0137\d+$/)
    return :service_hotline if national_phone_number.match(/^0180\d+$/)
    return :vpn if national_phone_number.match(/^018\d+$/)
    return :online_and_traffic if national_phone_number.match(/^019\d+$/)
    return :personal_number if national_phone_number.match(/^0700\d+$/)
    return :free_service_hotline if national_phone_number.match(/^0800\d+$/)
    return :dialer if national_phone_number.match(/^09009\d+$/)
    return :premium_service_hotline if national_phone_number.match(/^0900\d+$/)
    return :mobile if national_phone_number.match(/^015\d+$/)
    return :mobile if national_phone_number.match(/^016\d+$/)
    return :mobile if national_phone_number.match(/^017\d+$/)
    return :test_provider if national_phone_number.match(/^031(0|1)$/)
    return :landline if landline?(national_phone_number)

    :unknown_class
  end
  # rubocop:enable Metrics/CyclomaticComplexity, Metrics/AbcSize, Metrics/PerceivedComplexity

  def self.prepend_zero(national_blocks)
    national_blocks.dup.prepend('0').join
  end

  def self.authoritive?(national_phone_number)
    case national_phone_number
    when '110', '112', '115', /^116\d{3}$/, /^118\d{2}$/
      true
    else
      false
    end
  end

  def self.landline?(national_phone_number)
    return false unless national_phone_number.length > 5

    (3..6).each do |n|
      return true if landline_lookup(national_phone_number, n)
    end

    false
  end

  def self.landline_lookup(national_phone_number, length)
    GermanPhoneNumberClassifier::GERMAN_LANDLINE_PREFIXES[
      national_phone_number[0, length].to_i
    ]
  end

  private_class_method :prepend_zero, :classify_national, :landline_lookup,
                       :classify_international, :authoritive?, :landline?
end
