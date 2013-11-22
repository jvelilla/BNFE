note
	description: "[
					Representation of a BNF-E Component.
					]"
	date: "$Date: $"
	revision: "$Revision: $"

class
	BNFE_COMPONENT

inherit
	BNFE_ROOT
		redefine
			out
		end

create
	make_with_objects

feature -- Access

	features: ARRAYED_LIST [BNFE_FEATURE]
			-- List of zero, one, or more features of Current.
		attribute
			create Result.make (10)
		end

	production: detachable BNFE_PRODUCTION
			-- Optional production for Current.
			--| A Product Construct is a root Component.

feature -- Settings

	add_feature (a_feature: BNFE_FEATURE)
			-- Add `a_feature' to `features' of Current.
		do
			features.force (a_feature)
		ensure
			feature_added: features.has (a_feature)
		end

	set_production (a_production: attached like production)
			-- Set `production' with `a_production'.
		do
			production := a_production
		ensure
			production_set: production ~ a_production
		end

feature -- Status Report

	out: like {ANY}.out
			--<Precursor>
		do
			create Result.make_empty
			if features.count > 0 then
				Result.append_string_general ("Features:")
				Result.append_character ('%N')
				across features as ic_features loop
					Result.append_character ('%T')
					Result.append_string_general (ic_features.item.out)
					if not ic_features.is_last then
						Result.append_character (',')
					end
					Result.append_character ('%N')
				end
			end
		end

end
