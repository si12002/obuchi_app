require 'spec_helper'

describe Document do
	let(:user) { FactoryGirl.create(:user) }
	before { @document = user.documents.build(content: "Lorem ipsum", lat: 10.0, lng: 10.0, date: "2020/5/16", weather: "はれ") }

  subject { @document }

  it { should respond_to(:user_id) }
  it { should respond_to(:content) }
  it { should respond_to(:lat) }
  it { should respond_to(:lng) }
  it { should respond_to(:date) }
  it { should respond_to(:weather) }

  it { should respond_to(:user) }
  its(:user) { should eq user }

  it { should be_valid }

  describe "when user_id is not present" do
  # ユーザーIDが存在しないとき
  	before { @document.user_id = nil }
  	it { should_not be_valid }
  end

  describe "with blank content" do
  # 本文が空だったら
    before { @document.content = " " }
    it { should_not be_valid }
  end

  describe "with content that is too long" do
  # 本文の長さが長過ぎたら
    before { @document.content = "a" * 10001 }
    it { should_not be_valid }
  end

end
