class PeopleController < ApplicationController
  def index
  end

  def show
  end

  def new
  end

  def create
  end

  def edit

  end

  def update
      raise params.inspect
  end

  def destroy
  end

  def confirm_demographics
    @matching_records = Person.all.collect{|x| x}
    render :layout => false
  end
end
