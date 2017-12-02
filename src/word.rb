# frozen_string_literal: true

# Representa las palabras en base 2.
class Word
  include Comparable

  # Base binaria.
  BASE = 2

  # Genera una palabra.
  # @param param [Integer, Word, Array<Integer, Word>] objecto que se convertira en una palabra.
  # @param size [Integer] tamaño del Word.
  # @raise [ArgumentError] si la clase de <em>param</em> es inválida.
  def initialize(param, size = nil)
    case param
    when Integer
      @size = size || 8
      @n = param
    when Array
      @size = size || param.sum(&:size)
      @n = param.reverse.inject do |acu, i|
        i.to_word + acu
      end.to_i
    when Word
      @size = size || param.size
      @n = param.to_i
    end

    @n %= BASE**@size
  end

  # Devuelve el tamaño de la palabra.
  # @return [Numeric] tamaño de la palabra.
  def size
    @size
  end

  # Concatena dos palabras.
  # @param word [Word] palabra que se va a concatenar a la derecha.
  # @return [Word] palabras concatenadas.
  def +(word)
    Word.new((@n << word.size) + word.to_i, @size + word.size)
  end

  # Devuelve un *xor* de dos palabras.
  # @param value [Word] palabra con la que se va a realizar el *xor*.
  # @return [Word] resultado de *xor*.
  def ^(value)
    Word.new(@n ^ value.to_i, @size)
  end

  # Devuelve un *or* de dos palabras.
  # @param word [Word] palabra con la que se va a realizar el *or*.
  # @return [Word] resultado de *or*.
  def |(word)
    Word.new(@n | word.to_i, @size)
  end

  # Devuelve un *and* de dos palabras.
  # @param word [Word] palabra con la que se va a realizar el *and*.
  # @return [Word] resultado de *and*.
  def &(word)
    Word.new(@n & word.to_i, @size)
  end

  # Desplaza bits hacia la izquierda.
  # @param value [Numeric] cantidad de bits a desplazar.
  # @return [Word] resultado del desplazamiento.
  def <<(value)
    Word.new(@n << value.to_i, @size)
  end

  # Desplaza bits hacia la derecha.
  # @param value [Numeric] cantidad de bits a desplazar.
  # @return [Word] resultado de haber rotado la palabra.
  def >>(value)
    Word.new(@n >> value.to_i, @size)
  end

  # Rota bits hacia la derecha.
  # @param value [Numeric] cantidad de bits a rotar.
  # @return [Word] resultado de haber rotado la palabra.
  def ⋙(value)
    self >> value | self << (@size - value)
  end

  # Rota bits hacia la izquierda.
  # @param value [Numeric] cantidad de bits a rotar.
  # @return [Word] resultado de haber rotado la palabra.
  def ⋘(value)
    self << value | self >> (@size - value)
  end

  # Devuelve una partición de la palabra.
  # @param value [Numeric] cantidad de particiones.
  # @return [Array<Word>] particiones.
  def partition(value)
    new_size = @size / value
    last_index = value - 1

    (0..last_index).map do |i|
      Word.new(@n >> (new_size * (last_index - i)), new_size)
    end
  end

  # Transforma el número en un entero.
  # @return [Numeric] entero que representa a la palabra.
  def to_i
    @n
  end

  # Transforma el número en un string.
  # @return [String] string que representa a la palabra.
  def to_s
    "0b#{@n.to_s(BASE).rjust(@size, '0')}"
  end

  # Devuelve la representación del la palabra en hexadecimal.
  # @return [String] string que representa a la palabra en hexadecimal.
  def to_hex
    to_i.to_s(16).rjust(@size.fdiv(4).ceil, '0')
  end

  # Devuelve a si mismo.
  # @return [Word] la palabra.
  def to_word
    self
  end

  # Compara la palabra con otra palabra.
  # @param word [Word] palabra con la que se va a comparar.
  # @return [-1,0,1] resultado de la comparación.
  def <=>(word)
    return @size <=> word.size unless @size == word.size

    @n <=> word.to_i
  end

  # Inspecciona la palabra.
  def inspect
    to_s
  end

  alias_method :≫, :>>
  alias_method :≪, :<<
  alias_method :∧, :&
  alias_method :∨, :|
  alias_method :⊻, :^
  alias_method :left_rotate, :⋘
  alias_method :right_rotate, :⋙
end
