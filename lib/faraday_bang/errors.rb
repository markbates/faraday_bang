class Faraday::Bang::ResponseError < StandardError
  attr_reader :response

  def initialize(response)
    @response = response
    super("Error making request to #{response.env.url} (#{response.status})")
  end

end

Faraday::Bang::ERROR_CODES.each do |code|
  Faraday::Bang.const_set("Response#{code}Error", Class.new(Faraday::Bang::ResponseError))
end
