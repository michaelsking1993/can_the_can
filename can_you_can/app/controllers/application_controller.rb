class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception


  def upload_lemmas
    lexi_en = File.open(File.join(Rails.root, '/lib/tasks/word_data/lemmatization-en.txt'), 'r')

  end
end
