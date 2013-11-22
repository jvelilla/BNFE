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
		redefine
			out
		end

	BNFE_ATTRIBUTE [G]
		redefine
			out
		select
			creation_objects_anchor
		end

create
	make_with_objects

feature -- Status Report

	has_side_effects: BOOLEAN
			-- Does Current have side-effects or is Current "Referencially Transparent".
			--	Definition: referential transparency
			--		An expression e is referentially transparent if it is possible to exchange any
			--		subexpression with its value without changing the value of e.
		do
			Result := delta_attributes.count > 0 or
						across sub_commands as ic_commands some ic_commands.item.delta_attributes.count > 0 end or
						across sub_queries as ic_queries some ic_queries.item.has_side_effects  end
		end

	out: like {ANY}.out
			--<Precursor>
		do
			Result := Precursor {BNFE_COMMAND}
			Result.append_character (':')
			Result.append_character (' ')
			if attached {BNFE_FEATURE} result_type as al_type then
				Result.append_string_general (al_type.name)
			elseif attached result_type as al_type and then attached al_type.generating_type as al_generating_type then
				Result.append_string_general (al_generating_type)
			end
		end

invariant
	no_delta_attributes: delta_attributes.count = 0

end
