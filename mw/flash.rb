# thx to http://www.seanbehan.com/roll-your-own-session-based-flash-messaging-w-sinatra
# Simple flash messages
# flash = FlashMessage.new(session)
# flash.msg = 'hello world'
# flash.msg # => 'hello world'
# flash.msg # => nil
class FlashMessage
  def initialize(session)
    @session ||= session
  end

  def msg=(message)
    @session[:flash] = message
  end
  alias_method :message=, :msg=

  def msg
    message = @session[:flash] #tmp get the value
    @session[:flash] = nil # unset the value
    message # display the value
  end

end

helpers do
  def flash
    @flash ||= FlashMessage.new(session)
  end
end