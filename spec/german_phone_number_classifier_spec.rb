# frozen_string_literal: true

RSpec.describe GermanPhoneNumberClassifier do
  it 'has a version number' do
    expect(GermanPhoneNumberClassifier::VERSION).not_to be nil
  end

  describe '.classify' do
    # example number are fictitius as for use in press and movies
    # https://en.wikipedia.org/wiki/Fictitious_telephone_number

    context 'when a non german international number is provided' do
      ['+33 1 99 1234', '+61 491 570 006', '+46 31-3900600'].each do |number|
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
  end
end
