note
	description: "[
					Abstract notion of a Feature: f
					
								F
							   / \
							  A   R
							     / \
							    C   Q
							    
					Where:
					F = Feature
					A = Attribute (f --> r)
					R = Routine
					C = Command (f or f(a))
				 	Q = Query (f --> r or f(a) --> r)
				 	
					]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	BNFE_FEATURE

inherit
	BNFE_BASE

end
