require "mongo"

def resume_at(collection)
	items_downloaded = collection.count
	case items_downloaded
	when nil
		return 0
	else
		return items_downloaded + 1
	end
end
