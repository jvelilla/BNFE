note
	description: "[
					Abstract notion of a Feature: f
					
								F
							   / \
							  A   R
							     / \
							    C   Q
							    
					Where:
					F = Feature
					A = Attribute (f --> r)
					R = Routine
					C = Command (f or f(a))
				 	Q = Query (f --> r or f(a) --> r)

					]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	BNFE_FEATURE

inherit
	BNFE_BASE
		redefine
			out
		end

feature -- Access

	description: STRING
			-- Process description of Current.
			-- Describes how Current uses `arguments', `commands' and `queries'
			--	to perform its job.
		attribute
			create Result.make_empty
		end

feature -- Settings

	set_description (a_description: like description)
			-- Set `description' with `a_description'.
		do
			description := a_description
		ensure
			description_set: description.same_string (a_description)
		end

feature -- Status Report

	out: like {ANY}.out
			--<Precursor>
		do
			Result := signature
		end

	signature: STRING
			-- Signature of Current.
		do
			Result := name.twin
			Result.append_string_general (arguments_signature)
		end

	arguments_signature: STRING
			-- Arguments of Current (if any).
		deferred
		end

	result_type_signature: STRING
			-- Result type of Current (if any).
		deferred
		end

end
