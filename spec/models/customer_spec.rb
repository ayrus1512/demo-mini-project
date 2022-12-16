require 'rails_helper'

RSpec.describe Customer, type: :model do
  subject { Customer.new(email: "", created_at: DateTime.now(), updated_at: DateTime.now)}

  before { subject.save }

  it 'email should be present' do
    subject.email = nil
    expect(subject).not_to be_valid
  end
end
