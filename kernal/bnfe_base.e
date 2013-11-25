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

	STORABLE

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

	items: ARRAYED_LIST [attached like items_anchor]
			-- A list of items contained by Current.
		deferred
		end

	remove (a_item: attached like items_anchor)
			-- Remove `a_item' from `items'
		do
			from items.start
			until items.exhausted
			loop
				if items.item_for_iteration ~ a_item then
					items.remove
				end
				items.forth
			end
		ensure
			item_removed: not items.has (a_item)
		end

	bnfe_type: STRING
			-- Type of Current as a BNF-E entity.
		local
			l_generics,
			l_new_generics: STRING
			l_start,
			l_end: INTEGER
		do
			Result := generating_type.twin
			Result.replace_substring_all ("BNFE_", "")
			Result.to_lower
			Result := Result [1].as_upper.out + Result.substring (2, Result.count)
			if Result.has ('[') and Result.has (']') then
				l_start := Result.character_32_index_of ('[', 1)
				l_end := Result.character_32_index_of (']', 1)
				l_generics := Result.substring (l_start, l_end)
				l_new_generics := l_generics.twin
				l_new_generics.replace_substring_all ("[", "")
				l_new_generics.replace_substring_all ("]", "")
				l_new_generics.replace_substring_all ("!", "")
				l_new_generics := l_new_generics [1].as_upper.out + l_new_generics.substring (2, l_new_generics.count)
				l_new_generics.prepend_string_general ("--> ")
				Result.replace_substring_all (l_generics, l_new_generics)
			end
		ensure
			has_result: not Result.is_empty
		end

feature -- Settings

	is_terminal: BOOLEAN
			-- Is Current a terminal construct?
		do
			Result := items.count = 0
		ensure
			result_empty_items: Result = (items.count = 0)
		end

	set_name (a_name: like name)
			-- Set `name' with `a_name'.
		require
			non_empty: not a_name.is_empty
		do
			name := a_name
		ensure
			name_set: name.same_string (a_name)
		end

feature -- Status Report

	is_symbols_only: BOOLEAN
			-- Is `name' a collection of `valid_symbol_characters' only?
		do
			check has_name: not name.is_empty end
			Result := across name as ic_name all valid_symbol_characters.has (ic_name.item) end
		end

feature {NONE} -- Implementation: Constants

	valid_name_characters: STRING = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_0123456789%""
			-- Characters of which a valid `name' consists.

	valid_symbol_characters: STRING = ":=-"

feature {NONE} -- Implementation: Anchor

	items_anchor: detachable ANY
			-- Type anchor for `items'.

invariant
	never_attached: not attached items_anchor
	consistent_terminal: is_terminal implies items.count = 0
--	symbols_terminal: is_symbols_only implies is_terminal
--	non_empty_name: not name.is_empty
	valid_name: across name as ic_name all valid_name_characters.has (ic_name.item) end
				or across name as ic_name all valid_symbol_characters.has (ic_name.item) end
	mutex_name_or_symbol: across name as ic_name some valid_symbol_characters.has (ic_name.item) end
						implies not across name as ic_name all valid_name_characters.has (ic_name.item) end

end
