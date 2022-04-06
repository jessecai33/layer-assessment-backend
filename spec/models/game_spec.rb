require 'rails_helper'

RSpec.describe Game, type: :model do
  let!(:game1) { create(:game, name: 'The Legend of Zelda: Breath of the Wild') }
  let!(:game2) { create(:game, name: 'Super Mario Odyssey') }
  let!(:game3) { create(:game, name: 'Super Mario Sunshine') }

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:gid) }
    it { should validate_uniqueness_of(:gid) }
  end

  describe "functions" do
    describe "search" do
      it 'should return 0 result when searching for `pokemon`' do
        expect(Game.search('pokemon').length).to eq(0)
      end

      it 'should return 1 result when searching for `zelda`' do
        expect(Game.search('zelda').length).to eq(1)
      end

      it 'should return 2 results when searching for `mario`' do
        expect(Game.search('mario').length).to eq(2)
      end
    end
  end
end
