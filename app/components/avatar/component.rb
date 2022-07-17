# frozen_string_literal: true

class Avatar::Component < ViewComponent::Base
  attr_reader :name, :email, :title

  def initialize(name:, email:, title:)
    @name = name
    @email = email
    @title = title
  end

  def gravatar_url
    "https://www.gravatar.com/avatar/#{email_hash}"
  end

  private

  def email_hash
    Digest::MD5.hexdigest(email)
  end
end
