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
