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
    puts "Update Gender"
    params = {
      :gender => "Female"
    }
    assert update_person(params)
    puts "Update Birthdate"
    params = {
        :birthdate => "1968-05-11"
    }
    assert update_person(params)
    puts "Update Birthdate Estimated"
    params = {
        :birthdate_estimated => true
    }
    assert update_person(params)
    puts "Update Given Name"
    params = {
        :given_name => "Maria"
    }
    assert update_person(params)
    puts "Update Citizenship"
    params = {
        :citizenship => "Indian"
    }
    assert update_person(params)
    puts "Update Race"
    params = {
        :race => "Asian"
    }
    assert update_person(params)
    puts "Update Current District"
    params = {
        :current_district => "Mzimba"
    }
    assert update_person(params)
    puts "Update Home District"
    params = {
        :home_district => "Dedza"
    }
    assert update_person(params)
  end

  def test_updated_person
    # this method will check if the details an application sends to dde are the same if not the same it will send a
    # page to compare the two records and prompt the user to update the details
    assert true
  end

  def test_compare_two_people

    person_one = Person.last
    person_two = Person.first
    puts person_one.to_json
    puts person_two.to_json
    single_attributes = ["birthdate", "gender"]
    addresses = ['current_residence','current_village','current_ta','current_district','home_village','home_ta','home_district',]
    attributes = ['citizenship', 'race', 'occupation','home_phone_number', 'cell_phone_number']

    single_attributes.each do |comparison|
       if person_one[comparison] != person_two[comparison]
         puts "Different #{comparison}" #return false
       end
    end

    attributes.each do |comparison|
      if person_one['person_attributes'][comparison] != person_two['person_attributes'][comparison]
        puts "Different #{comparison}" #return false
      end
    end

    addresses.each do |comparison|
      if person_one['addresses'][comparison] != person_two['addresses'][comparison]
        puts "Different #{comparison}" #return false
      end
    end


  end

  def update_person(params)

    person = Person.last
    old_person = person.clone

    person.gender = params[:gender] unless params[:gender].blank?
    person.birthdate = params[:birthdate] unless params[:birthdate].blank?
    person.birthdate_estimated = params[:birthdate_estimated] unless params[:birthdate_estimated].blank?
    person.names.given_name = params[:given_name] unless params[:given_name].blank?
    person.names.family_name = params[:family_name] unless params[:family_name].blank?
    person.addresses.current_residence = params[:current_residence] unless params[:current_residence].blank?
    person.addresses.current_village = params[:current_village] unless params[:current_village].blank?
    person.addresses.current_district = params[:current_district] unless params[:current_district].blank?
    person.addresses.current_ta = params[:current_ta] unless params[:current_ta].blank?
    person.addresses.home_village = params[:home_village] unless params[:home_village].blank?
    person.addresses.home_ta = params[:home_ta] unless params[:home_ta].blank?
    person.addresses.home_district = params[:home_district] unless params[:home_district].blank?
    person.person_attributes.citizenship = params[:citizenship] unless params[:citizenship].blank?
    person.person_attributes.occupation = params[:occupation] unless params[:occupation].blank?
    person.person_attributes.home_phone_number = params[:home_phone_number] unless params[:home_phone_number].blank?
    person.person_attributes.cell_phone_number = params[:cell_phone_number] unless params[:cell_phone_number].blank?
    person.person_attributes.race = params[:race] unless params[:race].blank?


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
    print "Birthdate Estimated".ljust(20)
    print "#{person.birthdate_estimated}".ljust(20)
    print "#{old_person.birthdate_estimated}".ljust(20)
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
    print "Home District".ljust(20)
    print "#{person.addresses.home_district}".ljust(20)
    print "#{old_person.addresses.home_district}".ljust(20)
    puts
    print "Current District".ljust(20)
    print "#{person.addresses.current_district}".ljust(20)
    print "#{old_person.addresses.current_district}".ljust(20)
    puts
    puts
      return person.save
  end

  def create_person

  end
end