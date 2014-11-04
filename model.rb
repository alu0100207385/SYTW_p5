require 'restclient'
require 'xmlsimple'


class Shortenedurl
  include DataMapper::Resource

   property :id, Serial
   property :email, Text
   property :url, Text
   property :label, Text
   property :n_visit, Integer, :default => 0
  
   has n, :visits
end

class Visit
  include DataMapper::Resource

  property  :id,          Serial, :key => true
  property  :created_at,  DateTime
  property  :ip,          IPAddress
  property  :country,     String
  
  belongs_to  :shortenedurl

#   after :create, :set_country

  def get_info
    xml = RestClient.get "http://api.hostip.info/get_xml.php?ip=#{self.ip}"
    self.country = XmlSimple.xml_in(xml.to_s)
    self.save
  end

end