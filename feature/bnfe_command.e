note
	description: "[
				Representation of a Comand routine feature.

				In the form of:
				1. f
				2. f(a)
					]"
	date: "$Date: $"
	revision: "$Revision: $"

class
	BNFE_COMMAND

inherit
	BNFE_FEATURE
		redefine
			out
		end

create
	make_with_objects

feature -- Access

	delta_attributes: ARRAYED_LIST [BNFE_ATTRIBUTE [ANY]]
			-- List of zero, one, or more attributes changed by Current.
			--| Commonly referred to as the "Framing Problem".
		attribute
			create Result.make (10)
		end

	arguments: ARRAYED_LIST [BNFE_ATTRIBUTE [ANY]]
			-- List of zero, one, or more arguments.
			-- Arguments passed to Current.
		attribute
			create Result.make (10)
		end

	add_argument (a_argument: BNFE_ATTRIBUTE [ANY])
			-- Add `a_argument' to `arguments'.
		do
			arguments.force (a_argument)
		ensure
			has_argument: arguments.has (a_argument)
		end

	sub_commands: ARRAYED_LIST [BNFE_COMMAND]
			-- List of zero, one, or more commands.
			-- Subordinate commands executed by Current.
		attribute
			create Result.make (10)
		end

	sub_queries: ARRAYED_LIST [BNFE_QUERY [ANY]]
			-- List of zero, one, or more queries.
		 	-- Query features used by Current.
		attribute
			create Result.make (10)
		end

feature -- Status Report

	deep_out: like out
			--<Precursor>
		do
			Result := out
		end

	out: like {ANY}.out
			--<Precursor>
		do
			Result := signature
			Result.append_string_general (description_block)
			Result.append_string_general (delta_attributes_block)
			Result.append_string_general (sub_commands_block)
			Result.append_string_general (sub_queries_block)
		end

	description_block: STRING
			-- Block of description(s), if any.
		do
			create Result.make_empty
			if not description.is_empty then
				Result.append_character ('%N')
				Result.append_character ('%T')
				Result.append_character ('%T')
				Result.append_string_general ("-- ")
				Result.append_string_general (description)
			end
		end

	delta_attributes_block: STRING
			-- Block of delta_attributes(s), if any.
		do
			create Result.make_empty
			if delta_attributes.count > 0 then
				Result.append_character ('%N')
				Result.append_string_general ("Delta_attributes")
				across delta_attributes as ic_routines loop
					Result.append_string_general (ic_routines.item.out)
					Result.append_character ('%N')
				end
				Result.append_string_general ("end")
			end
		end

	sub_queries_block: STRING
			-- Block of sub_queries(s), if any.
		do
			create Result.make_empty
			if sub_commands.count > 0 then
				Result.append_character ('%N')
				Result.append_string_general ("Command")
				across sub_commands as ic_routines loop
					Result.append_string_general (ic_routines.item.out)
					Result.append_character ('%N')
				end
				Result.append_string_general ("end")
			end
		end

	sub_commands_block: STRING
			-- Block of sub_commands(s), if any.
		do
			create Result.make_empty
			if sub_queries.count > 0 then
				Result.append_character ('%N')
				Result.append_string_general ("Query")
				across sub_queries as ic_routines loop
					Result.append_string_general (ic_routines.item.out)
					Result.append_character ('%N')
				end
				Result.append_string_general ("end")
			end
		end

	arguments_signature: STRING
			--<Precursor>
		do
			create Result.make_empty
			if arguments.count > 0 then
				Result.append_character (' ')
				Result.append_character ('(')
				across arguments as ic_arguments loop
					Result.append_character ('a')
					Result.append_character ('_')
					Result.append_string_general (ic_arguments.item.name.twin)
					Result.append_character (':')
					Result.append_character (' ')
					if attached {BNFE_FEATURE} ic_arguments.item.result_type as al_type then
						Result.append_string_general (al_type.name.twin)
					elseif attached ic_arguments.item.result_type as al_type and then attached al_type.generating_type as al_generating_type then
						Result.append_string_general (al_generating_type.twin)
					end
					if not ic_arguments.is_last then
						Result.append_character (',')
						Result.append_character (' ')
					end
				end
				Result.append_character (')')
			end
		end

	result_type_signature: STRING
			--<Precursor>
		do
			create Result.make_empty
		end

end
