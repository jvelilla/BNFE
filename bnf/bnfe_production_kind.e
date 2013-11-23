note
	description: "[
					Representation of a Kind of Production: Aggregate, Choice, or Repitition.
					]"
	date: "$Date: $"
	revision: "$Revision: $"

class
	BNFE_PRODUCTION_KIND

inherit
	BNFE_BASE
		redefine
			is_symbols_only,
			out
		end
create
	make_as_aggregate,
	make_as_aggregate_with_component,
	make_as_aggregate_with_components,
	make_as_aggregate_with_components_array,
	make_as_choice,
	make_as_choice_with_component,
	make_as_choice_with_components,
	make_as_choice_with_components_array,
	make_as_repitition,
	make_as_repitition_with_component,
	make_as_named_repitition

feature {NONE} -- Initialization

	make_as_aggregate
			-- Initialize Current as a conjunctive list of aggregate `components'.
		do
			set_is_aggregate
		ensure
			is_aggregate: is_aggregate
		end

	make_as_aggregate_with_components (a_components: like components)
			-- Initialize Current as a conjunctive list of aggregate `components'.
		require
			has_components: a_components.count > 0
		do
			make_as_aggregate
			components := a_components
		ensure
			components_set: components ~ a_components
		end

	make_as_aggregate_with_components_array (a_components: ARRAY [BNFE_COMPONENT])
			-- Initialize Current as a conjunctive list of aggregate `components' from `a_components' array.
		require
			has_components: a_components.count > 0
		do
			make_as_aggregate
			across a_components as ic_components loop
				components.force (ic_components.item)
			end
		ensure
			components_set: across a_components as ic_components all components.has (ic_components.item) end
		end

	make_as_aggregate_with_component (a_component: attached like component_anchor)
			-- Initialize Current as a conjunctive list of aggregate `components' from `a_components' array list.
		do
			make_as_aggregate
			components.force (a_component)
		ensure
			component_added: components.has (a_component)
		end

	make_as_choice
			-- Initialize Current as a disjunctive choice of `components'.
		do
			set_is_choice
		ensure
			is_choice: is_choice
		end

	make_as_choice_with_components (a_components: like components)
			-- Initialize Current as a conjunctive list of aggregate `components' from `a_components' array list.
		require
			has_components: a_components.count > 0
		do
			make_as_choice
			components := a_components
		ensure
			components_set: components ~ a_components
		end

	make_as_choice_with_components_array (a_components: ARRAY [BNFE_COMPONENT])
			-- Initialize Current as a conjunctive list of aggregate `components' from `a_components' array.
		require
			has_components: a_components.count > 0
		do
			make_as_choice
			across a_components as ic_components loop
				components.force (ic_components.item)
			end
		ensure
			components_set: across a_components as ic_components all components.has (ic_components.item) end
		end

	make_as_choice_with_component (a_component: attached like component_anchor)
			-- Initialize Current as a conjunctive list of aggregate `components' from `a_component'.
		do
			make_as_choice
			components.force (a_component)
		ensure
			component_added: components.has (a_component)
		end

	make_as_repitition (a_one_or_more: like is_one_or_more)
			-- Initialize Current with `a_one_or_more' flag, leaving `components' unknown.
		do
			set_is_repitition (a_one_or_more)
			components.wipe_out
		ensure
			is_repitition: is_repitition
			empty_components: components.is_empty
		end

	make_as_repitition_with_component (a_one_or_more: like is_one_or_more; a_component: attached like component_anchor)
			-- Initialize Current with `a_one_or_more' and `a_component', which is known.
		do
			make_as_repitition (a_one_or_more)
			components.force (a_component)
		ensure
			has_component: components.has (a_component)
		end

	make_as_named_repitition (a_one_or_more: like is_one_or_more; a_name: like {BNFE_COMPONENT}.name)
			-- Initialize Current with `a_one_or_more' and `a_name' for component.
		require
			non_empty: not a_name.is_empty
		local
			l_component: attached like component_anchor
		do
			make_as_repitition (a_one_or_more)
			create l_component.make_with_objects ([a_name])
			components.force (l_component)
		ensure
			component_added: components.count = 1
			has_component: across components as ic_components some ic_components.item.name.same_string (a_name) end
		end

