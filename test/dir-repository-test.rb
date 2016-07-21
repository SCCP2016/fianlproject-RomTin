require 'test/unit'
# コードを追加

class DirRepositoryTest < Test::Unit::TestCase
    def test_constructor
        # コードを追加
        dir_generator = DirRepository.new("Prog0", "Ex", )
        assert_equal "Prog0", dir_generator.dir_name
        assert_equal "Ex", dir_generator.header
        # コードを追加(他のテスト項目)

    end

    def test_create_directories
        dir_repository = DirRepository.new("Prog0", "Ex", )
        # mapメソッドを使うともっと楽に書けるぞ
        assert_equal [Dir.new("Ex01"), Dir.new("Ex02"), 
                      Dir.new("Ex03"), Dir.new("Ex04"), Dir.new("Ex05")], dir_generator.create_directories
    end
end
