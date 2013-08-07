class ApplicationController < ActionController::Base
  before_filter :set_locale
  protect_from_forgery
  include SessionsHelper

  #Force signout to prevent CSRF attacks
  def handle_unverified_request
    sign_out
    super
  end

  private
  def set_locale
    I18n.locale = set_by_params || extract_locale_from_accept_lang_header || I18n.default_locale
  end

  def set_by_params
    available = 
      REDIS_STORE.keys.collect do |key|
      key.split('.').first
      end
    available.uniq!

    if !params[:locale].nil? && available.include?(params[:locale][0..1])
      return params[:locale][0..1]
    else
      return false
    end
  end

  def extract_locale_from_accept_lang_header
    available = 
      REDIS_STORE.keys.collect do |key|
      key.split('.').first
      end
    available.uniq!
    unless available.nil? || available.empty?
      request.compatible_language_from(available)
    else
      return false
    end
  end
end
