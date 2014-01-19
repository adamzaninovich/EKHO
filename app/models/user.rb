class User < ActiveRecord::Base

  def self.from_omniauth auth
    if GOOGLE_AUTH["authorized_users"].nil? || GOOGLE_AUTH["authorized_users"].include?(auth.info.email)
      where(auth.slice "provider", "uid").first || create_from_omniauth(auth)
    end
  end

  def self.create_from_omniauth auth
    create! do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.email = auth.info.email
      user.image = auth.info.image
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at auth.credentials.expires_at
      user.oauth_refresh_token = auth.credentials.refresh_token
    end
  end

  def get_mirror_api_client
    token = Mirror::Api::OAuth.new(GOOGLE_AUTH["key"], GOOGLE_AUTH["secret"], oauth_refresh_token).get_access_token
    Mirror::Api::Client.new token
  end

end

# == Schema Information
#
# Table name: users
#
#  id                   :integer          not null, primary key
#  provider             :string(255)
#  uid                  :string(255)
#  name                 :string(255)
#  email                :string(255)
#  image                :string(255)
#  oauth_token          :string(255)
#  oauth_expires_at     :datetime
#  oauth_refresh_token  :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#
