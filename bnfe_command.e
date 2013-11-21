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
		attribute
			create Result.make (10)
		end

	sub_commands: ARRAYED_LIST [BNFE_COMMAND]
			-- List of zero, one, or more commands.
		attribute
			create Result.make (10)
		end

	sub_queries: ARRAYED_LIST [BNFE_QUERY [ANY]]
			-- List of zero, one, or more queries.
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

end
