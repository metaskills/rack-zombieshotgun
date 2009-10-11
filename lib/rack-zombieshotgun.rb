module Rack
  class ZombieShotgun
    
    ZOMBIE_AGENTS       = ['FrontPage',
                           'Microsoft Office Protocol Discovery',
                           'Microsoft Data Access Internet Publishing Provider Protocol Discovery',
                           'Microsoft Data Access Internet Publishing Provider Cache Manager'].freeze

    ZOMBIE_ATTACK_DIRS  = ['_vti_bin','MSOffice','verify-VCNstrict','notified-VCNstrict'].freeze
    
    def initialize(app, options={})
      @app = app
    end
    
    def call(env)
      zombie_attack? ? head_not_found : @app.call(env)
    end
    
    
    private
    
    def head_not_found
      [404, {"Content-Length" => "0"}, []]
    end

    def zombie_attack?
      zombie_attack_on_directory? || zombie_agent_attack?
    end

    def zombie_attack_on_directory?
      # request_path = request.path.from(1)
      # request_dir = request_path.index('/').nil? ? request_path : request_path.to(request_path.index('/')-1)    
      # ZOMBIE_ATTACK_DIRS.include?(request_dir)
    end

    def zombie_agent_attack?
      # ua = request.env['HTTP_USER_AGENT']
      # !ua.blank? && ZOMBIE_AGENTS.any? { |za| ua =~ /#{za}/ }
    end

    
  end
end


