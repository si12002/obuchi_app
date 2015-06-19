require 'spec_helper'

describe "StaticPages" do

  subject { page }

  describe "Home page" do
  # ホーム
    before { visit root_path }

    it { should have_content('尾駁小学校のアプリ') }
    it { should have_title(full_title('')) }
    it { should_not have_title('| Home') }

    describe "for signed-in users" do
    # サインインしたユーザー
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:document, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:document, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
      # ユーザーのフィードを表示する
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end
    end
  end




  describe "About page" do
  # アプリについてのページ
    before { visit about_path }

    it { should have_content('このアプリについて') }
    it { should have_title(full_title('About Us')) }
  end

end
