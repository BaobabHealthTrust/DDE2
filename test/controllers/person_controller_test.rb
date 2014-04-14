#!/usr/bin/ruby

require 'minitest/unit'

class PersonControllerTest < MiniTest::Test

  def test_assign_to_site
    npids = Npid.unassigned_to_site.limit(20)

    (npids || []).each do |npid|
      npid.site_code = Site.site_code
      npid.save
    end
    w = Npid.unassigned_at_site

    assert w.count == 60

  end

  def test_insert_person

    w = Npid.unassigned_at_site.first

    new_person = Person.new
    new_person.id = w.national_id
    new_person.gender = "Male"
    new_person.birthdate = "1970-12-30".to_date
    if new_person.save
      w.assigned = true
      w.save
    end

    assert Person.find(new_person.id)
  end

  def test_update_person()

    #This method is an entry point for updating patient records when they are updated in an application
    params = {
      :gender => "Male",
      :birthdate => "2000-05-11",
      :national_id => "HETTGH"
    }
    updated_person = update_person(params)

  end

  def test_updated_person (part)
    # this method will check if the details an application sends to dde are the same if not the same it will send a
    # page to compare the two records and prompt the user to update the details

    puts part
    assert part
  end

  def update_person(params)

    person = Person.find(params[:national_id])
    if person.blank?
      person.gender = params[:gender]
      person.birthdate = params[:birthdate]
    else
      person = Person.new
      person.gender = params[:gender]
      person.birthdate = params[:birthdate]
      person.national_id = params[:national_id]

      npid = Npid.find
    end

    person.save

  end

  def create_person

  end
end