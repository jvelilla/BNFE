note
	description: "Summary description for {BNFE_PRODUCTION_KIND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BNFE_PRODUCTION_KIND

inherit
	ANY
		redefine
			out
		end
create
	make_as_aggregate,
	make_as_aggregate_with_component,
	make_as_aggregate_with_components,
	make_as_choice,
	make_as_choice_with_component,
	make_as_choice_with_components,
	make_as_repitition,
	make_as_repitition_with_component

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
		do
			make_as_aggregate
			components := a_components
		ensure
			components_set: components ~ a_components
		end

	make_as_aggregate_with_component (a_component: attached like component_anchor)
			-- Initialize Current as a conjunctive list of aggregate `components'.
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
			-- Initialize Current as a conjunctive list of aggregate `components'.
		do
			make_as_choice
			components := a_components
		ensure
			components_set: components ~ a_components
		end

	make_as_choice_with_component (a_component: attached like component_anchor)
			-- Initialize Current as a conjunctive list of aggregate `components'.
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
		ensure
			is_repitition: is_repitition
		end

	make_as_repitition_with_component (a_one_or_more: like is_one_or_more; a_component: attached like component_anchor)
			-- Initialize Current with `a_one_or_more' and `a_component', which is known.
		do
			make_as_repitition (a_one_or_more)
			components.force (a_component)
		ensure
			has_component: components.has (a_component)
		end

feature -- Access

	components: ARRAYED_LIST [attached like component_anchor]
			-- Zero, one, or more Components of Current.
		attribute
			create Result.make (10)
		end

	component_anchor: detachable BNFE_COMPONENT
			-- Type anchor for `components'.

feature -- Status Report

	is_aggregate: BOOLEAN

	is_choice: BOOLEAN

	is_repitition: BOOLEAN
		do
			Result := not is_aggregate and not is_choice
		end

	is_one_or_more: BOOLEAN
			-- If `is_repitition', then is Current One-or-more?

	out: attached like {ANY}.out
		do
			create Result.make_empty
			across components as ic_components loop
				Result.append_string_general (ic_components.item.name)
				if is_choice then
					Result.append_character (' ')
					Result.append_character ('|')
				end
			end
			if Result [Result.count] = '|' then
				Result.remove_tail (1)
			end
		end

feature -- Settings

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

invariant
	repitition_only_one_part: is_repitition implies components.count <= 1

end
