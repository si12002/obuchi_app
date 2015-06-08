require 'spec_helper'

describe "StaticPages" do

  describe "Home page" do
	it "should have the content 'Obuchi App'" do
      visit '/static_pages/home'
      expect(page).to have_content('Obuchi App')
    end

    it "should have the title 'Home'" do
      visit '/static_pages/home'
      expect(page).to have_title("Obuchi App | Home")
    end
  end


  describe "About page" do
    it "should have the content 'About Us'" do
      visit '/static_pages/about'
      expect(page).to have_content('About Us')
    end

    it "should have the title 'About Us'" do
      visit '/static_pages/about'
      expect(page).to have_title("Obuchi App | About Us")
    end
  end

end
