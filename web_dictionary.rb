require 'sinatra'
require 'sinatra/reloader' if development?

Tilt.register Tilt::ERBTemplate, "html.erb"


get "/" do
  if File.exist?("data.yml")
    @dictionary = YAML::load(File.read("data.yml"))
  else
    @dictionary = []
  end

  erb :display
end

get "/add" do
  erb :add
end

post "/save" do

  if File.exist?("data.yml")
    @dictionary = YAML::load(File.read("data.yml"))
  else
    @dictionary = []
  end
  word = params["word"]
  definition = params["definition"]
  new_word = {word: word, definition: definition}
  @dictionary << new_word
  File.write("data.yml", @dictionary.to_yaml)

  status 302
  header["Location"] = "/"
  erb :save
end

post "/search" do
  if File.exist?("data.yml")
    @dictionary = YAML::load(File.read("data.yml"))
  else
    @dictionary = []
  end

  @search_results = @dictionary.select { |hash| hash[:word] == params["to_search"] }

  erb :search
end
