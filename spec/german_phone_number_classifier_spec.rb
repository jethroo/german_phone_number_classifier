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
        it "classifies #{number} as free service number" do
          expect(GermanPhoneNumberClassifier.classify(number))
            .to eq(:premium_service_hotline)
        end
      end
    end

    # TODO: 0900 https://www.bundesnetzagentur.de/DE/Fachthemen/Telekommunikation/Nummerierung/0900/0900_node.html
    # TODO: 09009 https://www.bundesnetzagentur.de/DE/Fachthemen/Telekommunikation/Nummerierung/09009/9009_node.html

    # TODO: 0150 https://www.bundesnetzagentur.de/DE/Fachthemen/Telekommunikation/Nummerierung/MobileDienste/mobiledienste_node.html
    # TODO: 0160 https://www.bundesnetzagentur.de/DE/Fachthemen/Telekommunikation/Nummerierung/MobileDienste/mobiledienste_node.html
    # TODO: 0170 # 0150 https://www.bundesnetzagentur.de/DE/Fachthemen/Telekommunikation/Nummerierung/MobileDienste/mobiledienste_node.html

    # TODO: 031x https://www.bundesnetzagentur.de/DE/Fachthemen/Telekommunikation/Nummerierung/031/031_node.html

    # TODO: 032 https://www.bundesnetzagentur.de/DE/Fachthemen/Telekommunikation/Nummerierung/032/032_node.html
  end
end
