class Authorization
  include Ripple::Document
  property :provider, String, :presence => true
  property :uid, String, :presence => true
  property :extra, Object
  property :user_key, String
  one :user_info, :class_name => "UserInfo"
  one :credentials, :class_name => "Credentials"
  one :user, :class_name => "User", :using => :stored_key

  def key
    "#{self.provider}-#{self.uid}"
  end

  def self.find_from_auth(auth)
    auth_key = "#{auth['provider']}-#{auth['uid']}"
    find(auth_key)
  end

  def self.create_from_auth!(auth, user)
    user ||= User.create!
    a = user.authorizations.create!(auth.merge(:user_key => user.key))
    user.save!
    return a
  end

  def as_json(option={})
    attributes
  end
end
