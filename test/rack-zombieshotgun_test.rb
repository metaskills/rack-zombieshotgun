require 'test_helper'

class ZombieShotgunTest < Test::Unit::TestCase
  
  include Rack::Test::Methods
  
  def setup
    app_with(good_env)
  end
  
  context 'Basic setup' do

    should 'get root' do
      get '/'
      assert_response_ok
    end
    
    should 'issue not found head when attacked' do
      get '/_vti_bin/foo/bar'
      assert_head_not_found
    end

  end
  
  context 'With user agent' do

    should 'kill any bad user agent substring' do
      get_with_agent 'MS FrontPage Wicked Cool'
      assert_head_not_found
      get_with_agent 'Microsoft Data Access Internet Publishing Provider'
      assert_head_not_found
    end
    
    should 'not kill request if :agents option is turned off' do
      app_with good_env, :agents => false
      get_with_agent 'FrontPage'
      assert_response_ok
    end

  end
  
  context 'With directory' do

    should 'kill common attack dirs' do
      get '/MSOffice/cltreq.asp?UL=1&ACT=4&BUILD=6415&STRMVER=4&CAPREQ=0'
      assert_head_not_found
      get '/foo/_vti_bin/owssvr.dll?UL=1&ACT=4&BUILD=6415&STRMVER=4&CAPREQ=0'
      assert_head_not_found
    end
    
    should 'not kill dir names that appear not to be directories' do
      get '/myMSOfficedocs/here'
      assert_response_ok
    end
    
    should 'not kill request if :directories option is turned off' do
      app_with good_env, :directories => false
      get '/MSOffice/foobar'
      assert_response_ok
    end

  end
  
  
  

  protected
  
  def app
    Rack::ZombieShotgun.new(@myapp,@myoptions)
  end
  
  def app_with(env,options={})
    @myapp, @myoptions = env, options
  end
  
  def good_env
    Proc.new { |env| [200, {"Content-Type" => "text/html"}, "good"] }
  end
  
  def ua(agent)
    header 'User-Agent', agent
  end
  
  def get_with_agent(agent)
    ua(agent) && get('/')
  end
  
  def assert_head_not_found
    assert last_response.not_found?
    assert_equal '', last_response.body
  end
  
  def assert_response_ok
    assert last_response.ok?
  end

end

