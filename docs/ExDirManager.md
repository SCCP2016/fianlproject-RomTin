# 最終課題 ~実践的プログラミング~

## はじめに

最終課題では、今まで授業で習った知識や経験を活かして簡単なアプリを作る。
最終課題はコースを二種類設ける。原則、次節で説明する仕様に沿っている必要がある。
初級コースは、予め用意されたテンプレートを使い問題箇所を埋めて完成を目指そう。
上級コースは、一から(フルスクラッチ)コードを組み立てて完成を目指そう。

## 仕様

授業、特にコンピュータ演習に使われる規則的な名前を持つディレクトリ構造を生成・管理するアプリである。

### 規則的な名前を持つディレクトリを生成(初級・上級)

```
# Prog0出だしで、ディレクトリの先頭に「Ex」が付き、2桁表示　13回までのディレクトリを作る。
# ちなみにこれらのオプションは「g」以外デフォルト値とする。
$ ruby exdirmng.rb generate Prog0 -h Ex -f 2 -m 13
$ ls $HOME/Prog0
Ex01/ Ex02/ Ex03/ Ex04/ ... Ex13/
```

### 生成したディレクトリの提出率を出す(上級)

```
$ ruby exdirmng.rb submit Prog0
[o]Ex01 [o]Ex02 [o]Ex03 [x]Ex04 ... [x]Ex13
提出率 (3/13)
```

### 生成したディレクトリの一覧表示(上級)

```
$ ruby exdirmng.rb list
Prog0 Literacy Prog1
```

### エラーやヘルプを豊富にする(初級？・上級)

```
$ ruby exdirmng.rb
引数にディレクトリ名を入れるか、generateコマンドを指定してディレクトリを生成してください。

提出率の確認
ruby exdirmng.rb [ディレクトリ]
課題ディレクトリの生成
ruby exdirmng.rb generate [ex-dir] -h [dir-header] -f [format] -m [max]
```

### 実行ディレクトリを用意して、パスを通し、通常コマンドとする(初級・上級)

```
$ exdirmng g Prog0
```

### 機能を拡張する(上級)

- 生成したディレクトリをgitで自動管理
- 課題全体の提出率を算出
- 不規則(例外のある)ディレクトリ構造に対応
- etc...

## 仕様図解

前節で話した仕様を図解すると、以下の様な図になる。この図はUMLと呼ばれるものであるが、詳しい図の見方は現時点で覚えなくても良い。
仕様と照らしあわせて見て理解へと繋げよう。

以下は、プロジェクトのクラス構造を表したクラス図である。

