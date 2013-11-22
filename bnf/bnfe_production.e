note
	description: "[
				Representation of a BNFE Production.
				
				Consists of one Construct with many
				component parts.
					]"
	date: "$Date$"
	revision: "$Revision$"

class
	BNFE_PRODUCTION

inherit
	BNFE_ROOT
		redefine
			creation_objects_anchor,
			make_with_objects,
			out
		end

create
	make_with_objects,
	make_with_name

feature {NONE} -- Initialization

	make_with_name (a_name: like name)
			-- Initialize Current with `a_name'.
		do
			make_with_objects ([a_name, create {BNFE_COMPONENT}.make_with_objects ([a_name])])
		end

	make_with_objects (a_objects: attached like creation_objects_anchor)
			--<Precursor>
			-- Initialize Current with `a_objects' `construct'.
		do
			Precursor (a_objects)
			construct := a_objects.construct
		end

feature {NONE} -- Implementation: Creation Objects

	creation_objects_anchor: detachable TUPLE [name: like name; construct: like construct]
			-- Creation objects anchor for Current

feature -- Access

	construct: BNFE_COMPONENT
			-- Left-side Construct of Current.

	parts: ARRAYED_LIST [attached like part_anchor]
			-- Zero, one, or more Right-side Parts of Current consists of.
			--| This is a list of BNFE_PRODUCTION_KINDs, which are one of
			--		three variants:
			--	1. Aggregrate
			--	2. Choice
			--	3. Repitition
		attribute
			create Result.make (10)
		end

	specimen: ARRAYED_LIST [STRING]
			-- Zero, one, or more Specimen of Current.
		attribute
			create Result.make (10)
		end

	is_detachable: BOOLEAN
			-- Can Current be Void?

feature -- Settings

	set_is_detachable (a_is_detachable: like is_detachable)
			-- Set `is_detachable' with `a_is_detachable'.
		do
			is_detachable := a_is_detachable
		ensure
			is_detachable_set: is_detachable = a_is_detachable
		end

	add_part (a_part: attached like part_anchor)
			-- Add `a_part' to `parts' of Current.
		do
			parts.force (a_part)
		ensure
			has_part: parts.has (a_part)
		end

	set_parts (a_parts: like parts)
			-- Set `a_parts' into `parts' of Current.
		do
			parts := a_parts
		ensure
			parts_set: parts ~ a_parts
		end

	add_specimen (a_specimen: STRING)
			-- Add `a_specimen' to `specimen' of Current.
		do
			specimen.force (a_specimen)
		ensure
			has_specimen: specimen.has (a_specimen)
		end

	set_specimen (a_specimen: like specimen)
			-- Set `a_specimen' into `specimen' of Current.
		do
			specimen := a_specimen
		ensure
			specimen_set: specimen ~ a_specimen
		end

feature -- Status Report

	out: like {ANY}.out
			--<Precursor>
		do
			create Result.make_empty
			Result.append_character ('%N')
			Result.append_string_general (construct.name)
			if parts.count > 0 then
				Result.append_string_general (" ::=")
				if is_detachable then
					Result.append_string_general (" detachable%N")
				else
					Result.append_character ('%N')
				end
				across parts as ic_parts loop
					Result.append_character ('%T')
					Result.append_string_general (ic_parts.item.out)
					Result.append_character ('%N')
				end
			end
			Result.append_character ('%N')
			Result.append_string_general (construct.out)
		end

	deep_out: like {ANY}.out
			-- Process Current `out' and then `out' of each `part's `construct's `production'
		do
			Result := out
			across parts as ic_parts loop
				across ic_parts.item.components as ic_components loop
					if attached ic_components.item.production as al_production
						and then al_production.parts.count > 0
					then
						Result.append_string_general (al_production.out)
					end
				end
			end
		end

feature {NONE} -- Implementation: Anchors

	part_anchor: detachable BNFE_PRODUCTION_KIND
			-- Type anchor of `parts'.

end
