module Rack
  class ZombieShotgun
    
    ZOMBIE_AGENTS = [
      'FrontPage',
      'Microsoft Office Protocol Discovery',
      'Microsoft Data Access Internet Publishing Provider Protocol Discovery',
      'Microsoft Data Access Internet Publishing Provider Cache Manager'
    ].freeze

    ZOMBIE_DIRS = ['_vti_bin','MSOffice','verify-VCNstrict','notified-VCNstrict'].freeze
    
    attr_reader :options, :request, :agent
    
    def initialize(app, options={})
      @app = app
      @options = options
    end
    
    def call(env)
      @agent = env['HTTP_USER_AGENT']
      @request = Rack::Request.new(env)
      zombie_attack? ? head_not_found : @app.call(env)
    end
    
    
    private
    
    def head_not_found
      [404, {"Content-Length" => "0"}, []]
    end

    def zombie_attack?
      zombie_dir_attack? || zombie_agent_attack?
    end

    def zombie_dir_attack?
      path = request.path_info
      ZOMBIE_DIRS.any? { |dir| path.include?("/#{dir}/") }
    end

    def zombie_agent_attack?
      agent && ZOMBIE_AGENTS.any? do |za|
        agent =~ /#{za}/
      end
    end

    
  end
end


