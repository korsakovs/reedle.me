require 'rubygems'
require 'mongo'

$CONFIG = {
    :url  => 'localhost',
    :port => 27017
}

connection = Mongo::Connection.new($CONFIG[:url], $CONFIG[:port])
db = connection.db("topnews")

countries = db.collection("country")
countries.drop

File.open("../GEO/countries.sql", 'r').each_line do |line|
  country = line.gsub(/(('(\\'|.)*?'))/).map{ |x| x.slice!("\\r"); x.slice!("\\n"); x.chomp("'").reverse.chomp("'").reverse }
  countries.insert({
      :c2 => country[0],
      :code => country[1],
      :name_sub => country[2].downcase,
      :name => country[2],
      :latitude => country[3].to_f,
      :longitude => country[4].to_f,
      :region => country[5].to_i
  });
end

countries.create_index "c2"

###### CITIES

cities = db.collection("cities")
$CITIES = cities
cities.drop

File.open("../GEO/cities.sql", 'r').each_line do |line|

  city = line.gsub(/(('(\\'|.)*?'))/).map{ |x| x.slice!("\\r"); x.slice!("\\n"); x.chomp("'").reverse.chomp("'").reverse }

  if ( city[4].nil? || city[4].length == 0 )
    # I've checked all that lines. Everything in fine. Can swallow
    # puts "Warning! Bad city name in string #{line}"
    # puts "Array: #{city.inspect}"
    next
  end

  if ( ! [
      120134, # Sankt Petersburg
      122986, # Moskau
      125671, # Petrograd
      126566, # Sverdlovsk
      128092, # Sankt-Peterburg
      128634, # Simbirsk
      130766, # Archangelsk
      132123, # Novorossisk
      132322, # Archangel
      130766, # Archangelsk
      133669, # Orjonikidze
      125136, # Togliatti
      137541, # Musa
      138757, # Novorossiisk
      144780, # Cheliabinsk
      145361, # Sakharny
      145569, # Pokrovskaya
      145934, # Moscou
      125751, # Nizhni Novgorod
      124917, # Minsk
      124878, # Birobijan
      146720, # Parma
      148869, # Gorky
      151569, # Novocherkask
      151672, # Kamnya
      126876, # Krasnoarmeyskaya
      152617, # Lermontovskiy
      155604, # Kazanka
      136598, # Vavilon
      156278, # Nahodka
      150237, # Zhukovskogo
      156847, # Andropov
      157025, # Ussuri
      142170, # Ramenskoe
      132740, # Chaika
      158353, # Elektrozavodskoy
      159345, # Soni
      159736, # Kozlovskiy
      160869, # Narodnyy
      160948, # Prechistenskaya
      161394, # Valentina
      161790, # Solnechnogorskiy
      161821, # Tayga
      128158, # Torgovyy
      162962, # Iran
      153767, # Alexandrov
      163080, # Shestakov
      163084, # Izmaylov
      163092, # Almas
      144060, # Olga
      136185, # Rusa
      163499, # Tjumen
      163504, # Charus
      148438, # Medveda
      163555, # Dorozhno
      148138, # Baykal
      164062, # Kopeisk
      164111, # Mozhaisk
      165033, # Pensa
      165156, # Mytishchi
      132309, # Nort
      161228, # Pervomayskiy
      165872, # Gromov
      156729, # Slavyanskaya
      193030, # Posyet
      198479, # Toyohara
      206202 # Chelyabinsk-70
  ].index(city[0].to_i).nil? )
    next
  end

  if ( ! cities.find_one(:country => city[1], :name => city[4], :latitude => city[5].to_f, :longitude => city[6].to_f).nil? )
    next
  end

  if ( city[1] == "RU" )
=begin
    if ( ! cities.find_one(:latitude => city[5].to_f, :longitude => city[6].to_f).nil? )
      # Can skip. All situations checked
      cities.find(:latitude => city[5].to_f, :longitude => city[6].to_f).each { |c|
        puts "#{city[0].to_i}, # #{city[4]}"
        puts "#{c["id"]}, # #{c["name"]}"
        puts "---"
      }
    end
=end
  end

=begin
  if ( city[1] == "US" || city[1] == "CA" )
    if ( ! cities.find_one(:country => city[1], :name => city[4], :region => city[2]).nil? )
      puts "Warning! Same city found! Inserting: #{city.inspect}"

      cities.find(:country => city[1], :name => city[4]).each { |c|
        puts c.inspect
      }
    end
  else
    if ( ! cities.find_one(:country => city[1], :name => city[4]).nil? )
      puts "Warning! Same city found! Inserting: #{city.inspect}"

      cities.find(:country => city[1], :name => city[4]).each { |c|
        puts c.inspect
      }
    end
  end
=end


  cities.insert({
      :id => city[0].to_i,
      :country => city[1],
      :region => city[2],
      :url => city[3],
      :name_sub => city[4].downcase,
      :name => city[4],
      :loc => [city[5].to_f, city[6].to_f],
      :latitude => city[5].to_f,
      :longitude => city[6].to_f
  })
end

cities.create_index "name_sub"
cities.create_index "id"
cities.create_index([["loc", Mongo::GEO2D]])

puts "Loaded"
