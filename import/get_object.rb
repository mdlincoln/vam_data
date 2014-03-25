require "open-uri"
require "json"

# Return a MongoDB-ready hash from a V&A url
def get_object_hash(url)
	raw_data = get_json(url)
	if raw_data.nil?
		return {"_id" => url, "download_error" => true}
	else
		return fix_fields(raw_data)
	end
end

# Retrieve and parse V&A JSON into a hash
def get_json(url)
	begin
		object = open(url, :read_timeout => 60)
	rescue Errno::ETIMEDOUT
		return nil
	rescue OpenURI::HTTPError
		return nil
	end
	return JSON.parse(object.read, :symbolize_names => true)
end

# Fix up the raw hash provided by the V&A
def fix_fields(raw_data)
	object_data = raw_data.first[:fields]
	object_data["_id"] = object_data.delete(:object_number)
	return object_data
end