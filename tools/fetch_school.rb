#!/usr/bin/ruby
# encoding: ISO-8859-1

# fetch_school.rb - v1.4
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
#cities = ["East Angus"]

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

    # additionnal info regex
    regexp_add_info_phones = /<tr><th scope="row">Téléphone :<\/th><td class="couleurCellule">(.*?)<\/td><\/tr>[\s]*<tr><th scope="row">Télécopieur&nbsp;:<\/th><td class="couleurCellule">(.*?)<\/td><\/tr>/i
    regexp_add_info_email = /<th>Courriel :<\/th><td><a href='mailto:(.*?)'.*<\/a><\/td>/i
    regexp_add_info_website = /<th>Site web :<\/th>[\s]*<td>[\s]*<a href="javascript:void\(0\);" onclick="popup\('(.*?)'.*>Cliquez Ici<\/a>/i
    #regexp_add_info = /<tr><th scope="row">Type de formation :<\/th><td class="couleurCellule">(.*?)<br><\/td><\/tr>[\s]*<tr><th scope="row">Réseau d'enseignement&nbsp;:<\/th><td class="couleurCellule">(.*?)<\/td><\/tr>[\s]*<tr><th scope="row">Enseignement dispensé :<\/th><td class="couleurCellule">(.*?)<\/td><\/tr>[\s]*<tr><th scope="row">Région administrative&nbsp;:<\/th><td class="couleurCellule">(.*?)<\/td><\/tr>[\s]*<tr><th scope="row">Langue d'enseignement&nbsp;:<\/th><td class="couleurCellule">(.*?)<\/td><\/tr>[\s]*<tr><th scope="row">Code d'organisme :<\/th><td class="couleurCellule">(.*?)<\/td><\/tr>[\s]*<!--<tr><th scope="row">Organisme Responsable :<\/th><td class="couleurCellule">afficherDetailOrganismeMunMun<\/td><\/tr>-->[\s]*<th>Organisme Responsable :<\/th>[\s]*<td><a href=".*" id=".*">(.*?)<\/a><\/td>[\s]*<!--.*-->[\s]*<tr>[\s]*<th>[\s]*Directeur.*[\s]*<\/th>[\s]*<td>[\s]*(.*?)[\s]*<\/td>[\s]*<\/tr>/i
    regexp_add_info_address = /<th align="left"><b>Adresse<\/b><\/th>[\s]*<\/tr>[\s]*<tr>[\s]*<td>(.*?)<\/br>(.*?)&nbsp;&nbsp;(.*?)<\/td>[\s]*<\/tr>/i

    regexp_add_info_formation_type = /<tr><th scope="row">Type de formation :<\/th><td class="couleurCellule">(.*?)<br><\/td><\/tr>/i
    regexp_add_info_network_type = /<tr><th scope="row">Réseau d'enseignement&nbsp;:<\/th><td class="couleurCellule">(.*?)<\/td><\/tr>/i
    regexp_add_info_level = /<tr><th scope="row">Enseignement dispensé :<\/th><td class="couleurCellule">(.*?)<\/td><\/tr>/i
    regexp_add_info_administrative_region = /<tr><th scope="row">Région administrative&nbsp;:<\/th><td class="couleurCellule">(.*?)<\/td><\/tr>/i
    regexp_add_info_language = /<tr><th scope="row">Langue d'enseignement&nbsp;:<\/th><td class="couleurCellule">(.*?)<\/td><\/tr>/i
    regexp_add_info_code = /<tr><th scope="row">Code d'organisme :<\/th><td class="couleurCellule">(.*?)<\/td><\/tr>/i
    regexp_add_schoolboard = regexp = /<!--<tr><th scope="row">Organisme Responsable :<\/th><td class="couleurCellule">afficherDetailOrganismeMunMun<\/td><\/tr>-->[\s]*<th>Organisme Responsable :<\/th>[\s]*<td><a href=".*" id=".*">(.*?)<\/a><\/td>/i
    regexp_add_info_manager = /<tr>[\s]*<th>[\s]*Directeur.*[\s]*<\/th>[\s]*<td>[\s]*(.*?)[\s]*<\/td>[\s]*<\/tr>/i

    # parsing the post page
    regexp = /<td><img src="\/gdunojrecherche\/images\/.*"  title="(.*?)" \/><\/td>
