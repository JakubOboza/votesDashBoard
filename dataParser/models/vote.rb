class Vote

  include DataMapper::Resource

  property :id, Serial
  property :vote, String
  property :epoch, String
  property :campaign, String
  property :validity, String
  property :choice, String
  property :conn, String
  property :msisdn, String
  property :guid, String
  property :shortcode, String

end
