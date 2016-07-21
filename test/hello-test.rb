# テストコードを書くためのライブラリを読み込む
require 'test/unit'
# テスト対象のコードを読み込む
require_relative '../src/hello'

class HelloTest < Test::Unit::TestCase
  def test_greeting
    hello = Hello.new
    assert_equal 'Hello, world!', hello.greeting
  end
end
