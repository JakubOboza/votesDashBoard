require 'rails_helper'
require_relative '../helper.rb'
feature 'campaigns' do
  context 'when have no campaigns' do
    scenario 'viewing the campaigns list page' do
      visit '/'
      expect(page).to have_content("Currently Running Campaigns 0")
      expect(page).to have_no_link('View')
    end
  end
  context 'when there are running campaigns' do
    before(:each) do
      create_db_entry
    end
    scenario 'viewing the campaigns list page' do
      visit '/'
      expect(page).to have_content("Currently Running Campaigns 1")
      expect(page).to have_link('View')
      expect(page).to have_content('ssss_uk_01B')
    end
  end
end
