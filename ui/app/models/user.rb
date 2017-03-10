# app/models/user.rb
require 'net/ldap'

class User

  def authenticate_ldap(username, password)
    # return email if success
    raise ArgumentError, 'username is nil' if username.nil?
    raise ArgumentError, 'password is nil' if password.nil?

    ldap = Net::LDAP.new
    ldap.host = LDAP_CONFIG[:host]
    ldap.port = LDAP_CONFIG[:port]
    bind_dn = "uid=" + username + "," + LDAP_CONFIG[:base]
    ldap.auth bind_dn, password
    if ldap.bind
      base = LDAP_CONFIG[:base]
      filter = Net::LDAP::Filter.eq("uid", username)
      attrs = ["mail"]
      entry = ldap.search(:base => base, :filter => filter, :attributes => attrs, :return_result => true)[0]
      @_user = {
        :uid => username,
        :email => entry.mail[0]
      }
    else
      @_user = nil
    end
  end

  def get(username, email)
    if username.nil?
      username = 'guest'
    end
    capabilities = []
    if LDAP_CONFIG[:admins].split(",").include? username
      capabilities.push('admin')
    end
    @_user = {
      :username => username,
      :email => email,
      :capabilities => capabilities
    }
  end

end
