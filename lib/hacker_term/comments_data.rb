require 'json'
require 'cgi'

module HackerTerm
  class CommentsData
    attr_reader :data

    def initialize(data)
      unescaped = CGI.unescapeHTML data
      @data = JSON.parse(unescaped)['items']
    end

    def data_as_text(max_width)
      @data.each do |line|
        # Split lines into words
        words = line['comment'].split ' '
        fit_words_to_width(words, max_width)
      end
    end

    def fit_words_to_width(arr_words, max_width)
      new_lines = []
      char_counter = 0

      arr_words.each do |w|
        # If we see that a line is going to end up too long, add a newline
        char_counter += w.length + 1 # +1 for the space
        
        if char_counter > max_width
          new_lines << "\n" + w + ' '
          char_counter = 0
        else
          new_lines << w + ' '
        end
      end

      new_lines.join
    end
  end
end