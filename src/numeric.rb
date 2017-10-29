# frozen_string_literal: true

# Clase que representa a los números en Ruby.
class Numeric
  # Transforma el número en Word.
  # @param size [Numeric] tamaño del Word.
  # @return [Word] instancia del Word que representa al número.
  def to_word(size = nil)
    Word.new(self, size)
  end
end
