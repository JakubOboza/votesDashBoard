class CreateVotes < ActiveRecord::Migration
def self.up
  create_table "votes", force: :cascade do |t|
    t.string "type",      limit: 50
    t.string "epoch",     limit: 50
    t.string "campaign",  limit: 50
    t.string "validity",  limit: 50
    t.string "choice",    limit: 50
    t.string "conn",      limit: 50
    t.string "msisdn",    limit: 50
    t.string "guid",      limit: 50
    t.string "shortcode", limit: 50
  end
end


end
