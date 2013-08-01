##
# Controller for the landing page of the admin panel
class Admin::DashboardController < ApplicationController
  before_filter :prevent_non_admin

  ##
  # Statistics about the current information
  def index

    @users = User.all
    @registrations = Registration.where(edition_id: Edition.find(Setting.find_by_key('current_edition_id').value))
    @timeslots = Timeslot.where(:edition_id => Edition.find(Setting.find_by_key('current_edition_id').value))

    # Registrations by categories
    categ = Hash.new
    Category.all.each {|c| categ[c.name.to_s] = c.registrations.where(:edition_id => Edition.find(Setting.find_by_key('current_edition_id').value)).size  }
    @categ_pie = Igs::PieChart.new('Dispersion d',200,0.4,'#categ-pie', categ)

    # Age of users
    users = Hash.new
    User.participants.order("birthday DESC").each do |u|
      key = piechart_age_title(u.age)
      if not users.has_key?(key)
        users[key] = 0
      else
        users[key] = users[key] + 1
      end
    end
    @users_pie = Igs::PieChart.new('Dispersion ',200,0.4,'#users-pie', users)

    # Registrations by instruments
    instr = Hash.new
      Instrument.all.each do |i|
        size = i.registrations.where(:edition_id => Edition.find(Setting.find_by_key('current_edition_id').value)).size
        if size < 6
          if instr.has_key? "autres"
            instr["autres"] += size
          else
            instr["autres"] = size
          end
        else
          instr[i.name.to_s] = size
        end
      end
    @instr_pie = Igs::PieChart.new('Dispersion ',200,0.4,'#instr-pie', instr)

  end

  ##
  # Utility method for pie chart age
  def piechart_age(age)
    age + age%2
  end

  ##
  # Utility method for pie chart title
  def piechart_age_title(age)
    "#{piechart_age(age)-1}-#{piechart_age(age)}"
  end

  def home
  end
end
