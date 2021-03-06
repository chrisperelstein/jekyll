require 'helper'
require 'ostruct'

class TestConvertible < Test::Unit::TestCase
  context "yaml front-matter" do
    setup do
      @convertible = OpenStruct.new
      @convertible.extend Jekyll::Convertible
      @base = File.expand_path('../fixtures', __FILE__)
    end

    should "parse the front-matter correctly" do
      ret = @convertible.read_yaml(@base, 'front_matter.erb')
      assert_equal({'test' => 'good'}, ret)
    end

    should "not parse if the front-matter is not at the start of the file" do
      ret = @convertible.read_yaml(@base, 'broken_front_matter1.erb')
      assert_equal({}, ret)
    end

    should "not parse if there is syntax error in front-matter" do
      out = capture_stdout do
        ret = @convertible.read_yaml(@base, 'broken_front_matter2.erb')
        assert_equal({}, ret)
      end
      assert_match(/YAML Exception|syntax error/, out)
    end

    if RUBY_VERSION >= '1.9.2'
      should "not parse if there is encoding error in file" do
        out = capture_stdout do
          ret = @convertible.read_yaml(@base, 'broken_front_matter3.erb')
          assert_equal({}, ret)
        end
        assert_match(/invalid byte sequence in UTF-8/, out)
      end
    end
  end
end
