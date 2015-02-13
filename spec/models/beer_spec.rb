require 'rails_helper'

describe Beer do
  it "is saved if it has a name and style set" do
    s = Style.create name: "style", description: "descr"
    b = Beer.create name:"beer", style_id: s.id

    expect(b).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "is not saved without a name" do
    s = Style.create name: "style", description: "descr"
    b = Beer.create style_id: s.id

    expect(b).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "is not saved without style set" do
    b = Beer.create name:"beer"

    expect(b).not_to be_valid
    expect(Beer.count).to eq(0)
  end
end
