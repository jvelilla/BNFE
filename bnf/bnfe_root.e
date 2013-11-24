note
	description: "[
					Representation of a BNF-E Root Object.
					
					NOTE: Convenience class for object structure with NO interesting
							features. This class may ultimately go away.
					]"
	date: "$Date: $"
	revision: "$Revision: $"

class
	BNFE_ROOT

inherit
	BNFE_BASE

create
	make_with_objects

feature -- Access

	productions: ARRAYED_LIST [BNFE_PRODUCTION]
			-- Productions related to Current.
		attribute
			create Result.make (10)
		end

end
