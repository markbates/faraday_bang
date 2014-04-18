require 'test_helper'

describe Faraday::Bang do

  let(:url) { 'http://example.com' }
  let(:args) { {a: 'b'} }
  let(:body) { {foo: 'bar'}.to_json }

  [Faraday, Faraday.new].each do |klass|

    Faraday::Connection::METHODS.each do |verb|

      describe "##{verb}!" do

        let(:response) { mock(body: body, status: 200) }

        before do
          klass.expects(verb).with(url, args).returns(response)
        end

        describe 'successful response' do

          it 'passes the call onto Faraday' do
            res = klass.send("#{verb}!", url, args)
            res.body.must_equal body
          end

        end

        describe 'unsuccessful response' do

          let(:env) { OpenStruct.new(url: 'http://example.com') }
          let(:response) { OpenStruct.new(body: body, status: 506, env: env) }

          it 'raises an error if its a non-200 response without an explicit exception' do
            ->{klass.send("#{verb}!", url, args)}.must_raise Faraday::Bang::ResponseError, body
          end

          Faraday::Bang::ERROR_CODES.each do |code|

            context code do

              let(:response) { OpenStruct.new(body: body, status: code, env: env) }

              it "raises a Faraday::Bang::Response#{code}Error" do
                ->{klass.send("#{verb}!", url, args)}.must_raise Faraday::Bang.const_get("Response#{code}Error")
              end

            end

          end

        end

      end

    end

  end

end
