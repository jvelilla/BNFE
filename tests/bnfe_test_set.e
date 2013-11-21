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

	test_bnfe
			-- Tests about BNFE_CONSTRUCT
		local
			l_construct: BNFE_CONSTRUCT
			l_base: BNFE_BASE
			l_root: BNFE_ROOT
			l_component: BNFE_COMPONENT
			l_production: BNFE_PRODUCTION
			l_attribute: BNFE_ATTRIBUTE [STRING]
			l_command: BNFE_COMMAND
			l_query: BNFE_QUERY [STRING]
			l_kind: BNFE_PRODUCTION_KIND
		do
			create l_construct.make_with_objects (["My_construct"])
			create l_production.make_with_name ("My_production")
			create l_component.make_with_objects (["My_component"])
			create l_kind.make_as_aggregate
			create l_kind.make_as_choice
			create l_kind.make_as_repitition (True)
			create l_kind.make_as_repitition_with_component (True, l_component)
		end

end


