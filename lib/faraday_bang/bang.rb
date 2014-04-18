module Faraday::Bang
  ERROR_CODES = [(400..417).to_a, (500..505).to_a].flatten

  Faraday::Connection::METHODS.each do |verb|
    define_method("#{verb}!") do |*args|
      response = self.send(verb, *args)
      if response.status >= 400
        err_name = "Faraday::Bang::Response#{response.status}Error"
        if Module.const_defined?(err_name)
          klass = Module.const_get(err_name)
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
