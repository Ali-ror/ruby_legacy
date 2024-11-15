# == Schema Information
#
# Table name: users
#
#  id                   :integer(4)      not null, primary key
#  email                :string(255)     default(""), not null
#  encrypted_password   :string(128)     default(""), not null
#  password_salt        :string(255)     default(""), not null
#  reset_password_token :string(255)
#  remember_token       :string(255)
#  remember_created_at  :datetime
#  sign_in_count        :integer(4)      default(0)
#  current_sign_in_at   :datetime
#  last_sign_in_at      :datetime
#  current_sign_in_ip   :string(255)
#  last_sign_in_ip      :string(255)
#  confirmation_token   :string(255)
#  confirmed_at         :datetime
#  confirmation_sent_at :datetime
#  first_name           :string(255)
#  last_name            :string(255)
#  phone                :string(255)
#  fax                  :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  login                :string(255)
#  global_admin         :boolean(1)      default(FALSE)
#  opt_in_newsletter    :boolean(1)      default(FALSE)
#  authentication_token :string(255)
#

class Administrator < User
  # Autoscopes to just global admins and to bypass tweaking each administration controller to working with cancan
  default_scope global_admins
end
