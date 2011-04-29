class Runtimer

  def initialize( app, options = {} )
    @app, @options = app, options
  end


  def call(env)
    @start = Time.now
    status, headers, body = @app.call(env)
    @stop   = Time.now

    if headers['Content-Type']/to_s.include?('text/html')
      body = (body << message)
      headers['Content-Length'] = Rack::Utils.bytesize(body.to_s).to_s
    end
  end
   

  private

  def message
    "<!-- Reponse time: #{@stop - @start} -->\n"
  end

end



