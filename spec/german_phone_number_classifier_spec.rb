# frozen_string_literal: true

RSpec.describe GermanPhoneNumberClassifier do
  it 'has a version number' do
    expect(GermanPhoneNumberClassifier::VERSION).not_to be nil
  end

  describe '.classify' do
    # example number are fictitius as for use in press and movies
    # https://en.wikipedia.org/wiki/Fictitious_telephone_number

    context 'when a non german international number is provided' do
      ['+33 1 99 1234', '0061 491 570 006', '+46 31-3900600'].each do |number|
        it "classifies #{number} as non german" do
          expect(GermanPhoneNumberClassifier.classify(number))
            .to eq(:non_german_phone_number)
        end
      end
    end

    context 'when no or invalid phone number is provided' do
      [nil, 'invalid number', '+49invalid number', '456789'].each do |number|
        it "classifies #{number} as no phone number" do
          expect(GermanPhoneNumberClassifier.classify(number))
            .to eq(:no_phone_number)
        end
      end
    end

    context 'when an authority number is provided' do
      # 116xyz or 118xy are social or informative numbers and are grouped under
      # authoritative for now as simplification
      %w[110 112 115 116123 11833].each do |number|
        it "classifies #{number} as authoritative" do
          expect(GermanPhoneNumberClassifier.classify(number))
            .to eq(:authoritative)
        end
      end
    end

    context 'when provider selection number is provided' do
      %w[01012 +491012 01088 00491088].each do |number|
        it "classifies #{number} as provider selection" do
          expect(GermanPhoneNumberClassifier.classify(number))
            .to eq(:provider_selection)
        end
      end
    end

    context 'when number is reserved for high connection count' do
      %w[004913712345 +4913712345 013755656].each do |number|
        it "classifies #{number} as high connectivity number" do
          expect(GermanPhoneNumberClassifier.classify(number))
            .to eq(:high_connection)
        end
      end
    end

    context 'when number is a service hotline' do
      %w[+49180666666 0180666666 0049180666666].each do |number|
        it "classifies #{number} as service hotline" do
          expect(GermanPhoneNumberClassifier.classify(number))
            .to eq(:service_hotline)
        end
      end
    end

    context 'when number is reserved for VPN' do
      %w[+49181123112 0189666666 0049186789].each do |number|
        it "classifies #{number} as vpn number" do
          expect(GermanPhoneNumberClassifier.classify(number))
            .to eq(:vpn)
        end
      end
    end

    context 'when number is reserved for online and traffic services' do
      %w[+491921232 01986115 00491982].each do |number|
        it "classifies #{number} as online and traffic number" do
          expect(GermanPhoneNumberClassifier.classify(number))
            .to eq(:online_and_traffic)
        end
      end
    end

    context 'when number is a personal registered phone number' do
      %w[+497001234 07001234 00497001234].each do |number|
        it "classifies #{number} as personal_number" do
          expect(GermanPhoneNumberClassifier.classify(number))
            .to eq(:personal_number)
        end
      end
    end

    context 'when number a free service phone number' do
      %w[+498001234 08001234 00498001234].each do |number|
        it "classifies #{number} as free service number" do
          expect(GermanPhoneNumberClassifier.classify(number))
            .to eq(:free_service_hotline)
        end
      end
    end

    context 'when number is a premium service phone number' do
      %w[+499001234 09001234 00499001234].each do |number|
        it "classifies #{number} as premium service number" do
          expect(GermanPhoneNumberClassifier.classify(number))
            .to eq(:premium_service_hotline)
        end
      end
    end

    context 'when number is a dialer phone number' do
      %w[+4990091234 090091234 004990091234].each do |number|
        it "classifies #{number} as dialer number" do
          expect(GermanPhoneNumberClassifier.classify(number))
            .to eq(:dialer)
        end
      end
    end

    context 'when number is a mobile phone number' do
      %w[+491501234 01501234 00491501234
         +491601234 01601234 00491601234
         +491701234 01701234 00491701234].each do |number|
        it "classifies #{number} as mobile number" do
          expect(GermanPhoneNumberClassifier.classify(number))
            .to eq(:mobile)
        end
      end
    end

    context 'when number is a test provider number' do
      %w[+49310 0310 0049310 +49311 0311 0049311].each do |number|
        it "classifies #{number} as test provider number" do
          expect(GermanPhoneNumberClassifier.classify(number))
            .to eq(:test_provider)
        end
      end
    end

    context 'when number is a known landline number' do
      %w[+4930120849110 030120849110 004930120849110
         +4922164308010 022164308010 004922164308010
         +4933274883333 033274883333 004933274883333].each do |number|
        it "classifies #{number} as landline number" do
          expect(GermanPhoneNumberClassifier.classify(number))
            .to eq(:landline)
        end
      end
    end

    context 'when number is unknown' do
      %w[+499999934 09999934 00499999934].each do |number|
        it "classifies #{number} as unknown" do
          expect(GermanPhoneNumberClassifier.classify(number))
            .to eq(:unknown_class)
        end
      end
    end
    # TODO: 032 https://www.bundesnetzagentur.de/DE/Fachthemen/Telekommunikation/Nummerierung/032/032_node.html
  end

  describe '.landline_location' do
    context 'when number is a known landline number' do
      %w[+4930120849110 030120849110 004930120849110].each do |number|
        it "classifies #{number} as landline number in Berlin" do
          expect(GermanPhoneNumberClassifier.landline_location(number))
            .to eq('Berlin')
        end
      end

      %w[+4922164308010 022164308010 004922164308010].each do |number|
        it "classifies #{number} as landline number in Köln" do
          expect(GermanPhoneNumberClassifier.landline_location(number))
            .to eq('Köln')
        end
      end

      %w[+4933274883333 033274883333 004933274883333].each do |number|
        it "classifies #{number} as landline number in Werder Havel" do
          expect(GermanPhoneNumberClassifier.landline_location(number))
            .to eq('Werder Havel')
        end
      end
    end
  end
end
