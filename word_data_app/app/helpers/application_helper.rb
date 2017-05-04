module ApplicationHelper
  require 'csv'

  #TODO: find bws without any inflections (helper.give_inflections)
  #TODO: find inflections without any bw (helper.inflections_without_bw)
  #TODO: fill in missing pos tags by checking for what tags should be there (helper.fill_in_missing_pos_tags)
  #TODO: STOP BEING AN IDIOT




  def add_mappings_from_lempos
    #V = verb, N = noun, A = adjective, C = conjunction, L  = interjection, M = number, P = personal (pronoun?), S = possessive, Y = preposition, Q = quantifier, W = se, K = unknown
    #G = phrase
    # ["art", "nf", "adj", "v", "interj", "nm", "prep", "pron", "num", "adv", "nm/f", "nc", "conj", "nmf", "n"]
    #
    es_lempos = "/Users/michael/Desktop/language_files/martin/martin_lem_pos/es_lemPOS.csv"

    bw_obj = ''
    last_bw = ''
    CSV.foreach(es_lempos) do |row|
      next if row[1] == 'lemma'
      temp_pos = row[3].split('')[0]
      next if temp_pos == 'G'
      next if row[1] == row[2]
      if row[1] == ('yo' || 'mío' || 'el')
        Inflection.create!(word: row[2], pos_tag: row[3], base_word_id: nil)
        next
      end
      if row[1] == last_bw
        bw_obj.inflections.create!(word: row[2], pos_tag: row[3])
      else
        bw_obj = BaseWord.find_or_create_by(base_word: row[1], temp_pos: row[3].split('')[0])
        last_bw = row[1]
        bw_obj.inflections.create!(word: row[2], pos_tag: row[3])
      end
    end
  end



  def add_lexiconista_es_lemmas
    lemmas = "/Users/michael/desktop/language_files/lexiconista_lemmas/lemmatization-es_2.txt"
    bw_obj = ''
    last_bw = ''
    File.readlines(lemmas).each do |columns|
      row = columns.split(' ')
      if row[0] == last_bw
        bw_obj.inflections.create!(word: row[1])
      else
        bw_obj = BaseWord.create!(base_word: row[0])
        last_bw = row[0]
        bw_obj.inflections.create!(word: row[1])
      end
    end
  end





  def update_bw(masculine_bw, feminine_bw)

    masc_bw = BaseWord.find_by(base_word: masculine_bw)
    fem_bw = BaseWord.find_by(base_word: feminine_bw)
    fem_bw.inflections.each do |inflection|
      inflection.update! base_word_id: masc_bw.id
    end
    if masc_bw.inflections.pluck(:word).include?(feminine_bw)
      fem_bw.destroy
    else
      masc_bw.inflections.create! word: feminine_bw
      fem_bw.destroy
    end
    masc_bw.update! temp_pos: 'nm-f'
  end

  def find_the_matching_stems
    #task: find all the words that have a base word counterpart whose only difference is a letter change at the end
    #steps:
    #split each
    unique_bws = BaseWord.all.pluck(:base_word).uniq
    stem_arrs = unique_bws.map {|bw| bw.split('')[0..-2]}
    double = []
    avoid = ["ella", "casa", "cuenta", "puerta", "cara", "cerca", "política", "música", "izquierda", "plaza", "llamada", "carga", "derecha", "lista", "costa", "rama", "partida", "moda", "técnica", "característica", "suma", "plata", "crítica", "marca", "punta", "firma", "fila", "caída", "fruta", "alternativa", "lógica", "reina", "banda", "pata", "vela", "media", "herida", "roca", "presa", "papa", "barra", "bota", "crónica", "seguida", "tinta", "negativa", "junta", "raya", "matemática", "manga", "seda", "estadística", "rata", "trama", "parada", "cubierta", "ética", "coma", "pasta", "cuadra", "retirada", "gira", "mecánica", "clínica", "manta", "tira", "falla", "dinámica", "sobra", "dicha", "acta", "cera", "pala", "estética", "acera", "libra"]
    unique_bws.each do |bw|
      next if avoid.include?(bw)
      next if bw.split('').count < 3
      next if bw.split('')[-1] != ('a' || 'o')
      double.push(bw) if stem_arrs.count(bw.split('')[0..-2]) > 1
    end
    return double
    #double.each do |bw|
     # masc_bw = bw.sub(/a\Z/, 'o')
     # update_bw(masc_bw, bw)
    #end
  end

  def fix_ser
    require 'csv'
    es_lempos = "/Users/michael/Desktop/language_files/martin/martin_lem_pos/es_lemPOS.csv"
    poder = BaseWord.find_by(base_word: 'saber', temp_pos: 'v')
    CSV.foreach(es_lempos) do |row|
      if row[1] == 'saber' && row[3].split('')[0] == 'V'
        poder.inflections.create! word: row[2], pos_tag: row[3]
      end
    end
  end

    #1) next if bw.split('').length == (1 || 2)stem all bws
    #2) stem the BW
    #3) bws = BaseWord.where("base_word LIKE ?", "stemmed_version%").pluck(:base_word)
    #4) next if bws.count == 1
    #5) unique_bws = []
    #6) bws.each do |bw|
    #7)   unique_bws.include?(bw) ? next : unique_bws.push(bw)
    #8) end
    #9) bws_to_change.push(unique_bws) if unique_bws.count > 1

  def bws_without_inflections
    bws_without_inflections = []
    BaseWord.all.each do |bw|
      bw.inflections.empty? ? bws_without_inflections.push(bw) : next
    end
    return bws_without_inflections
  end

  def give_inflections
    bws = bws_without_inflections
    bws.each do |bw|
      puts bw.base_word + ', ' + bw.temp_pos
      puts BaseWord.find(Inflection.where(word: bw).first.base_word_id).inflections.pluck(:word) if !Inflection.where(word: bw).empty?
      inflections = gets
      if inflections.strip.empty?
        next
      else
        inflections.strip.split(' ').each do |inflection|
          cleaned_word = inflection.sub(/[[:punct:]]/, '')
          bw.inflections.create! word: cleaned_word
        end
      end
    end
  end

  def add_given_inflection_pos
    es_lempos = "/Users/michael/Desktop/language_files/martin/martin_lem_pos/es_lemPOS.csv"
    Inflection
  end



  def inflections_without_bw
    missing = Inflection.where(base_word_id: nil)
    debugger
    missing.each do |inflection|
      puts inflection.word + ', ' + inflection.pos_tag
      base_word = gets
      if base_word.empty?
        next
      else
        bw = base_word.split(' ')[0]
        pos = base_word.split(' ')[1]
        bw_id = BaseWord.find_by(base_word: bw, temp_pos: pos).id
        inflection.update! base_word_id: bw_id
      end
    end
  end


  #to fill in: subj 1/3 sing pres imp 1, subj 1 plur pres imp 1 plur, subj 1/3 imp 1, person past(2), subj
  def fill_in_missing_pos_tags
    require 'csv'
    missing_bw = bws_without_inflections
    bws = missing_bw.pluck(:base_word)
    es_lempos = "/Users/michael/Desktop/language_files/martin/martin_lem_pos/es_lemPOS.csv"
    CSV.foreach(es_lempos) do |row|
      next if row[3].split('')[0] == 'G'
      if empty_infs.include?([row[2], row[1]])
        Inflection.where(word: row[2]).where(pos_tag: nil).first.update! temp_pos: row[3]
      end
    end
  end


