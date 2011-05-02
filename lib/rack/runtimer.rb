require 'rack'
require 'rack/utils'

module Rack
  class Runtimer

    def initialize( app, options = {} )
      @app, @options = app, options
    end


    def call
      status, headers, response = @app.call(env)
      body = 'This is a test'
      headers['Content-Length'] = Rack::Utils.bytesize(body).to_s
      [status, headers, [body]]
    end

    def temp(env)
      @start = Time.now
      status, headers, response = @app.call(env)
      @stop   = Time.now

      if headers['Content-Type'] =~ /text\/html|application\/xhtml\+xml/
        body = ''
        response.each { |part| body << part }
        index = body.rindex('</body>')
        if index
          body.insert( index, "<!-- This is a test -->" )
          headers['Content-Length'] = Rack::Utils.bytesize(body).to_s
          response = [body]
        end
      end
      [status, headers, response]
    rescue Exception => ex
      env['rack.errors'].write("#{ex.message}\n") if env['rack.errors']
      [500, {}, ex.message] 
    end
     

    private

    def message
     # "<!-- Response time: #{@stop - @start} -->"
    end

  end
end
