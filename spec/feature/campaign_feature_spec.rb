require 'rails_helper'

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
      Vote.create(vote: 'VOTE',
      epoch: '1168041837',
      campaign: 'ssss_uk_01B',
      validity: 'during',
      choice: 'Leon',
      conn: 'MIG00VU',
      msisdn:'00777770939999',
      guid: '88B52A7B-A182-405C-9AE6-36FCF2E47294',
      shortcode: '63334')
    end
    scenario 'viewing the campaigns list page' do
      visit '/'
      expect(page).to have_content("Currently Running Campaigns 1")
    end
  end
end
