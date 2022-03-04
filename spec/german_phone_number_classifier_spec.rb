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
  end
end
