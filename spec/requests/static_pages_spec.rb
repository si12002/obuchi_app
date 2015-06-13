require 'spec_helper'

describe "StaticPages" do

  subject { page }

  describe "Home page" do
  # ホーム
    before { visit root_path }

    it { should have_content('尾駁小学校のアプリ') }
    it { should have_title(full_title('')) }
    it { should_not have_title('| Home') }
  end




  describe "About page" do
  # アプリについてのページ
    before { visit about_path }

    it { should have_content('このアプリについて') }
    it { should have_title(full_title('About Us')) }
  end

end