=begin
    empty_infs = Inflection.where(pos_tag: nil).map {|inf| [inf.word, inf.base_word.base_word]}
    end
    es_lempos = "/Users/michael/Desktop/language_files/martin/martin_lem_pos/es_lemPOS.csv"
    CSV.foreach(es_lempos) do |row|
      next if row[3].split('')[0] == 'G'
      if empty_infs.include?([row[2], row[1]])
        Inflection.where(word: row[2]).where(pos_tag: nil).first.update! temp_pos: row[3]
      end
    end
=end


    #for verbs, just check against the inflection_hashes
    #step 1: match up the inflection_hash headers with appropriate meaningcloud POS tags
    #step 2: For each verb, convert the inflection_hash to an array of key-value pairs (string: tag), and print it to a CSV where row[0] is the base_verb itself
    #step 3: For each row, find the base_word by the base_word and temp_pos = 'v'. Then, iterate over the row and search for each key(word). If the word isn't there, create a new inflection with it and the pos tag. If it is, check if the value(pos_tag) is there, and put it there if it isn't, with a comma after the first value if there's already one there
    #missing tags: VS-S(1/3)I, VS-S(1/3)P


  def add_davies_bws
    davies = "/Users/michael/langify/lib/tasks/word_data/top_5000.csv"
    CSV.foreach(davies) do |row|
      if row[0] == 'Rank'
        next
      elsif row[1] == 'el, la'
        BaseWord.find_or_create_by!(language_id: 1, base_word: 'el', temp_pos: 'art')
      else
        BaseWord.find_or_create_by!(language_id: 1, base_word: row[1], temp_pos: row[2])
      end
    end
  end


  # yo, tú, él[ella], nosotros[nosotras], vosotros[vosotras], ellos[ellas], el[la, los, las], lo[la,los,las], su[sus], suyo[suya, suyos, suyas], tuyo[tuya, tuyos, tuyas], mío[mía, míos, mías], mi[mis], tu[tus], su[sus], nuestro[nuestros/nuestra/nuestras], vuestro[vuestra/vuestros/vuestras]
  # yo, tú, él, ella, ello(s), ella(s), vosotros/as, nosotros/as, el, la(s), lo(s)



  #tags

  def add_the_matching_subjunctives

  end

  def find_missing_stuff
    #indicative: present(6), preterite(6), imperfect(5/6), future(6)
    #subjunctive:
    #imperative:
    #gerund: 1
    #participle: 1

    #nouns: check for either 3 or 1 inflection.
    #adjectives: check for 3 or 1 inflections
    #pronouns: add

    verb_tag_beginnings = ['VI-S1P1', 'VI-S1P2', 'VI-S1P3', 'VI-P1P1', 'VI-P1P2', 'VI-P1P3']


    if BaseWord.count != 4993
      return "there are not the expected number of base words!"
    end

    verbs = BaseWord.where(temp_pos: 'v')

  end

  def find_self_mappings
    es_lempos = "/Users/michael/Desktop/language_files/martin/martin_lem_pos/es_lemPOS.csv"
    unique_words = []
    doubled_words = []
    self_mappings = []
    CSV.foreach(es_lempos) do |row|
      next if row[3].split('')[0] == 'G'
      self_mappings.push(row) if row[1] == row[2]
      unique_words.include?(row[2]) ? doubled_words.push(row[2]) : unique_words.push(row[2])
    end
    return self_mappings
  end

