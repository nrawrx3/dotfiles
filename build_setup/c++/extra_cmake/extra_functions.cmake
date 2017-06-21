# Prepends the string `to_prepend` to each item in the given list `the_list`
# and stores the resulting list in `return_var` of the global scope.
function(ex_prepend_to_each the_list to_prepend return_var)
	set(prepended_items "")
	foreach(item ${the_list})
		set(prepended_items "${to_prepend}${item};${prepended_items}")
	endforeach()
	set(${return_var} "${prepended_items}" PARENT_SCOPE)
endfunction()
