require 'rails_helper'

RSpec.describe Game, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:gid) }
    it { should validate_uniqueness_of(:gid) }
  end
end