=begin
      pronoun_indicator = row[3].split('')[1]
      temp_pos = 'v' if pos_indicator == 'V'
      temp_pos = 'pron' if ((pos_indicator == 'Q' || 'R' || 'D' || 'I' || 'M' || 'P' || 'S' || 'T') && pronoun_indicator == 'P')
      temp_pos = 'adj' if pos_indicator == 'A'
      temp_pos = 'art' if pos_indicator == 'T'
      temp_pos = 'prep' if pos_indicator == 'Y'
      temp_pos = 'conj' if pos_indicator == 'C'
      if pos_indicator == 'N'
        gender_indicator = row[3].split('')[2]
        temp_pos = 'nf' if gender_indicator == 'F'
        temp_pos = 'nm' if gender_indicator == 'M'
        temp_pos = 'nc' if gender_indicator == 'U'
        bw = BaseWord.find_by(base_word: row[1], temp_pos: temp_pos)
        bw = BaseWord.find_by(base_word: row[1], temp_pos: 'nm/f') if bw.nil?
        bw = BaseWord.find_by(base_word: row[1], temp_pos: 'nmf') if bw.nil?
        bw = BaseWord.find_or_create_by(base_word: row[1], temp_pos: temp_pos, language_id: 1) if bw.nil?
      end
      bw = BaseWord.find_or_create_by(base_word: row[1], temp_pos: temp_pos, language_id: 1)
      bw.inflections.find_or_create_by(word: row[2], pos_tag: row[3])
=end
  def check_for_dupes
    duped_bw = []
    unique_bw = []
    BaseWord.where("temp_pos LIKE ?", "n%").where.not(temp_pos: 'num').each do |bw|

    end
  end


##TODO: FIND ALL INTERJECTIONS AND MAP THEM APPROPRIATELY
#TODO: find all spanish nouns with masculinity and femininity
#


  def count_danger_dave_faults
    #danger_dave_es = '/Users/michael/Desktop/language_files/danger_dave_inflection_freqs/content/2016/es/es_full.txt'
    #bw_count = File.new('./bw_count.txt')
    #not_found_count = File.new('./not_found_count.txt')
    File.readlines(danger_dave_es).each do |word_n_freq|
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
end
