require_relative "view"
require_relative "recipe"
require_relative "scrape_letscookfrench_service"

class Controller
  def initialize(cookbook)
    @cookbook = cookbook
    @view = View.new
  end

  # USER ACTIONS

  def list
    display_recipes
  end

  def add
    # 1. Ask user for a name (view)
    name = @view.ask_user_for("name")
    # 2. Ask user for a description (view)
    description = @view.ask_user_for("description")
    # 3. Ask user for prep time (view)
    prep_time = @view.ask_user_for("prep time")
    # 3. Create recipe (model)
    recipe = Recipe.new(name: name, description: description, prep_time: prep_time)
    # 4. Store in cookbook (repo)
    @cookbook.create(recipe)
    # 5. Display
    display_recipes
  end

  def remove
    # 1. Display recipes
    display_recipes
    # 2. Ask user for index (view)
    index = @view.ask_user_for_index
    # 3. Remove from cookbook (repo)
    @cookbook.destroy(index)
    # 4. Display
    display_recipes
  end

  def import
    # 1. Ask user for a keyword
    term = @view.ask_user_for("search")
    # 2. Scrape LetsCookFrench
    results = ScrapeLetscookfrenchService.new(term).call
    # 3. Display results
    @view.display(results)
    # 4. Ask for the recipe to import
    index = @view.ask_user_for_index
    # 5. Add to cookbook
    @cookbook.create(results[index])
    # 6. Display
    display_recipes
  end

  def mark_as_done
    # 1. Display recipes
    display_recipes
    # 2. Ask user for an index (view)
    index = @view.ask_user_for_index
    # 3. Mark as done and save (repo)
    @cookbook.mark_recipe_as_done(index)
    # 4. Display recipes
    display_recipes
  end

  private

  def display_recipes
    # 1. Get recipes (repo)
    recipes = @cookbook.all
    # 2. Display recipes in the terminal (view)
    @view.display(recipes)
  end
end
