note
	description: "[
				Representation of a Query routine feature.
				
				In the form of:
				1. f --> r
				2. f(a) --> r
					]"
	date: "$Date: $"
	revision: "$Revision: $"

class
	BNFE_QUERY [G]

inherit
	BNFE_COMMAND
		rename
			creation_objects_anchor as command_creation_objects_anchor
		undefine
			make_with_objects
		end

	BNFE_ATTRIBUTE [G]
		select
			creation_objects_anchor
		end

create
	make_with_objects

invariant
	no_delta_attributes: delta_attributes.count = 0

end
