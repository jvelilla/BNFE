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
			creation_objects_anchor,
			out
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

feature -- Status Report

	out: like {ANY}.out
			--<Precursor>
		do
			Result := signature
			Result.append_string_general (result_type_signature)
		end

	arguments_signature: STRING
			--<Precursor>
		do
			create Result.make_empty
		end

	result_type_signature: STRING
			--<Precursor>
		do
			create Result.make_empty
			Result.append_character (':')
			Result.append_character (' ')
			if attached {BNFE_FEATURE} result_type as al_type then
				Result.append_string_general (al_type.name)
			elseif attached result_type as al_type and then attached al_type.generating_type as al_generating_type then
				Result.append_string_general (al_generating_type)
			end
		end

end
