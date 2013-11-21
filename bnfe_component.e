note
	description: "Summary description for {BNFE_COMPONENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BNFE_COMPONENT

inherit
	BNFE_ROOT

create
	make_with_objects

feature -- Access

	features: ARRAYED_LIST [BNFE_FEATURE]
			-- List of zero, one, or more features of Current.
		attribute
			create Result.make (10)
		end

end
