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

      if headers['Content-Type'] =~ /text\/html|application\/xhtml\+xml/
        body = ''
        response.each { |part| body << part }
        index = body.rindex('</body>')
        if index
          body.insert( index, 'This is a test' )
          headers['Content-Length'] = body.length.to_s
          response = [body]
        end
      end
      [status, headers, response]
    end
     

    private

    def message
     # "<!-- Response time: #{@stop - @start} -->"
    end

  end
end
