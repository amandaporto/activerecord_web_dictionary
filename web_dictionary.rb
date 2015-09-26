require 'sinatra'
require 'active_record'
require 'sinatra/reloader' if development?

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: File.dirname(__FILE__) + "/webdictionary.db"
)

Tilt.register Tilt::ERBTemplate, "html.erb"

class Definition < ActiveRecord::Base
  validates :word, presence: true
  validates :meaning, presence: true
end


get "/" do
  erb :display
end

get "/add" do
  erb :add
end

post "/save" do
  word = params["word"]
  definition = params["definition"]
  new_word = Definition.create(word: word, meaning: definition).valid?

  if new_word.valid? == true
    redirect to ("/")
  else
    redirect to ("/error")
  end

  erb :save
end

get "/error" do
  erb :error
end

post "/search" do
  search_results = Definition.find_by(word: params["to_search"])
  @definitions_found = "#{search_results.word} - #{search_results.meaning}"

  erb :search
end