![](https://gist.githubusercontent.com/ababup1192/57616db851e484e426f7fd3a1f540494/raw/b4d7f042360f27794d661d6cf228d19bc47f4b3e/class.png)

以下は、クラスから作ったインスタンスの例示を表したオブジェクト図である。

![](https://gist.github.com/ababup1192/57616db851e484e426f7fd3a1f540494/raw/a3826f081ea4013bbcc934529bee0cbdfcea1e9c/object.png)

## 開発ステップ(初級・上級)

規模の大きい(複数の機能が組み合わされた)プログラムを書く場合は、実コードとテストコードを分けて
テスト通す形に変更しながら開発を進めよう。テストコードとは、機能が正しく実装できているかどうかをチェックする
ために書くコードのことである。テストコードを書くことで、プログラムの挙動を確かめれたり、
コードが綺麗になったり、機能変更によるバグを発見しやすくなったり、拡張しやすいコード作りが出来る。
https://ja.wikipedia.org/wiki/テスト駆動開発

### テストがしやすいディレクトリ構造

以下のように、実コードを*src*ディレクトリ、テストコードを*test*ディレクトリに配置する。
実コードとテストコードの対応が取りやすいように、テストコードのファイル名は、*[実コード]-test.rb*
という規則で名前を付けるのが好ましい。

```
ExDirManager
├── src
│   └── hello.rb
└── test
    └── hello-test.rb
```

以下に実コードとテストコードの例を挙げる。

classを使っているが、非常に単純で*greeting*というメソッドが文字列を返している。

src/hello.rb

```ruby
class Hello
  def greeting
    'Hello!'
  end
end
```

テストコードは、テストコードを書くためのライブラリと先ほど書いた、
hello.rbを相対パスから読み込んでいる。(相対パスから読み込む場合は、*require_relative*を使う)
テストクラスHelloTestにテスト機能を追加するために継承(資料参考)をしている。
メソッド一つ一つがテストの単位になっている。今回はメソッドHello#greetingをテストするための、
test_greetingメソッドを用意している。中では、Helloクラスをインスタンス化(実体化)して、
*assert_equal*というメソッドを使うことで文字列を比較をしている。

test/hello-test.rb

```ruby
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
```

２つのコードが無事配置出来たら、テストコードを実行してみよう。

```
$ pwd
/home/~~~/ExDirManager
$ ruby test/hello-test.rb
```

赤文字がターミナルに表示されたら無事失敗である。
実コードとテストコードを見比べて、間違いを発見し直したら、もう一度テストコードを実行してみよう。
緑文字のみがターミナルに表示されたら、おめでとうテストコードが通ったことになる。

## 開発ステップ(初級)

### フィールドの追加

それでは、テンプレートを使いながら開発を進めていこう。ディレクトリを生成するクラス*DirRepository*のテンプレートを以下に示す。
*DirRepository*今回作るアプリのコアに当たる部分で、ここが実装出来てしまえばグッと完成に近づく。

src/dir-repository.rb

```ruby
class DirRepsitory
  # 仕様を見てコードを追加
  attr_reader :dir_name, :header
  
  # 仕様を見てコードを追加
  def initialize(dir_name, header)
    @dir_name = dir_name
    @header = header
  end

  # メソッドの中身のコードを追加
  def make
  end
end
```

これに対応するテストコードは以下になる。

test/dir-repository-test.rb

```ruby
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
end
```

上の仕様を確認し、ディレクトリ生成に必要な情報をコンストラクタ等に追加しよう。必要な情報を追記して、テストコードを修正した後は、テストコードを実行してみよう。
無事テストが通ったら次のステップだ。

### ディレクトリ名配列の生成

必要十分なフィールドを用意出来たら、生成するディレクトリを列挙した配列を生成し、返すメソッド　*create_directories* を実装しよう。
出来たらテストを書いてみよう。

test/dir-repository-test.rb

```ruby
class DirRepositoryTest < Test::Unit::TestCase
  def test_constructor
    ~~~
  end
  
  def test_create_directories
    dir_repository = DirRepository.new("Prog0", "Ex", )
    # mapメソッドを使うともっと楽に書けるぞ
    assert_equal [Dir.new("Ex01"), Dir.new("Ex02"), 
      Dir.new("Ex03"), Dir.new("Ex04"), Dir.new("Ex05")], dir_generator.create_directories
  end
end
```


### ディレクトリの生成

ここまで出来てしまえば後は単純だ。*create_directories*メソッドを利用して、実際のディレクトリを生成する*make*メソッドを実装して、試してみよう。
*make*に対するテストコードを書くことは不可能ではないが、少し困難なので今回は直接実コードを実行してみよう。

### コマンドの生成

ディレクトリの生成が出来たので、今度はコマンドを作ろう。コマンドのパラメータを持つ*Command*クラスを作ろう。
それが出来たら、*CommandTest*クラスも作ろう

src/command.rb

```ruby
# コードを追加
class Command
end
```

test/command-test.rb

```ruby
# コードを追加
class CommandTest
end
```

*Command*クラスが出来たら、DirGeneratorのコンストラクタ(initializeメソッド)や、内部の処理を変更することができるはずだ。
テストも一部修正をし、テストを実行してみよう。

### コマンドの解析

このアプリでは以下のように、コマンドを実行する。
このときの```ruby exdirmng.rb``` より後ろの文字列のことを、*コマンドライン引数*と呼ぶ。

```
$ ruby exdirmng.rb generate Prog0 -h Ex -f 2 -m 13
```

コマンドライン引数は、rubyではどのような扱いになるのだろうか？
以下のソースコードを書いて実行してみよう。

argv.rb
```ruby
p ARGV
```

出来たら以下の様に実行してみよう。

```
$ ruby argv.rb generate Prog0 -h Ex -f 2 -m 13
["generate", "Prog0", "-h", "Ex", "-f", "2", "-m", "13"]
```

あとは、得られた文字列の配列からコマンドを生成する、*CommandParser*クラスを作ろう。

src/command-parser.rb

```ruby
# コードを追加
class CommandParser
  attr_reader :argv
  def initialize(argv)
    @argv = argv
  end
  
  # コードを追加
  def parse
  end
end
```

test/command-parser-test.rb

```ruby
# コードを追加
class CommandParserTest < Test::Unit::TestCase
  def test_parse
    # コードを追加
    parser = CommandParser.new()
    assert_equal Command.new(), parser.parse
  end
end
```

### Mainの作成

遂に最後の仕上げだ。Mainクラスのコンストラクタに、今まで作ったクラスを使った処理を追加しよう。
テストは十分に書いたので、正しく組み合わせれば問題なく動くはずだ。

exdirmng.rb

```ruby
class Main
  def initialize
    # コードを追加
    # ARGV
  end
end

Main.new
```