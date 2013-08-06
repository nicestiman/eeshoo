class TranslationsController < ApplicationController
  def index
    @translations = REDIS_STORE
  end

  def create
    I18n.backend.store_translations(params[:locale], {params[:key] => params[:value]}, :escape = false)
    redirect to translations_path, :notice => "Added translation"
  end
end
