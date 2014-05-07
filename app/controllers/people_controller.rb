class PeopleController < ApplicationController

  def find
   Utils::PersonUtil.process_person_data(params)
  end

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

  end

  def destroy
  end

  def confirm_demographics
    @matching_records = Person.all.collect{|x| x}

  end
end
