# frozen_string_literal: true

RSpec.describe GermanPhoneNumberClassifier do
  it 'has a version number' do
    expect(GermanPhoneNumberClassifier::VERSION).not_to be nil
  end

  describe '.classify' do
    # example number are fictitius as for use in press and movies
    # https://en.wikipedia.org/wiki/Fictitious_telephone_number

    context 'when a non german number is provided' do
      it 'should classify as non german' do
        ['+33 1 99 1234', '+61 491 570 006', '+46 31-3900600'].each do |number|
          expect(GermanPhoneNumberClassifier.classify(number))
            .to eq(:non_german)
        end
      end
    end
  end
end
