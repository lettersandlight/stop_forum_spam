module StopForumSpam
  class UnsuccessfulResponse < StandardError; end

  class Client
    include HTTParty
    format :xml
    base_uri("http://stopforumspam.com")
    
    attr_accessor :api_key
    
    def initialize(api_key=nil)
      @api_key = api_key
    end
    
    def post(options={})
      self.class.post('/post.php', 
        :body => {
          :ip_addr => options[:ip_address], 
          :email => options[:email], 
          :username => options[:username], 
          :api_key => api_key })
    end
    
    def get(options={})
      ensure_success { self.class.get('/api', options) }
    end

    private

    # Wraps the given request block to ensure that the response's success
    # flag is true.
    #
    def ensure_success
      result = yield
      raise UnsuccessfulResponse.new unless result['response']['success'] == 'true'
      result
    end
  end
end
