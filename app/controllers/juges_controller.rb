class JugesController < ApplicationController
  def new
    @juge = User.new
    @juge.contactinfo ||= Contactinfo.new
    @juge.contactinfo.city ||= City.new
    @juges = User.all(:joins => :roles, :conditions => {:roles => { :name => 'juge'}})
  end

  def create
    begin
      @juge = User.find(1)
    end
  end
end
