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

When /^(?:|I )js set the select2 "([^"]*)" value for "([^"]*)"$/ do |field, value|
  page.execute_script("$('##{field}').data('select2').externalSearch('#{value}')")
  sleep(2)
  page.execute_script("$('##{field}').data('select2').selectHighlighted()")
end

When /^(?:|I )js change the input "([^"]*)" value for "([^"]*)"$/ do |field, value|
  page.execute_script("$('input[id=#{field}]').val('#{value}')")
end

When /^(?:|I )js change the typeahead "([^"]*)" value for "([^"]*)"$/ do |field, value|
  page.execute_script("$('select[id=#{field}]').children('option').eq(#{value}).prop('selected', true)")
end

When /^(?:|I )js fill the datatables-search for "([^"]*)"$/ do |value|
  page.execute_script("$('input[id=datatables-search]').val('#{value}')")
  find('#datatables-search').native.send_keys(:return)
end

