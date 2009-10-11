require 'test_helper'

class ZombieShotgunTest < Test::Unit::TestCase
  
  include Rack::Test::Methods
  
  context 'Basic setup' do

    setup do
      app_with Proc.new { |env| [200, {"Content-Type" => "text/html"}, "good"] }
    end

    should 'get root' do
      get '/'
      assert last_response.ok?
    end

  end
  

  protected
  
  def app
    Rack::ZombieShotgun.new(@myapp)
  end
  
  def app_with(env)
    @myapp = env
  end

end

