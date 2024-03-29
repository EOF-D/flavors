require 'json'

data = JSON.parse(File.read("#{__dir__}/raw/recipes.json"))

# Seed the recipes table
data.each do |entry|
  recipe = Recipe.create!(
    id: entry['id'],
    url: entry['url'],
    name: entry['name'],
    author: entry['author'],
    ratings: entry['ratings'],
    description: entry['description'],
    serves: entry['serves'],
    difficult: entry['difficult']
  )

  # Seed the ingredients for each recipe
  entry['ingredients'].each do |ingredient|
    recipe.ingredients.create!(
      name: ingredient['name'],
      quantity: ingredient['quantity'],
      unit: ingredient['unit'],
      preparation: ingredient['preparation']
    )
  end

  # Seed the steps for each recipe
  entry['steps'].each_with_index do |step_text, index|
    recipe.steps.create!(
      step_number: index + 1,
      step_text: step_text
    )
  end

  # Seed the times for each recipe
  times = RecipeTime.new(
    preparation: entry['times']['Preparation'],
    cooking: entry['times']['Cooking']
  )

  recipe.recipe_time = times
end
