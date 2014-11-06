require 'restclient'
require 'xmlsimple'


class ShortenedUrl
  include DataMapper::Resource

   property :id, Serial
   property :email, Text
   property :url, Text
   property :label, Text
#    property :n_visit, Integer, :default => 0
  
   has n, :visits
end

class Visit
  include DataMapper::Resource

  property  :id,          Serial, :key => true
  property  :created_at,  DateTime
  property  :ip,          IPAddress
  property  :country,     String
  
  belongs_to :shortenedurl
end
