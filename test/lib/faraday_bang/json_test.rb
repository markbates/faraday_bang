require 'test_helper'

describe Faraday::Response do

  let(:response) { Faraday::Response.new(body: {'foo' => 'bar'}.to_json) }

  it 'has an as_json method' do
    response.as_json.must_equal('foo' => 'bar')
  end

end
