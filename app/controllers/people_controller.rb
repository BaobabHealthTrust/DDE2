class PeopleController < ApplicationController

  def find
   Utils::PersonUtil.process_person_data(params.to_json)
    respond_to do |format|
        format.json { render :json   => {}.to_json }
      end
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
