### Methods ###

Given /^I am an Admin/ do

  @role = Role.find_or_create_by_name(name: 'Administrateur')
  @u.roles << @role
end

Given /^the 1999 and 2099 editions are created/ do
  if !Edition.where(year: 2099).exists?
    @Edition2099 = Edition.create( year: 2099, limit_date: '2099-08-01', edit_limit_date: '2099-09-01', start_date: '2099-01-01', end_date: '2099-12-31', created_at: '2013-05-28 02:01:11.70392', updated_at: '2013-05-28 02:01:11.70392')
  end

  if !Edition.where(year: 1999).exists?
    @Edition1999 = Edition.create( year: 1999, limit_date: '1999-08-01', edit_limit_date: '1999-09-01', start_date: '1999-01-01', end_date: '1999-12-31', created_at: '2013-05-28 02:01:11.70392', updated_at: '2013-05-28 02:01:11.70392')
  end

  if !Setting.where(key: 'current_edition_id').exists?
    @Settings = Setting.create(	key: 'current_edition_id', 	value: @Edition1999.id)
  end
end
