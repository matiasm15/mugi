# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'minitest/reporters'
require 'minitest/autorun'
Minitest::Reporters.use!(Minitest::Reporters::SpecReporter.new)

require_relative '../src/mugi'

class TestMUGI < Minitest::Test
  # Ver 'A New Keystream Generator MUGI'
  def test_example_00
    key = Word.new([
      0x00,
      0x01,
      0x02,
      0x03,
      0x04,
      0x05,
      0x06,
      0x07,
      0x08,
      0x09,
      0x0a,
      0x0b,
      0x0c,
      0x0d,
      0x0e,
      0x0f
    ], 128)

    iv = Word.new([
      0xf0,
      0xe0,
      0xd0,
      0xc0,
      0xb0,
      0xa0,
      0x90,
      0x80,
      0x70,
      0x60,
      0x50,
      0x40,
      0x30,
      0x20,
      0x10,
      0x00
    ], 128)

    assert_equal MUGI.new(key, iv).get(8), [
      Word.new(0xbc62430614b79b71, 64),
      Word.new(0x71a66681c35542de, 64),
      Word.new(0x7aba5b4fb80e82d7, 64),
      Word.new(0x0b96982890b6e143, 64),
      Word.new(0x4930b5d033157f46, 64),
      Word.new(0xb96ed8499a282645, 64),
      Word.new(0xdbeb1ef16d329b15, 64),
      Word.new(0x34a9192c4ddcf34e, 64)
    ]
  end

  # Ver 'Specification Ver. 1.2'
  def test_example_01
    key = Word.new(0, 128)
    iv = Word.new(0, 128)

    assert_equal MUGI.new(key, iv).get(8), [
      Word.new(0xc76e14e70836e6b6, 64),
      Word.new(0xcb0e9c5a0bf03e1e, 64),
      Word.new(0x0acf9af49ebe6d67, 64),
      Word.new(0xd5726e374b1397ac, 64),
      Word.new(0xdac3838528c1e592, 64),
      Word.new(0x8a132730ef2bb752, 64),
      Word.new(0xbd6229599f6d9ac2, 64),
      Word.new(0x7c04760502f1e182, 64)
    ]
  end
end
