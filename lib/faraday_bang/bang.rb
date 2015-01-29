module Faraday::Bang
  ERROR_CODES = [(400..417).to_a, (500..505).to_a].flatten

  Faraday::Connection::METHODS.each do |verb|
    define_method("#{verb}!") do |*args, &block|
      response = self.send(verb, *args, &block)
      if response.status >= 400
        err_name = "Response#{response.status}Error"
        if Faraday::Bang.const_defined?(err_name)
          klass = Faraday::Bang.const_get(err_name)
          raise klass.new(response)
        else
          raise Faraday::Bang::ResponseError.new(response)
        end
      end
      return response
    end
  end

end

Faraday.extend(Faraday::Bang)
Faraday::Connection.send(:include, Faraday::Bang)
