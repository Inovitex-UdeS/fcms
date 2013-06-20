### METHODS ###
def create_credentials
  @credentials ||= {  :validTeacherId => 1,   :invalidTeacherId => 479,
                      :validCategoryId => 1,  :invalidCategoryId => 479,
                      :validComposerId => 1,  :invalidComposerId => 479,
                      :validTitleId => 1,     :invalidTitleId => 479 }
end

### GIVEN ###
Given /^I visit registration page$/ do
  visit '/registrations/new'
end

Given /^I am logged in$/ do
  step 'I am on the sign in page'
  step 'I fill in "user_email" with "tests@inovitex.com"'
  step 'I fill in "user_password" with "123test123"'
  step 'I press "Se connecter"'
end

Given /^I select a valid teacher$/ do
  select("#{@u.first_name} #{@u.last_name}, (#{@u.email})", :from => 'registration_user_teacher_id')
end

Given /^a teacher exists$/ do
  @u = User.create(last_name: 'Paquette', first_name: 'Daniel', gender: true, birthday: '1980-05-12', email: 'dp@me.com', password: 'password', confirmed_at: '2013-05-28 02:01:11.70392')
  @r = Role.find_or_create_by_name(name: 'Professeur')
  @u.roles << @r
end

Given /^I select a valid category$/ do
  select(@categ.name, :from => 'registration_category_id')
end

Given /^a category exists$/ do
  @categ = Category.create(name: 'Repertoire', nb_perf_min: 2, nb_perf_max: 4, description:'Categorie pour le repertoire de la guitare classique')
end




