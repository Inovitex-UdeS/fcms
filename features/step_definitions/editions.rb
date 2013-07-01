### Methods ###

Given /^I am an Admin/ do

  @role = Role.find_or_create_by_name(name: 'Administrateur')
  @u.roles << @role
end

Given /^the 2099 edition is created/ do
  @Edition2015 = Edition.create( year: 2099, limit_date: '2099-08-01', start_date: '2099-01-01', end_date: '2099-12-31', created_at: '2013-05-28 02:01:11.70392', updated_at: '2013-05-28 02:01:11.70392')
end
