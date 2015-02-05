module Faraday::Bang
  ERROR_CODES = [(400..417).to_a, (500..505).to_a].flatten
  SUPPORTED_HTTP_METHODS = Faraday::Connection::METHODS - [ :options ]

  SUPPORTED_HTTP_METHODS.each do |verb|
    define_method("#{verb}!") do |*args, &block|
      response = self.send(verb, *args, &block)
      handle_response(response)
    end
  end

  def options!(*args, &block)
    url, body, headers = args
    response = run_request(:options, url, body, headers, &block)
    handle_response(response)
  end

  private
  def handle_response(response)
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