<td>
<a href="(.*?)">(.*?)<\/a><\/td>
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
      # find the additional school information
      uri = URI.parse("https://prod.mels.gouv.qc.ca/gdunojrecherche/" + HTMLEntities.new.decode(school[1]))
      https = Net::HTTP.new(uri.host,uri.port)
      https.use_ssl = true
      req = Net::HTTP::Get.new(uri.request_uri)
      res = https.request(req)
      content = res.body
      school_add_info_phones_result = content.force_encoding('ISO-8859-1').scan(regexp_add_info_phones)
      school_add_info_website_result = content.force_encoding('ISO-8859-1').scan(regexp_add_info_website)
      school_add_info_address_result = content.force_encoding('ISO-8859-1').scan(regexp_add_info_address)
      school_add_info_email_result = content.force_encoding('ISO-8859-1').scan(regexp_add_info_email)

      school_add_info_formation_type = content.force_encoding('ISO-8859-1').scan(regexp_add_info_formation_type)
      school_add_info_network_type = content.force_encoding('ISO-8859-1').scan(regexp_add_info_network_type)
      school_add_info_level = content.force_encoding('ISO-8859-1').scan(regexp_add_info_level)
      school_add_info_administrative_region = content.force_encoding('ISO-8859-1').scan(regexp_add_info_administrative_region)
      school_add_info_language = content.force_encoding('ISO-8859-1').scan(regexp_add_info_language)
      school_add_info_code = content.force_encoding('ISO-8859-1').scan(regexp_add_info_code)
      school_add_info_schoolboard = content.force_encoding('ISO-8859-1').scan(regexp_add_schoolboard)
      school_add_info_manager = content.force_encoding('ISO-8859-1').scan(regexp_add_info_manager)

      school[5] = school_add_info_phones_result[0]
      school[6] = school_add_info_website_result[0]
      school[7] = school_add_info_email_result[0]
      school[8] = school_add_info_address_result[0]

      school[9] = school_add_info_formation_type[0]
      school[10] = school_add_info_network_type[0]
      school[11] = school_add_info_level[0]
      school[12] = school_add_info_administrative_region[0]
      school[13] = school_add_info_language[0]
      school[14] = school_add_info_code[0]
      school[15] = school_add_info_schoolboard[0]
      school[16] = school_add_info_manager[0]

      if school_add_info_formation_type.empty?
        school[9] = {0 => ''}
      end

      if school_add_info_network_type.empty?
        school[10] = {0 => ''}
      end

      if school_add_info_level.empty?
        school[11] = {0 => ''}
      end

      if school_add_info_administrative_region.empty?
        school[12] = {0 => ''}
      end

      if school_add_info_language.empty?
        school[13] = {0 => ''}
      end

      if school_add_info_code.empty?
        school[14] = {0 => ''}
      end

      if school_add_info_schoolboard.empty?
        school[15] = {0 => ''}
      end

      if school_add_info_manager.empty?
        school[16] = {0 => ''}
      end

      # result parsing
      formated_school = HTMLEntities.new.decode(school[2])
      if schools_full.has_key?(formated_school)
        puts formated_school + " already exist in the hash"
      else
        puts formated_school
        schools_full[formated_school] = { "school_type" => school[0].gsub(/&nbsp;/i," ").force_encoding('iso-8859-1').encode('utf-8'),
                                          "city" => HTMLEntities.new.decode(school[3]),
                                          "telephone0" => HTMLEntities.new.decode(school[4]),
                                          "telephone1" => HTMLEntities.new.decode(school[5][0]),
                                          "fax" => HTMLEntities.new.decode(school[5][1]),
                                          "website" => '',
                                          "email" => '',

                                          "formation_type" => HTMLEntities.new.decode(school[9][0].gsub(/<br>/i," ").strip),
                                          "network_type" => HTMLEntities.new.decode(school[10][0]),
                                          "level" => HTMLEntities.new.decode(school[11][0]),
                                          "administrative_region" => HTMLEntities.new.decode(school[12][0]),
                                          "language" => HTMLEntities.new.decode(school[13][0]),
                                          "code" => HTMLEntities.new.decode(school[14][0]),
                                          "schoolboard" => HTMLEntities.new.decode(school[15][0]),
                                          "manager" => HTMLEntities.new.decode(school[16][0]),

                                          "address" => HTMLEntities.new.decode(school[8][0]),
                                          "city_province" => HTMLEntities.new.decode(school[8][1]),
                                          "postal_code" => HTMLEntities.new.decode(school[8][2])
        }





        if !school_add_info_website_result.empty?
          schools_full[formated_school]["website"] = HTMLEntities.new.decode(school[6][0])
        end

        if !school_add_info_email_result.empty?
        schools_full[formated_school]["email"] = HTMLEntities.new.decode(school[7][0])
        end
      end
    }

  else
    print city + " has no result\n"
  end

}

