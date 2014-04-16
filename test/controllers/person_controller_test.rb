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
      :gender => "Female",
      :birthdate => "1968-05-11",
    }

    assert update_person(params)
    assert Person.count == current_people
  end

  def test_updated_person
    # this method will check if the details an application sends to dde are the same if not the same it will send a
    # page to compare the two records and prompt the user to update the details
    assert true
  end

  def update_person(params)

    person = Person.last
    old_person = person.clone

    person.gender = params[:gender]
    person.birthdate = params[:birthdate]
    person.names.given_name = "Mary"
    person.names.family_name = "banda"
    person.addresses.current_residence = "Ntandire"
    person.addresses.current_village ="Area 49"
    person.addresses.current_district = "Lilongwe"
    person.addresses.current_ta = "Area 49"
    person.addresses.home_village = "Nsomba"
    person.addresses.home_ta = "Kuntaja"
    person.addresses.home_district = "Blantyre"
    person.person_attributes.citizenship = "Malawian"
    person.person_attributes.occupation = "HouseWife"
    person.person_attributes.home_phone_number = "01678879"
    person.person_attributes.cell_phone_number = "0118903153"
    person.person_attributes.race = "african"


    print "Attribute".ljust(20)
    print "Updated Demographic".ljust(20)
    print "Old Demographic".ljust(20)
    puts

    print "National ID".ljust(20)
    print "#{person.id}".ljust(20)
    print "#{old_person.id}".ljust(20)
    puts
    print "First Name".ljust(20)
    print "#{person.names['given_name']}".ljust(20)
    print "#{old_person.names['given_name']}".ljust(20)
    puts
    print "Surname".ljust(20)
    print "#{person.names['family_name']}".ljust(20)
    print "#{old_person.names['family_name']}".ljust(20)
    puts
    print "Gender".ljust(20)
    print "#{person.gender}".ljust(20)
    print "#{old_person.gender}".ljust(20)
    puts
    print "Birthdate".ljust(20)
    print "#{person.birthdate}".ljust(20)
    print "#{old_person.birthdate}".ljust(20)
    puts
    print "Citizenship".ljust(20)
    print "#{person.person_attributes['citizenship']}".ljust(20)
    print "#{old_person.person_attributes['citizenship']}".ljust(20)
    puts
    print "Occupation".ljust(20)
    print "#{person.person_attributes['occupation']}".ljust(20)
    print "#{old_person.person_attributes['occupation']}".ljust(20)
    puts
    print "Home Phone Number".ljust(20)
    print "#{person.person_attributes.home_phone_number}".ljust(20)
    print "#{old_person.person_attributes.home_phone_number}".ljust(20)
    puts
    print "Cell Phone Number".ljust(20)
    print "#{person.person_attributes.cell_phone_number}".ljust(20)
    print "#{old_person.person_attributes.cell_phone_number}".ljust(20)
    puts
    print "Race".ljust(20)
    print "#{person.person_attributes.race}".ljust(20)
    print "#{old_person.person_attributes.race}".ljust(20)
    puts
    print "Please confirm the update : "
    answer = gets.chomp
    if answer == "Y"
      return person.save
    else
      return false
    end
=begin
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
=end

    #person.save

  end

  def create_person

  end
end