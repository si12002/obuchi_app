require 'spec_helper'

describe "AuthenticationPages" do

	subject { page }

  	describe "signin " do
  	# サインイン
    	before { visit signin_path }

    	describe "with invalid information" do
    	# 無効のとき
      		before { click_button "Sign in" }
      		it { should have_title('Sign in') }
      		it { should have_selector('div.alert.alert-error', text: 'Invalid') }

      		describe "after visiting another page" do
      		# 別のページに移動したとき
        		before { click_link "Home" }
        		it { should_not have_selector('div.alert.alert-error') }
      		end
    	end

    	describe "with valid information" do
    	# 有効なとき
      		let(:user) { FactoryGirl.create(:user) }
      		before do
        		fill_in "Email",    with: user.email.upcase
        		fill_in "Password", with: user.password
        		click_button "Sign in"
      		end

      		it { should have_title(user.name) }
      		it { should have_link('Profile', href: user_path(user)) }
      		it { should have_link('Sign out', href: signout_path) }
      		it { should_not have_link('Sign in', href: signin_path) }
    	end
	end
end
