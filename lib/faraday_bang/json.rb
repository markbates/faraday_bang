class Faraday::Response

  def as_json
    @_json ||= JSON.parse(body)
  end

end
