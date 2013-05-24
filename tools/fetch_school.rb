#!/usr/bin/ruby
# encoding: ISO-8859-1

# fetch_school.rb v1.0
# INOVITEX Team - S6 Genie Info
# Mathieu Paquette <m.paquette@inovitex.com>

require 'net/http'
require 'net/https'
require 'htmlentities'

school_file = "eastern_schools.csv"

schools_full = Hash.new

# http://www.mamrot.gouv.qc.ca/repertoire-des-municipalites/fiche/region/05/
cities = [
          "Asbestos",
          "Ascot Corner",
          "Audet",
          "Austin",
          "Ayer's Cliff",
          "Barnston-Ouest",
          "Bolton-Est",
          "Bonsecours",
          "Bury",
          "Chartierville",
          "Cleveland",
          "Coaticook",
          "Compton",
          "Cookshire-Eaton",
          "Courcelles",
          "Danville",
          "Dixville",
          "Dudswell",
          "East Angus",
          "East Hereford",
          "Eastman",
          "Frontenac",
          "Ham-Sud",
          "Hampden",
          "Hatley",
          "Hatley",
          "Kingsbury",
          "La Patrie",
          "Lac-Drolet",
          "Lac-Mégantic",
          "Lambton",
          "Lawrenceville",
          "Lingwick",
          "Magog",
          "Maricourt",
          "Marston",
          "Martinville",
          "Melbourne",
          "Milan",
          "Nantes",
          "Newport",
          "North Hatley",
          "Notre-Dame-des-Bois",
          "Ogden",
          "Orford",
          "Piopolis",
          "Potton",
          "Racine",
          "Richmond",
          "Saint-Adrien",
          "Saint-Augustin-de-Woburn",
          "Saint-Benoît-du-Lac",
          "Saint-Camille",
          "Saint-Claude",
          "Saint-Denis-de-Brompton",
          "Saint-Étienne-de-Bolton",
          "Saint-François-Xavier-de-Brompton",
          "Saint-Georges-de-Windsor",
          "Saint-Herménégilde",
          "Saint-Isidore-de-Clifton",
          "Saint-Ludger",
          "Saint-Malo",
          "Saint-Robert-Bellarmin",
          "Saint-Romain",
          "Saint-Sébastien",
          "Saint-Venant-de-Paquette",
          "Sainte-Anne-de-la-Rochelle",
          "Sainte-Catherine-de-Hatley",
          "Sainte-Cécile-de-Whitton",
          "Sainte-Edwidge-de-Clifton",
          "Scotstown",
          "Sherbrooke",
          "Stanstead",
          "Stanstead",
          "Stanstead-Est",
          "Stoke",
          "Stornoway",
          "Stratford",
          "Stukely-Sud",
          "Ulverton",
          "Val-Joli",
          "Val-Racine",
          "Valcourt",
          "Valcourt",
          "Waterville",
          "Weedon",
          "Westbury",
          "Windsor",
          "Wotton"
]

#cities = ["Danville", "Danville", "Asbestos", "Austin"]
#cities = ["Danville"]

cities.each { |city|

  print city + "\n"

  # get the session id required for the post request
  uri = URI.parse("https://prod.mels.gouv.qc.ca/gdunojrecherche/rechercheOrganisme.do?methode=rechercheMun&typeRecherche=mun")
  https = Net::HTTP.new(uri.host,uri.port)
  https.use_ssl = true
  req = Net::HTTP::Get.new(uri.request_uri)
  res = https.request(req)
  content = res.body

  regexp = /<form name="rechercheOrganismeForm" method="post" action="(.*?)" autocomplete="off">/i
  result = content.scan(regexp)
  uri_path = result[0][0]

  # post request here
  uri = URI.parse("https://prod.mels.gouv.qc.ca" + uri_path)
  https = Net::HTTP.new(uri.host,uri.port)
  https.use_ssl = true
  req = Net::HTTP::Post.new(uri.request_uri)

  req.set_form_data({'codeProcodeProgrammeProfessionnelInstallation' => '',
                     'nomProgrammeAutoriseFlag' => '',
                     'nomMunicipalite' => city,
                     'codeOrdreEnseignementAppartenance' => 'enseignmtALL',
                     'nouveauFormulaire' => 'true'})

  res = https.request(req)
  content = res.body

  # find the number of organization in the current post request
  regexp = /<td width="20%">&nbsp;<strong>(.*?)<\/strong>&nbsp;Organisme\(s\)<\/td>/i
  result = content.scan(regexp)

  if !result.empty?
    nb_organization = result[0][0].to_f

    # display 10 result per page
    nb_iteration = ((nb_organization / 10.0) + 0.4).round

    # parsing the post page
    regexp = /<a href="rechercheOrganisme.do;jsessionid=[^>]*>(.*?)<\/a><\/td>
<td[^>]*>(.*?)<\/td>
<td[^>]*>(.*?)<\/td>/i
    school_result = content.scan(regexp)

    # get the other result
    for i in 2..nb_iteration
      print city + ":#{i}\n"
      uri = URI.parse("https://prod.mels.gouv.qc.ca" + uri_path.slice(0..(uri_path.index('?'))) +"listeId=listeOrganisme&d-20335-tri=Nom_code&d-20335-o=2&d-20335-p=#{i}&methode=naviguerResultatOrganisme")
      https = Net::HTTP.new(uri.host,uri.port)
      https.use_ssl = true
      req = Net::HTTP::Get.new(uri.request_uri)
      res = https.request(req)
      content = res.body
      school_result += content.scan(regexp)
    end

    school_result.each { |school|
      formated_school = HTMLEntities.new.decode(school[0])
      if schools_full.has_key?(formated_school)
        puts formated_school + " already exist in the hash"
      else
        schools_full[formated_school] = { "city" => HTMLEntities.new.decode(school[1]), "telephone" => HTMLEntities.new.decode(school[2]) }
      end
    }

  else
    print city + " has no result\n"
  end

}

File.open(school_file, 'a+') { |file|

  schools_full.each { |key, value|
    file.write(key + ",")
    file.write(value["city"] + ",")
    file.write(value["telephone"] + "\n")
  }
}

puts "Script finished!"