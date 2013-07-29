Given /^I am an Admin/ do

  @role = Role.find_or_create_by_name(name: 'Administrateur')
  @u.roles << @role
end
