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

  end

  def destroy
  end

  def confirm_demographics
    @matching_records = Utils::PersonUtil.confirm_person_to_update(params)
    render :layout => false
  end

  def update_person
    Utils::PersonUtil.process_person_data(params)
  end
end
