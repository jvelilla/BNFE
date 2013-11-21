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
			make_with_objects
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
		do
			Precursor (a_objects)
			construct := a_objects.construct
		end

feature {NONE} -- Implementation: Creation Objects

	creation_objects_anchor: detachable TUPLE [name: like name; construct: like construct]
			-- Creation objects anchor for Current

feature -- Access

	construct: BNFE_COMPONENT

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

feature -- Settings

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

feature {NONE} -- Implementation: Anchors

	part_anchor: detachable BNFE_PRODUCTION_KIND
			-- Type anchor of `parts'.
			
end
