require 'spec_helper'

describe "StaticPages" do
	#Test Home page
	describe "Home page" do
		it "should have the content 'Home' " do
			visit '/static_pages/home'
			expect(page).to have_content('Home')
		end
	end
end
