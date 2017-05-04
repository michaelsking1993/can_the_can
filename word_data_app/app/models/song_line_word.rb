class SongLineWord < ApplicationRecord
  belongs_to :inflection
  belongs_to :song_line
end
