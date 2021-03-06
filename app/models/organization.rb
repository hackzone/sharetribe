class Organization < ActiveRecord::Base
  attr_accessible :allowed_emails, :name, :logo, :company_id,
                  :email, :phone_number, :website, :address, :merchant_registration
  
  attr_accessor :email, :phone_number, :website, :address, :merchant_registration
  
  has_many :organization_memberships, :dependent => :destroy
  has_many :members, :through => :organization_memberships, :source => :person
  has_many :listings
  
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_format_of :company_id, :with => /^(\d{7}\-\d)?$/, :allow_nil => true
  
  paperclip_options_for_logo = PaperclipHelper.paperclip_default_options.merge!({:styles => {  
                      :medium => "288x288#",
                      :small => "108x108#",
                      :thumb => "48x48#", 
                      :original => "600x600>"},
                      :default_url => "/logos/header/default.png"
  })
  
  has_attached_file :logo, paperclip_options_for_logo
  
  
  def has_admin?(person)
    membership = OrganizationMembership.find_by_person_id_and_organization_id(person.id, self.id) 
    membership.present? && membership.admin
  end
  
  def register_a_merchant_account
    url = "https://rpcapi.checkout.fi/reseller/createMerchant"
    user = APP_CONFIG.merchant_api_user_id
    password = APP_CONFIG.merchant_api_password

    if APP_CONFIG.merchant_registration_mode == "production"
      type = 1 # Creates real merchant accounts
    else
      type = 2 # Creates test accounts
    end
         
    api_params = {
      "company" => name,
      "vat_id"  => company_id,
      "name"    => name,
      "email"   => email,
      "gsm"     => phone_number,
      "type"    => type,
      "info"    => "Materiaalipankki",
      "address" => address,
      "url"     => website,
      "kkhinta" => "0",
    }
    
    if APP_CONFIG.merchant_registration_mode == "production" || APP_CONFIG.merchant_registration_mode == "test" 
      response = RestClient::Request.execute(:method => :post, :url => url, :user => user, :password => password, :payload => api_params)
    else
      # Stub response to avoid unnecessary accounts being created (unless config is set to make real accounts)
      #puts "WOULD CALL MERCHANT API WITH: #{api_params.inspect}"
      response = "<merchant><id>123456</id><secret>exampledddfGisidnowtAthpowdUshyerbEuvRagNuishUcAnLihanshEmtyeifjitmowlIfyegyewfIvApdec=</secret><banner>http://rpcapi.checkout.fi/banners/5a1e9f504277f6cf17a7026de4375e97.png</banner></merchant>"
    end

    self.merchant_id = response[/<id>([^<]+)<\/id>/, 1]
    self.merchant_key = response[/<secret>([^<]+)<\/secret>/, 1]
    
    if self.merchant_id && self.merchant_key
      return true
    else
      return false
    end
  end
  
  def has_member?(person)
    members.include?(person)
  end
end
