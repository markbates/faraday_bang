require 'test_helper'

describe Faraday::Bang do

  let(:url) { 'http://example.com' }
  let(:args) { {a: 'b'} }
  let(:body) { {foo: 'bar'}.to_json }

  [Faraday, Faraday.new].each do |klass|
    let(:response) { mock(body: body, status: 200) }

    Faraday::Bang::SUPPORTED_HTTP_METHODS.each do |verb|

      it "##{verb}! passes a block" do
        block = Proc.new do |req|
          raise "dummy error #{verb}"
        end
        error = ->{ klass.send("#{verb}!", &block) }.must_raise RuntimeError
        error.message.must_equal "dummy error #{verb}"
      end

      describe "##{verb}!" do

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

    describe "options!" do
      it "passes a block" do
        block = Proc.new do |req|
          raise "dummy error options"
        end
        error = ->{ klass.send("options!", &block) }.must_raise RuntimeError
        error.message.must_equal "dummy error options"
      end

      describe 'successful response' do
        before do
          klass.expects(:run_request).with(:options, url, args, nil).returns(response)
        end

        it 'passes the call onto Faraday' do
          res = klass.send("options!", url, args)
          res.body.must_equal body
        end
      end

      describe 'unsuccessful response' do
        let(:env) { OpenStruct.new(url: 'http://example.com') }
        let(:response) { OpenStruct.new(body: body, status: 506, env: env) }

        before do
          klass.expects(:run_request).with(:options, url, args, nil).returns(response)
        end

        it 'raises an error if its a non-200 response without an explicit exception' do
          ->{klass.send("options!", url, args)}.must_raise Faraday::Bang::ResponseError, body
        end

        Faraday::Bang::ERROR_CODES.each do |code|

          context code do

            let(:response) { OpenStruct.new(body: body, status: code, env: env) }

            it "raises a Faraday::Bang::Response#{code}Error" do
              ->{klass.send("options!", url, args)}.must_raise Faraday::Bang.const_get("Response#{code}Error")
            end

          end
        end
      end
    end

  end

end
