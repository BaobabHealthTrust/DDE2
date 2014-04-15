#!/usr/bin/ruby

require 'minitest/unit'

class PersonControllerTest < MiniTest::Test

  def test_assign_to_site
    count = Npid.assigned_to_site.count
    npids = Npid.unassigned_to_site.limit(20)

    (npids || []).each do |npid|
      npid.site_code = Site.site_code
      npid.save
    end
    w = Npid.assigned_to_site.count

    assert w == (count + 20)

  end

  def test_insert_person

    w = Npid.unassigned_at_site.first
    unless w.blank?
      new_person = Person.new

      new_person.id = w.national_id
      new_person.gender = "Male"
      new_person.birthdate = "1970-12-30".to_date
      new_person.assigned_site = Site.site_code
      new_person.patient_assigned = true
      new_person.names = {:given_name => "Mary", :family_name => "banda"}
      new_person.addresses =  {:current_residence => "Ntandire", :current_village => "Area 49",
                               :current_district => "Lilongwe", :current_ta => "Area 49", :home_village => "Nsomba",
                               :home_ta => "Kuntaja", :home_district => "Blantyre"}
      new_person.person_attributes = {:citizenship => "Malawian", :occupation => "HouseWife",
                                      :home_phone_number => "01678879", :cell_phone_number => "0118903153",
                                      :race => "african"}

      if new_person.save
        w.assigned = true
        w.save
      end

      assert Person.find(new_person.id)
    end
  end

  def test_update_person()
    current_people = Person.count
    #This method is an entry point for updating patient records when they are updated in an application
    params = {
      :gender => "Male",
      :birthdate => "2000-05-11",
      :national_id => "HETXRA"
    }
    parameters = {
        :gender => "Female",
        :birthdate => "2007-05-11",
        :national_id => "HETWLT"
    }

    assert updated_person = update_person(params)
    assert updated_person = update_person(parameters)
    assert Person.count == (current_people + 2)
  end

  def test_updated_person
    # this method will check if the details an application sends to dde are the same if not the same it will send a
    # page to compare the two records and prompt the user to update the details
    assert true
  end

  def update_person(params)

    person = Person.find(params[:national_id])
    if person.blank?
      person = Person.new
      person.gender = params[:gender]
      person.birthdate = params[:birthdate]
      person.national_id = params[:national_id]

      npids = Npid.assigned_to_site.collect{|x| x}
      npid = npids[npids.collect{|x| x.national_id}.index(params[:national_id])]
      npid.site_code = Site.site_code
      npid.assigned = true
      npid.save
    else
      person.gender = params[:gender]
      person.birthdate = params[:birthdate]
    end

    person.save

  end

  def create_person

  end
end