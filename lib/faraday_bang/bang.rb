module Faraday::Bang
  ERROR_CODES = [(400..417).to_a, (500..505).to_a].flatten
  SUPPORTED_HTTP_METHODS = Faraday::Connection::METHODS - Set.new([ :options ])

  SUPPORTED_HTTP_METHODS.each do |verb|
    define_method("#{verb}!") do |*args, &block|
      response = self.send(verb, *args, &block)
      handle_error(response)
    end
  end

  define_method("options!") do |*args, &block|
    url, params, headers = args
    response = run_request(:options, url, params, headers, &block)
    handle_error(response)
  end

  private
  def handle_error(response)
    if response.status >= 400
      err_name = "Response#{response.status}Error"
      if Faraday::Bang.const_defined?(err_name)
        klass = Faraday::Bang.const_get(err_name)
        raise klass.new(response)
      else
        raise Faraday::Bang::ResponseError.new(response)
      end
    end
    response
  end
end

Faraday.extend(Faraday::Bang)
Faraday::Connection.send(:include, Faraday::Bang)
