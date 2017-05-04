require 'csv'
=begin
f = File.new("/Users/michael/test_apps/word_data_app/word_data/davies_5000_bw.txt", "w")
davies = File.open("/Users/michael/Desktop/word_files/unlicensed_freq_lists/top_5000.csv")
CSV.foreach(davies) do |row|
  if row[1].split(' ').count > 1
    row[1].split(' ').each do |article|
      f.puts article
    end
    next
  end
  f.puts row[1]
end
f.close
=end
=begin
davies_bws = File.open("/Users/michael/test_apps/word_data_app/word_data/davies_5000_bw.txt", "r")
davies_bws.each_line do |line|
  puts line
end
=end

=begin
davies_bws = "/Users/michael/test_apps/word_data_app/word_data/davies_5000_bw.txt"
File.readlines(davies_bws).each do |line|
  puts line
end
=end
=begin
lemmas = "/Users/michael/desktop/language_files/lexiconista_lemmas/lemmatization-es.txt"
File.readlines(lemmas).each do |line|
  puts $.
end
=end

def count_danger_dave_faults
  danger_dave_es = '/Users/michael/Desktop/language_files/danger_dave_inflection_freqs/content/2016/es/es_full.txt'
  bw_count = File.new('./bw_count.txt', 'w+')
  not_found_count = File.new('./not_found_count.txt', 'w+')
  File.readlines(danger_dave_es).each do |word_n_freq|
    if $. == 100
      break
    end
    word_n_freq_arr = word_n_freq.split(' ')
    word = word_n_freq_arr[0]
    hit_count = word_n_freq_arr[1]
    bw_exists = BaseWord.find_by(base_word: word)
    # headers for bw_count file: base_word, hit_count, (inflection), base_word_id
    # headers for not_found_count file: inflection, hit_count
    if bw_exists
      bw_count.puts word + ' ' + hit_count + ' ' + '(' + word + ')' + ' ' + bw_exists.id
    else
      inflection_exists = Inflection.find_by(word: word)
      if inflection_exists
        bw_id = inflection_exists.base_word_id
        bw = BaseWord.find(bw_id).base_word
        bw_count.puts base_word + ' ' + hit_count + ' ' + '(' + word + ')' + ' ' + bw_id
      else
        not_found_count.puts word + ' ' + hit_count
      end
    end
  end
end


