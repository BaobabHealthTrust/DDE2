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
    new_person.birthdate = "1963-04-30".to_date
    if new_person.save
      w.assigned = true
      w.save
    end

    assert Person.find(new_person.id)
  end

  def test_update_person

  end
end