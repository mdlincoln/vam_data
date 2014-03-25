######
#
# Retrieves all object records from the V&A API and stores
# them as documents in a MongoDB instance.
#
######

require "open-uri"
require "mongo"
require "parallel"
require "ruby-progressbar"
load "import/get_object.rb"
load "import/resume_at.rb"

# Connect to the database
coll = Mongo::MongoClient.new['va']['objects']
start = resume_at(coll)
puts "Starting at O#{start}"
total_records = 1290000

obj_numbers = (start...total_records)

prog_bar = ProgressBar.create(:title => "Files imported", :starting_at => start, :total => total_records, :format => '%c |%b>>%i| %p%% %e')	# => Create a progress bar

# Download files in parallel
Parallel.map_with_index(obj_numbers, :in_process => 8, :finish => lambda { |item, i, result| prog_bar.increment }) do |num|
	url = "http://www.vam.ac.uk/api/json/museumobject/O#{num}"
	coll.insert(get_object_hash(url))
end
