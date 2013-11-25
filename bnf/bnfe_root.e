note
	description: "[
					Representation of a BNF-E Root Object.
					
					A BNF-E Root is a specification containing subordinate productions.
					
					NOTE: Convenience class for object structure with NO interesting
							features. This class may ultimately go away.
					]"
	date: "$Date: $"
	revision: "$Revision: $"

class
	BNFE_ROOT

inherit
	BNFE_BASE
		rename
			items as productions,
			items_anchor as production_anchor
		redefine
			production_anchor
		end

create
	make_with_objects

feature -- Access

	productions: ARRAYED_LIST [attached like production_anchor]
			-- Productions related to Current.
		attribute
			create Result.make (10)
		end

feature {NONE} -- Implementation: Anchors

	production_anchor: detachable BNFE_PRODUCTION
			--<Precursor>

end
