class Inflection < ApplicationRecord
  belongs_to :base_word, optional: true
  enum word_form: [:verb, :adjective, :noun, :adverb, :gerund] # or {verb: 3, adjective: 1, noun: 2, gerund: 4 }
end
