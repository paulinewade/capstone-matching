require 'rails_helper'

RSpec.describe Ethnicity, type: :model do
    subject {
      described_class.new(ethnicity_name: "SomeEthnicity")
    }
  
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end
  
    describe 'associations' do
      it "has many ethnicity_values" do
        association = described_class.reflect_on_association(:ethnicity_values)
        expect(association.macro).to eq(:has_many)
        expect(association.options[:foreign_key]).to eq('ethnicity_name')
        expect(association.options[:primary_key]).to eq('ethnicity_name')
      end
    end
  end
