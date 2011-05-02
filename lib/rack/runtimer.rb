require 'rack'

module Rack
  class Runtimer

    def initialize( app, options = {} )
      @app, @options = app, options
    end


    def call(env)
      @start = Time.now
      status, headers, response = @app.call(env)
      @stop   = Time.now

      if headers['Content-Type'].to_s.include?('text/html')
        body = ''
        response.each { |part| body << part }
        body << message
        headers['Content-Length'] = body.length.to_s
        response = [body]
      end
      [status, headers, response]
    end
     

    private

    def message
      "<!-- Response time: #{@stop - @start} -->\n"
    end

  end
end
