require_relative './word_list'

module VeryPleasantLawyer
  class Lawyer
    def number_to_words(number, word_count = 3)
      lists = [adjectives] * (word_count - 1) + [nouns]

      lists
      .each
      .with_index(1)
      .inject([[], number - 1]) do |(words, n), (list, i)|
        [words << list[n], n + (number - 1) / word_list_size ** i]
      end.first.join(' ')
    end

    def words_to_number(text)
      words = text.strip.downcase.gsub(/[_\s]+/, ' ').split
      lists = [adjectives] * (words.size - 1) + [nouns]
      indices = words.zip(lists).map { |word, list| list[word] }

      indices
      .each_cons(2)
      .with_index(1)
      .inject(indices.first + 1) do |total, ((first, second), i)|
        interim = (second - first + word_list_size) % word_list_size
        total + interim * word_list_size ** i
      end
    end

    private

    def word_list_size
      @word_list_size ||= adjectives.size
    end

    def adjectives
      @adjectives ||= word_list('adjectives')
    end

    def nouns
      @nouns ||= word_list('nouns')
    end

    def word_list(list)
      WordList.new(File.join(File.dirname(__FILE__), "#{list}.txt"))
    end
  end
end
