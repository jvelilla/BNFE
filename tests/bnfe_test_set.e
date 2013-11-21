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
		do
			create l_construct.make_with_objects (["My_construct"])
		end

end


