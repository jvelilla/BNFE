note
	description: "[
					Abstract notion of a BNF-E base object.
					]"
	date: "$Date: $"
	revision: "$Revision: $"

deferred class
	BNFE_BASE

inherit
	CREATEABLE

feature {NONE} -- Initialization

	make_with_objects (a_objects: attached like creation_objects_anchor)
			--<Precursor>
		do
			name := a_objects.name
		end

feature {NONE} -- Implementation: Creation Objects

	creation_objects_anchor: detachable TUPLE [name: like name]
			-- Creation objects anchor for Current

	is_valid_creation_objects (a_objects: attached like creation_objects_anchor): BOOLEAN
			-- Are the `a_objects' valid for Current?
		do
			Result := True
		end

feature -- Access

	name: STRING
			-- Name of Current.
		attribute
			create Result.make_empty
		end

feature -- Settings

	set_name (a_name: like name)
			-- Set `name' with `a_name'.
		require
			non_empty: not a_name.is_empty
		do
			name := a_name
		ensure
			name_set: name.same_string (a_name)
		end

invariant
	valid_name: across name as ic_name all ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_0123456789").has (ic_name.item) end

end
