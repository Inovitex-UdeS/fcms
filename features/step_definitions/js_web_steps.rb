When /^(?:|I )js click on the table row containing "([^"]*)"$/ do |field|
  page.execute_script("$('table tr:contains(#{field})').click()")
end

When /^(?:|I )js double click on the table row containing "([^"]*)"$/ do |field|
  page.execute_script("$('table tr:contains(#{field})').click()")
  page.execute_script("$('table tr:contains(#{field})').click()")
  sleep(4)
end

When /^(?:|I )js click on "([^"]*)"$/ do |field|
  page.execute_script("$(#{field}).click()")
end

When /^(?:|I )js change the input "([^"]*)" value for "([^"]*)"$/ do |field, value|
  page.execute_script("$('input[id=#{field}]').val('#{value}')")
end

When /^(?:|I )js fill the datatables-search for "([^"]*)"$/ do |value|
  page.execute_script("$('input[id=datatables-search]').val('#{value}')")
  find('#datatables-search').native.send_keys(:return)
end

When /^(?:|I )js select the first value of "([^"]*)"$/ do |field|
  # Not working, needs to be fixed ASAP
  page.execute_script("document.getElementById('#{field}').selectedIndex = 1")
end

