# fetch_imslp_data.rb - v1.0
# INOVITEX Team - S6 Genie Info
# Mathieu Paquette <m.paquette@inovitex.com>

require 'json'
require 'net/http'

# file configuration
composer_file = 'composer.csv'
piece_file = 'piece.csv'

url = 'http://imslp.org/api.php?action=query&list=categorymembers&cmlimit=500&format=json'

def fetch_data(url, category_name)
  result = Hash.new
  count = 0
  cmvalue = nil
  uri = URI.parse(url)

  if category_name != nil
    new_query_ar = URI.decode_www_form(uri.query) << ["cmtitle", category_name]
    uri.query = URI.encode_www_form(new_query_ar)
    if category_name.include? '.'
      uri.query = uri.query + '&*'
    end
  end

  begin
    continue = false

    if cmvalue
      new_query_ar = URI.decode_www_form(uri.query) << ["cmcontinue", cmvalue]
      uri.query = URI.encode_www_form(new_query_ar)
    end

    data = Net::HTTP.get_response(uri).body
    json = JSON.parse(data)

    if json['query-continue'] != nil
      continue = true
      cmvalue = json['query-continue']['categorymembers']['cmcontinue']
    end

    json['query']['categorymembers'].each {|key|
      result[count] = key.clone
      count = count + 1
    }
  end while continue == true

  return result
end

composer_data = fetch_data(url, 'Category:Composers')
piece_data = Hash.new

composer_data.each { |key, value|
  composer_page_id = value['pageid']
  #if composer_page_id == 128486   #DEBUG PURPOSE ONLY
    #result = fetch_data(url, 'Category:Bach, Johann Sebastian')
    puts 'Fetching data for: ' + value['title']
    result = fetch_data(url, value['title'])
    if piece_data.has_key?(composer_page_id)
      abort('composer_id already exist')
    else
      piece_data[composer_page_id] = result
    #end
  end                           #DEBUG PURPOSE ONLY
}

# composer file
File.open(composer_file, 'a+') { |file|
  file.write("\"" + "composer_name" + "\"" + ",")
  file.write("\"" + "composer_cat_name" + "\"" + ",")
  file.write("\"" + "composer_page_id" + "\"" + ",")
  file.write("\"" + "composer_ns" + "\"" + "\n")

  composer_data.each { |key, value|
    title = value['title'].gsub("\"", "'")
    file.write("\"" + title.gsub('Category:','') + "\"" + ",")
    file.write("\"" + title + "\"" + ",")
    file.write("\"" + value['pageid'].to_s + "\"" + ",")
    file.write("\"" + value['ns'].to_s + "\"" + "\n")
  }
}

#piece file
File.open(piece_file, 'a+') { |file|
  file.write("\"" + "composer_page_id" + "\"" + ",")
  file.write("\"" + "piece_name" + "\"" + ",")
  file.write("\"" + "piece_fullname" + "\"" + ",")
  file.write("\"" + "piece_page_id" + "\"" + ",")
  file.write("\"" + "piece_ns" + "\"" + "\n")

  piece_data.each { |key, value|
    composer_page_id = key.to_s
    value.each { |key, value|
      title = value['title'].gsub("\"", "'")

      file.write("\"" + composer_page_id + "\"" + ",")
      file.write("\"" + title.gsub(/(\(.*?\))/i,'').strip + "\"" + ",")
      file.write("\"" + title + "\"" + ",")
      file.write("\"" + value['pageid'].to_s + "\"" + ",")
      file.write("\"" + value['ns'].to_s + "\"" + "\n")
    }
  }
}

puts 'finished'