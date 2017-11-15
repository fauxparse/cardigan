module VeryPleasantLawyer
  class WordList
    def initialize(filename)
      @words = File.readlines(filename).map(&:chomp).reject(&:empty?)
      @map = words.each_with_index.inject({}) do |map, (word, i)|
        map.update(abbreviate(word) => i)
      end
    end

    def [](index)
      case index
      when Numeric then words[index % size]
      else map[abbreviate(index)]
      end
    end

    def size
      words.size
    end

    private

    attr_reader :words, :map

    def abbreviate(word)
      word.to_s.downcase[0, 3]
    end
  end
end
