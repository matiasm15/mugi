# frozen_string_literal: true

require_relative 'mugi'

module ImageCipher
  module_function

  def process(path, key, iv, out: 'out.bmp')
    image_url = nil
    body = nil

    File.open(path) do |file|
      image_url = file.read(54).bytes
      body = file.read.bytes
    end

    mugi = MUGI.new(key, iv)
    size = body.size.fdiv(8).ceil

    size.times do |n|
      image_url.concat((Word.new(body[n * 8, 8]).⊻ mugi.next).partition(8).map(&:to_i))
    end

    File.open(out, 'w') { |f| f.write(image_url.pack('c*')) }
  end
end

unless ARGV.empty?
  ImageCipher.process(ARGV[0], ARGV[1], ARGV[2], out: 'out.bmp' || ARGV[3])
end
