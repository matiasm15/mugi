# frozen_string_literal: true

# Clase que representa a los números enteros en Ruby.
class Numeric
  # Transforma el número en Word de 8 bits.
  # @return [Word] instancia del Word que representa al número.
  def to_word
    Word.new(self, 8)
  end
end
