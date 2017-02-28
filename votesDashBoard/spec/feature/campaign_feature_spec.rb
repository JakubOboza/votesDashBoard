require 'rails_helper'
require_relative '../helper.rb'

feature 'campaign' do
  before(:each) do
    create_db_entry
  end
  context 'when there are running campaigns' do
    scenario 'viewing the campaign page' do
      visit '/'
      click_link('View')
      expect(page).to have_content("Campaign ssss_uk_01B")
      expect(page).to have_content('Total votes: 1')
      expect(page).to have_content('Leon')
    end
  end
end
