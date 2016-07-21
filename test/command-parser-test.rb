# コードを追加
class CommandParserTest < Test::Unit::TestCase
  def test_parse
    # コードを追加
    parser = CommandParser.new()
    assert_equal Command.new(), parser.parse
  end
end
