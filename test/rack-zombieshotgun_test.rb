require 'test_helper'

class ZombieShotgunTest < Test::Unit::TestCase
  
  include Rack::Test::Methods
  
  def setup
    app_with Proc.new { |env| [200, {"Content-Type" => "text/html"}, "good"] }
  end
  
  context 'Basic setup' do

    should 'get root' do
      get '/'
      assert last_response.ok?
    end
    
    should 'issue not found head when attacked' do
      get '/_vti_bin/foo/bar'
      assert last_response.not_found?
      assert_equal '', last_response.body
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

