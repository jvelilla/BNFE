note
	description: "[
					Representation of a BNF-E Component.
					]"
	date: "$Date: $"
	revision: "$Revision: $"

class
	BNFE_COMPONENT

inherit
	BNFE_BASE
		rename
			items as features,
			items_anchor as features_anchor
		redefine
			features,
			features_anchor,
			out
		end

create
	make_with_objects

feature -- Access

	features: ARRAYED_LIST [attached like features_anchor]
			-- List of zero, one, or more features of Current.
		attribute
			create Result.make (10)
		end

	production: BNFE_PRODUCTION
			-- Optional production for Current.
		once ("object")
			create Result.make_with_name (name)
		end

feature -- Settings

	add_feature (a_feature: attached like features_anchor)
			-- Add `a_feature' to `features' of Current.
		do
			features.force (a_feature)
		ensure
			feature_added: features.has (a_feature)
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

	deep_out: like Production.deep_out
			-- Deep out of Current.
		do
			Result := Production.deep_out
		end

feature {NONE} -- Implementation: Anchors

	features_anchor: detachable BNFE_FEATURE
			--<Precursor>

end
