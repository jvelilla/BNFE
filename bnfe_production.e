note
	description: "Summary description for {BNFE_PRODUCTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BNFE_PRODUCTION

inherit
	BNFE_CONSTRUCT

create
	make_with_objects

feature -- Access

	right_side: ARRAYED_LIST [like Current]
			-- Definition: Production
			-- A production is a formal description of the structure of all specimens of a
			--	non-terminal construct. It has the form
			-- Construct =Δ right-side
			-- where right-side describes how to obtain specimens of the Construct.
		attribute
			create Result.make (100)
		end

feature -- Status Report

	is_terminal: BOOLEAN
			-- Is Current "terminal"
			-- 8.2.5 Definition: Terminal, non-terminal, token
			-- Specimens of a terminal construct have no further syntactical structure. Examples include:
			-- 	• Reserved words such as `if' and `Result'.
			-- 	• Manifest constants such as the integer `234'; symbols such as `;' (semicolon) and `+' (plus sign).
			-- 	• Identifiers (used to denote classes, features, entities) such as {LINKED_LIST} and `put'.
			-- The specimens of terminal constructs are called tokens.
		do
			Result := right_side.count = 0
		end

feature {NONE} -- Implementation: Constants

	consists_of_identifier: STRING_32 = "=Δ"
			-- The "consists of" identifier as a string.

end
