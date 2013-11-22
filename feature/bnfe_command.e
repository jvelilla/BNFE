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

	description: STRING
			-- Process description of Current.
			-- Describes how Current uses `arguments', `commands' and `queries'
			--	to perform its job.
		attribute
			create Result.make_empty
		end

feature -- Status Report

	out: like {ANY}.out
			--<Precursor>
		do
			Result := name.twin
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
						Result.append_string_general (al_type.name)
					elseif attached ic_arguments.item.result_type as al_type and then attached al_type.generating_type as al_generating_type then
						Result.append_string_general (al_generating_type)
					end
					if not ic_arguments.is_last then
						Result.append_character (',')
						Result.append_character (' ')
					end
				end
				Result.append_character (')')
			end
		end

end
