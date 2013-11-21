note
	description: "[
				Definition: Component, construct, specimen
				
				Any class text, or syntactically meaningful part of it, such as an instruction, an expression or an identifier, 
				is called a component.
				
				The structure of any kind of components is described by a construct. A component of a kind described by a 
				certain construct is called a specimen of that construct.
				]"
	author: "Larry Rix"
	date: "$Date: $"
	revision: "$Revision: $"

class
	BNFE_CONSTRUCT

inherit
	CREATEABLE

create
	make_with_objects

feature {NONE} -- Initialization

	make_with_objects (a_objects: attached like creation_objects_anchor)
			-- Initialize Current with `a_objects'.
		do
			name := a_objects.name
		end

feature -- Access

	name: STRING
			-- Name of Current.

	manifest_value: detachable STRING
			-- Optionally, a manifest value.

feature -- Status Report

	is_keyword: BOOLEAN
			-- Is Current a keyword?

	is_manifest: BOOLEAN
			-- Is Current a `manifest' (e.g. 234 or 'c')
		do
			Result := attached manifest_value as al_value and then
						(al_value.is_integer or al_value.is_real or al_value.is_boolean)
--			Result := Result or (attached manifest_value as al_value and then al_value.count = 1 and then )
		end

feature -- Settings

	set_manifest_value (a_manifest_value: attached like manifest_value)
			-- Set`a_manifest_value' into `manifest_value'.
		do
			manifest_value := a_manifest_value
		ensure
			manifest_value_set: attached manifest_value as al_manifest_value and then al_manifest_value.same_string_general (a_manifest_value)
		end

feature {NONE} -- Implementation: Creation Objects

	creation_objects_anchor: detachable TUPLE [name: like name]
			-- Creation objects anchor for Current

	is_valid_creation_objects (a_objects: attached like creation_objects_anchor): BOOLEAN
			-- Are the `a_objects' valid for Current?
		do
			Result := True
		end

invariant
	spaceless_name: not name.has (' ')
	proper_cased_name: name.same_string_general (name [1].as_upper.out + name.substring (2, name.count).out)

end
