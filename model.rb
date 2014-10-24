class ShortenedUrl
  include DataMapper::Resource

  property :id, Serial
  property :email, Text
  property :url, Text
  property :label, Text
end
