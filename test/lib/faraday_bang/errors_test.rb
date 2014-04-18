require 'test_helper'

describe Faraday::Bang::ResponseError do

  let(:env) { OpenStruct.new(url: 'http://example.com') }
  let(:response) { OpenStruct.new(status: 500, env: env) }
  let(:error) { Faraday::Bang::ResponseError.new(response) }

  it 'has a useful error message' do
    error.response.must_equal response
    error.message.must_equal "Error making request to http://example.com (500)"
  end

end
