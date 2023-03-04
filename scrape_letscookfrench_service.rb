require "open-uri"
require "nokogiri"
require_relative "recipe"

class ScrapeLetsCookFrenchService
  def initialize(ingredient)
    @ingredient = ingredient
  end

  def call
    html = open("http://www.letscookfrench.com/recipes/find-recipe.aspx?aqt=#{@ingredient}").read
    # 1. Parse HTML
    doc = Nokogiri::HTML.parse(html, nil, "utf-8")
    # 2. For the first five results
    results = []
    doc.search(".recette_classique").first(5).each do |element|
      # 3. Create recipe and store it in results
      name = element.search('.m_titre_resultat a').text.strip
      description = element.search('.m_texte_resultat').text.strip
      prep_time = element.search('.m_prep_time').first.parent.text.strip
      results << Recipe.new(name: name, description: description, prep_time: prep_time)
    end
    return results
  end
end
