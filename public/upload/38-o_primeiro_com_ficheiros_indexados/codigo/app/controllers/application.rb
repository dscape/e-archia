class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  protect_from_forgery # :secret => 'e872b69689e3a43a94112df8938660c0'
end
