note
	description: "[
				Representation of an Attribute feature.

				In the form of:
				1. f --> r
					]"
	date: "$Date: $"
	revision: "$Revision: $"

class
	BNFE_ATTRIBUTE [G]

inherit
	BNFE_FEATURE
		redefine
			make_with_objects,
			creation_objects_anchor
		end

create
	make_with_objects

feature {NONE} -- Initialization

	make_with_objects (a_objects: attached like creation_objects_anchor)
			--<Precursor>
		do
			Precursor (a_objects)
			result_type := a_objects.result_type
		end

feature {NONE} -- Implementation: Creation Objects

	creation_objects_anchor: detachable TUPLE [name: like name; result_type: like result_type]
			-- Creation objects anchor for Current

feature -- Access

	result_type: G
			-- Result type of Current.

feature -- Settings

	set_result_type (a_result_type: attached like result_type)
			-- Set `result_type' with `a_result_type'.
		do
			result_type := a_result_type
		end

end
