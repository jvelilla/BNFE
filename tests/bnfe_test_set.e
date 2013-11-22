note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	BNFE_TEST_SET

inherit
	TEST_SET_HELPER

feature -- Test routines

	test_deep_production
			-- Tests about BNFE_PRODUCTION.out
		local
			l_production: BNFE_PRODUCTION
			l_part: BNFE_PRODUCTION_KIND
			l_root_component,
			l_component,
			l_alt_component: BNFE_COMPONENT
			l_feature: BNFE_FEATURE
			l_attribute: BNFE_ATTRIBUTE [BOOLEAN]
		do
				-- Bnfe production
			create l_root_component.make_with_objects (["Bnfe"])
			l_production := l_root_component.Production
			create l_part.make_as_named_repitition (False, "Production")
			l_production.add_part (l_part)

				-- Production production
			l_component := l_root_component.Production.attached_deep_component_by_name ("Production")
			l_production := l_component.Production
			create l_part.make_as_aggregate_with_components_array (<<create {BNFE_COMPONENT}.make_with_objects (["Construct"]), create {BNFE_COMPONENT}.make_with_objects (["Kind_of_production"])>>)
			l_production.add_part (l_part)
			create l_part.make_as_repitition_with_component (False, create {BNFE_COMPONENT}.make_with_objects (["Specimen"]))
			l_production.add_part (l_part)

				-- Kind_of_production production
			l_component := l_root_component.Production.attached_deep_component_by_name ("Kind_of_production")
			l_production := l_component.Production
			create l_part.make_as_choice_with_components_array (<<create {BNFE_COMPONENT}.make_with_objects (["Aggregate"]), create {BNFE_COMPONENT}.make_with_objects (["Choice"]), create {BNFE_COMPONENT}.make_with_objects (["Repitition"])>>)
			l_production.add_part (l_part)

				-- Aggregate production
			l_component := l_root_component.Production.attached_deep_component_by_name ("Aggregate")
			create l_attribute.make_with_objects (["is_aggregate", True])
			l_attribute.set_description ("Is Current an Aggregate production?")
			l_component.add_feature (l_attribute)
			l_production := l_component.Production
			create l_part.make_as_repitition_with_component (True, create {BNFE_COMPONENT}.make_with_objects (["Component"]))
			l_component.Production.add_specimen ("Something ::= This That The_other (e.g. Something consists of this, that and the other).")
			l_production.add_part (l_part)

				-- Choice production
			l_component := l_root_component.Production.attached_deep_component_by_name ("Choice")
			l_production := l_component.Production
			create l_part.make_as_repitition_with_component (True, create {BNFE_COMPONENT}.make_with_objects (["Choice_construct"]))
			l_component.Production.add_specimen ("Something ::= This or That or The_other (e.g. Something consists of this or that or the other).")
			l_production.add_part (l_part)

				-- Repitition_construct production
			l_component := l_root_component.Production.attached_deep_component_by_name ("Repitition")
			l_production := l_component.Production
			create l_part.make_as_repitition_with_component (True, create {BNFE_COMPONENT}.make_with_objects (["Repitition_construct"]))
			l_component.Production.add_specimen ("Something ::= (This)+ (e.g. Something consists of one or more of This).")
			l_production.add_part (l_part)

				-- Choice_construct production
			l_component := l_root_component.Production.attached_deep_component_by_name ("Choice_construct")
			l_production := l_component.Production
			create l_part.make_as_aggregate_with_components_array (<<create {BNFE_COMPONENT}.make_with_objects (["Component"]), create {BNFE_COMPONENT}.make_with_objects (["Comma_character"]), create {BNFE_COMPONENT}.make_with_objects (["Bar_character"])>>)
			l_production.add_part (l_part)

				-- Repitition_construct production
			l_component := l_root_component.Production.attached_deep_component_by_name ("Repitition_construct")
			l_production := l_component.Production
			create l_part.make_as_aggregate_with_components_array (<<create {BNFE_COMPONENT}.make_with_objects (["Component"]), create {BNFE_COMPONENT}.make_with_objects (["Plus_character"]), create {BNFE_COMPONENT}.make_with_objects (["Asterick_character"])>>)
			l_production.add_part (l_part)

				-- Final test of `deep_out'
			assert_strings_equal ("bnfe_deep_out", deep_production_string, l_root_component.Production.deep_out)
		end

	test_bnfe
			-- Tests about BNFE_CONSTRUCT
		local
			l_base: BNFE_BASE
			l_root: BNFE_ROOT
			l_component: BNFE_COMPONENT
			l_production: BNFE_PRODUCTION
			l_attribute: BNFE_ATTRIBUTE [STRING]
			l_command: BNFE_COMMAND
			l_query: BNFE_QUERY [STRING]
			l_kind: BNFE_PRODUCTION_KIND
		do
			create l_production.make_with_name ("My_production")
			create l_component.make_with_objects (["My_component"])

				-- Repitition
			create l_kind.make_as_repitition (True)
			create l_kind.make_as_repitition_with_component (True, l_component)
			assert_strings_equal ("repitition_out_true", "{My_component}+", l_kind.out)
			create l_kind.make_as_repitition_with_component (False, l_component)
			assert_strings_equal ("repitition_out_false", "{My_component}*", l_kind.out)

				-- Choice
			create l_kind.make_as_choice
			create l_component.make_with_objects (["This"])
			l_kind.add_component (l_component)
			create l_component.make_with_objects (["That"])
			l_kind.add_component (l_component)
			create l_component.make_with_objects (["The_other"])
			l_kind.add_component (l_component)
			assert_strings_equal ("repitition_out_false", "(This | That | The_other)", l_kind.out)

				-- Aggregate
			create l_kind.make_as_aggregate
			create l_component.make_with_objects (["This"])
			l_kind.add_component (l_component)
			create l_component.make_with_objects (["That"])
			l_kind.add_component (l_component)
			create l_component.make_with_objects (["The_other"])
			l_kind.add_component (l_component)
			assert_strings_equal ("repitition_out_false", "This, That, The_other", l_kind.out)

				-- Attribute
			create l_attribute.make_with_objects (["my_attribute", "my_attribute_result_string"])
			assert_strings_equal ("attribute_out", "my_attribute: STRING_8", l_attribute.out)

				-- Command
			create l_command.make_with_objects (["my_command"])
			assert_strings_equal ("command_out", "my_command", l_command.out)
			l_command.add_argument (l_attribute)
			assert_strings_equal ("command_out_with_arg", "my_command (a_my_attribute: STRING_8)", l_command.out)
			l_command.add_argument (create {BNFE_ATTRIBUTE [INTEGER]}.make_with_objects (["my_other_attribute", 2]))
			assert_strings_equal ("command_out_with_args", "my_command (a_my_attribute: STRING_8, a_my_other_attribute: INTEGER_32)", l_command.out)

				-- Query
			create l_query.make_with_objects (["my_query", "my_query_result_string"])
			assert_strings_equal ("query_out", "my_query: STRING_8", l_query.out)
			l_query.add_argument (create {BNFE_ATTRIBUTE [INTEGER]}.make_with_objects (["my_int_argument", 2]))
			assert_strings_equal ("query_out_1_arg", "my_query (a_my_int_argument: INTEGER_32): STRING_8", l_query.out)
			l_query.add_argument (create {BNFE_ATTRIBUTE [BOOLEAN]}.make_with_objects (["my_bool_argument", True]))
			assert_strings_equal ("query_out_2_args", "my_query (a_my_int_argument: INTEGER_32, a_my_bool_argument: BOOLEAN): STRING_8", l_query.out)

			l_component.add_feature (l_attribute)
			l_component.add_feature (l_command)
			l_component.add_feature (l_query)
			assert_strings_equal ("features_list", feature_list, l_component.out)

				-- Production and Production Kinds
			create l_kind.make_as_repitition_with_component (True, create {BNFE_COMPONENT}.make_with_objects (["This"]))
			l_production.add_part (l_kind)
			create l_kind.make_as_repitition_with_component (False, create {BNFE_COMPONENT}.make_with_objects (["That"]))
			l_production.add_part (l_kind)
			create l_kind.make_as_repitition_with_component (True, create {BNFE_COMPONENT}.make_with_objects (["The_other"]))
			l_production.add_part (l_kind)
			create l_kind.make_as_aggregate_with_component (create {BNFE_COMPONENT}.make_with_objects (["Some_aggregate_1"]))
			l_kind.add_component (create {BNFE_COMPONENT}.make_with_objects (["Some_aggregate_2"]))
			l_kind.add_component (create {BNFE_COMPONENT}.make_with_objects (["Some_aggregate_3"]))
			l_production.add_part (l_kind)
			create l_kind.make_as_choice_with_component (create {BNFE_COMPONENT}.make_with_objects (["Some_choice_1"]))
			l_kind.add_component (create {BNFE_COMPONENT}.make_with_objects (["Some_aggregate_2"]))
			l_kind.add_component (create {BNFE_COMPONENT}.make_with_objects (["Some_aggregate_3"]))
			l_production.add_part (l_kind)
			assert_strings_equal ("production_out", production_string, l_production.out)
			assert_strings_equal ("deep_production_out", production_string, l_production.deep_out)
		end

feature {NONE} -- Implementation: Test Constants

	feature_list: STRING = "[
Features:
	my_attribute: STRING_8,
	my_command (a_my_attribute: STRING_8, a_my_other_attribute: INTEGER_32),
	my_query (a_my_int_argument: INTEGER_32, a_my_bool_argument: BOOLEAN): STRING_8

]"

	production_string: STRING = "[

My_production ::=
	{This}+
	{That}*
	{The_other}+
	Some_aggregate_1, Some_aggregate_2, Some_aggregate_3
	(Some_choice_1 | Some_aggregate_2 | Some_aggregate_3)


]"

	deep_production_string: STRING = "[

Bnfe ::=
	{Production}*


Production ::=
	Construct, Kind_of_production
	{Specimen}*


Kind_of_production ::=
	(Aggregate | Choice | Repitition)


Aggregate ::=
	{Component}+

	-- Example: Something ::= This That The_other (e.g. Something consists of this, that and the other).

Choice ::=
	{Choice_construct}+

	-- Example: Something ::= This or That or The_other (e.g. Something consists of this or that or the other).

Choice_construct ::=
	Component, Comma_character, Bar_character


Repitition ::=
	{Repitition_construct}+

	-- Example: Something ::= (This)+ (e.g. Something consists of one or more of This).

Repitition_construct ::=
	Component, Plus_character, Asterick_character


]"

end