File.open(school_file, 'a+') { |file|

  file.write("\"" + "school_name" + "\"" + ",")
  file.write("\"" + "school_type" + "\"" + ",")
  file.write("\"" + "city" + "\"" + ",")
  file.write("\"" + "telephone0" + "\"" + ",")
  file.write("\"" + "telephone1" + "\"" + ",")
  file.write("\"" + "fax" + "\"" + ",")
  file.write("\"" + "website" + "\"" + ",")
  file.write("\"" + "email" + "\"" + ",")
  file.write("\"" + "formation_type" + "\"" + ",")
  file.write("\"" + "network_type" + "\"" + ",")
  file.write("\"" + "level" + "\"" + ",")
  file.write("\"" + "administrative_region" + "\"" + ",")
  file.write("\"" + "language" + "\"" + ",")
  file.write("\"" + "code" + "\"" + ",")
  file.write("\"" + "schoolboard" + "\"" + ",")
  file.write("\"" + "manager" + "\"" + ",")
  file.write("\"" + "address" + "\"" + ",")
  file.write("\"" + "city_province" + "\"" + ",")
  file.write("\"" + "postal_code" + "\"" + "\n")

  schools_full.each { |key, value|
    file.write("\"" + key + "\"" + ",")
    file.write("\"" + value["school_type"] + "\"" + ",")
    file.write("\"" + value["city"] + "\"" + ",")
    file.write("\"" + value["telephone0"] + "\"" + ",")
    file.write("\"" + value["telephone1"] + "\"" + ",")
    file.write("\"" + value["fax"] + "\"" + ",")
    file.write("\"" + value["website"] + "\"" + ",")
    file.write("\"" + value["email"] + "\"" + ",")
    file.write("\"" + value["formation_type"] + "\"" + ",")
    file.write("\"" + value["network_type"] + "\"" + ",")
    file.write("\"" + value["level"] + "\"" + ",")
    file.write("\"" + value["administrative_region"] + "\"" + ",")
    file.write("\"" + value["language"] + "\"" + ",")
    file.write("\"" + value["code"] + "\"" + ",")
    file.write("\"" + value["schoolboard"] + "\"" + ",")
    file.write("\"" + value["manager"] + "\"" + ",")
    file.write("\"" + value["address"] + "\"" + ",")
    file.write("\"" + value["city_province"] + "\"" + ",")
    file.write("\"" + value["postal_code"] + "\"" + "\n")
  }
}

puts "Script finished!"