feature -- Access

	components: ARRAYED_LIST [attached like component_anchor]
			-- Zero, one, or more Components of Current.
		attribute
			create Result.make (10)
		end

	production: attached like internal_production
			-- Attached version of `internal_production'.
			--| The production parent of Current.
		do
			check has_production: attached internal_production as al_production then Result := al_production end
		end

feature -- Status Report

	is_symbols_only: BOOLEAN
			--<Precursor>
		do
			check has_name: not production.name.is_empty end
			Result := across production.name as ic_name all valid_symbol_characters.has (ic_name.item) end
		end

	attached_component_by_name (a_name: like {BNFE_COMPONENT}.name): BNFE_COMPONENT
			-- Fetch an attached version of `component_by_name'.
		do
			check attached component_by_name (a_name) as al_component then Result := al_component end
		end

	component_by_name (a_name: like {BNFE_COMPONENT}.name): detachable BNFE_COMPONENT
			-- Fetch component from `components' with `a_name'.
		do
			from
				components.start
			until
				components.exhausted or attached Result
			loop
				if components.item_for_iteration.name.same_string (a_name) then
					Result := components.item_for_iteration
				end
				components.forth
			end
		ensure
			attached_if_has_name: across components as ic_components some ic_components.item.name.same_string (a_name) end implies attached Result
		end

	is_aggregate: BOOLEAN
			-- Is Current an Aggregate right-side component.

	is_choice: BOOLEAN
			-- Is Current a Choice right-side component.

	is_repitition: BOOLEAN
			-- Is Current a Repitition right-side component.
		do
			Result := not is_aggregate and not is_choice
		end

	is_one_or_more: BOOLEAN
			-- If `is_repitition', then is Current One-or-more?

	is_optional: BOOLEAN
			-- Is Current an "optional" kind?

	one_or_more: BOOLEAN
			-- One or more constant.
		once
			Result := True
		end

	zero_one_or_more: BOOLEAN
			-- Zero, one, or more constant.
		once
			Result := not one_or_more
		end

	contains_symbols_only (a_string: STRING): BOOLEAN
			-- Does `a_string' contain values only?
		require
			non_empty: not a_string.is_empty
		do
			Result := across a_string as ic_string all valid_symbol_characters.has (ic_string.item) end
		end

	out: attached like {ANY}.out
			--<Precursor>
		local
			l_closing_char: STRING
		do
			create Result.make_empty
			if is_optional and not is_repitition then
				Result.append_character ('[')
			end

			across components as ic_components loop
				if contains_symbols_only (ic_components.item.name) then
					l_closing_char := "%""
				else
					l_closing_char := ""
				end
				check has_name: not ic_components.item.name.is_empty end
				if ic_components.is_first then
					if is_choice then
						Result.append_character ('(')
					elseif is_repitition then
						Result.append_character ('{')
					end
				end

				Result.append_string_general (l_closing_char)
				Result.append_string_general (ic_components.item.name)
				Result.append_string_general (l_closing_char)

				if is_choice and not ic_components.is_last then			-- CHOICE Append " | "
					Result.append_character (' ')
					Result.append_character ('|')
					Result.append_character (' ')
				elseif is_choice and ic_components.is_last then			-- CHOICE Close with '}'
					Result.append_character (')')
				elseif is_aggregate and not ic_components.is_last then	-- AGGREGATE Append " & "
					Result.append_character ('%N')
					Result.append_character ('%T')
				elseif is_repitition and ic_components.is_last then		-- REPITITION Close with '}'
					Result.append_character ('}')
				end
			end
			if is_repitition and is_one_or_more then
				Result.append_character ('+')
			elseif is_repitition then
				Result.append_character ('*')
			end
				-- Optional closing
			if is_optional and not is_repitition then
				Result.append_character (']')
			end
		end

feature -- Settings

	set_production (a_production: like production)
			-- Set `production' with `a_production'.
		do
			internal_production := a_production
		ensure
			production_set: production ~ a_production
		end

	add_component (a_component: BNFE_COMPONENT)
			-- Add `a_component' to `components'.
		do
			components.force (a_component)
		ensure
			has_components: components.has (a_component)
		end

	set_components (a_components: like components)
			-- Set `components' with `a_components'.
		do
			components := a_components
		ensure
			components_set: components ~ a_components
		end

	set_is_aggregate
		do
			is_aggregate := True
			is_choice := False
			is_one_or_more := False
		ensure
			not_choice_or_repitition: not is_choice and not is_repitition and not is_one_or_more
		end

	set_is_choice
		do
			is_aggregate := False
			is_choice := True
			is_one_or_more := False
		ensure
			not_aggregate_or_repitition: not is_aggregate and not is_repitition and not is_one_or_more
		end

	set_is_repitition (a_one_or_more: BOOLEAN)
		do
			is_aggregate := False
			is_choice := False
			is_one_or_more := a_one_or_more
		ensure
			not_aggregate_or_choice: not is_aggregate and not is_choice
		end

	set_is_optional (a_flag: BOOLEAN)
			-- Set `is_optional' with `a_flag'.
		do
			is_optional := a_flag
		ensure
			is_optional_set: is_optional = a_flag
		end

feature {NONE} -- Implemenatation

	internal_production: detachable BNFE_PRODUCTION
			-- Internal storage for related parent production.

feature {NONE} -- Implementation: Anchors

	component_anchor: detachable BNFE_COMPONENT
			-- Type anchor for `components'.

invariant
	repitition_only_one_part: is_repitition implies components.count <= 1
	aggregate_not_choice_or_repitition: is_aggregate implies (not is_choice and not is_repitition)
	choice_not_aggregate_or_repitition: is_choice implies (not is_aggregate and not is_repitition)
	repitition_not_aggregate_or_choice: is_repitition implies (not is_choice and not is_aggregate)
	component_anchor: not attached component_anchor

end
