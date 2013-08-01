class ApplicationController < ActionController::Base
  before_filter :set_locale
  protect_from_forgery
  include SessionsHelper

  #Force signout to prevent CSRF attacks
  def handle_unverified_request
    sign_out
    super
  end

  def set_locale
    I18n.locale = params[:locale] || extract_locale_from_accept_lang_header || I18n.default_locale
  end

  private
    def extract_locale_from_accept_lang_header
      available = Translation.lang_list
      request.compatible_language_from(available)
    end
end
