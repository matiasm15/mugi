# frozen_string_literal: true

# Representa las palabras en base 2.
class Word
  include Comparable

  # Base binaria.
  BASE = 2

  # Genera una palabra.
  # @param param [Numeric, Word, Array<Numeric, Word>] objecto que se convertira en una palabra.
  # @param size [Numeric] tamaño del Word.
  # @raise [ArgumentError] si la clase de <em>param</em> es inválida.
  def initialize(param, size = nil)
    case param
    when Numeric
      @size = size || (param.zero? ? 8 : [Math.log2(param).ceil, 8].max)
      @n = param
    when Word
      @size = size || param.size
      @n = param
    when Array
      @size = size || param.sum(&:size)
      @n = param.reverse.inject do |acu, i|
        Word(i) + acu
      end
    else
      raise ArgumentError, 'Argument must be Numeric, Word or Array'
    end

    @n = @n.to_i % BASE**@size
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
    Word((@n << word.size) + word.to_i, @size + word.size)
  end

  # Devuelve un *xor* de dos palabras.
  # @param value [Word] palabra con la que se va a realizar el *xor*.
  # @return [Word] resultado de *xor*.
  def ^(value)
    Word(@n ^ value.to_i, @size)
  end

  # Devuelve un *or* de dos palabras.
  # @param word [Word] palabra con la que se va a realizar el *or*.
  # @return [Word] resultado de *or*.
  def |(word)
    Word(@n | word.to_i, [@size, word.size].max)
  end

  # Devuelve un *and* de dos palabras.
  # @param word [Word] palabra con la que se va a realizar el *and*.
  # @return [Word] resultado de *and*.
  def &(word)
    Word(@n & word.to_i, [@size, word.size].max)
  end

  # Desplaza bits hacia la izquierda.
  # @param value [Numeric] cantidad de bits a desplazar.
  # @return [Word] resultado del desplazamiento.
  def <<(value)
    Word(@n << value.to_i, @size)
  end

  # Desplaza bits hacia la derecha.
  # @param value [Numeric] cantidad de bits a desplazar.
  # @return [Word] resultado de haber rotado la palabra.
  def >>(value)
    Word(@n >> value.to_i, @size)
  end

  # Rota bits hacia la derecha.
  # @param value [Numeric] cantidad de bits a rotar.
  # @return [Word] resultado del desplazamiento.
  def ⋙(value)
    self >> value | self << ((@size - value) % @size)
  end

  # Rota bits hacia la izquierda.
  # @param value [Numeric] cantidad de bits a rotar.
  # @return [Word] resultado de haber rotado la palabra.
  def ⋘(value)
    self << value | self >> ((@size - value) % @size)
  end

  # Devuelve una partición de la palabra.
  # @param value [Numeric] cantidad de particiones.
  # @return [Array<Word>] particiones.
  def partition(value)
    new_size = @size / value
    last_index = value - 1

    (0..last_index).map do |i|
      new_value = @n >> (new_size * (last_index - i))

      Word(new_value, new_size)
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

  # Transforma la palabra en una palabra de otro tamaño.
  # @param size [Numeric] tamaño de la nueva palabra.
  # @return [Word] nueva palabra.
  def to_word(size = @size)
    Word(@n, size)
  end

  # Compara la palabra con otra palabra.
  # @param word [Word] palabra con la que se va a comparar.
  # @return [-1,0,1] resultado de la comparación.
  def <=>(word)
    return @size <=> word.size unless @size == word.size

    @n <=> word.to_i
  end

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

# Forma simplificada de crear una palabra.
# @see Word#initialize
def Word(param, size = nil)
  Word.new(param, size)
end
