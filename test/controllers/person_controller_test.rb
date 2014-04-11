#!/usr/bin/ruby

require 'minitest/unit'

class PersonControllerTest < MiniTest::Test

  def test_assign_to_site
    npids = Npid.unassigned_to_site.limit(20)

    (npids || []).each
  end

  def test_insert_person

  end

end