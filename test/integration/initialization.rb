
#!/usr/bin/ruby
require 'test_helper'
require 'minitest/unit'

class IntegrationTest < MiniTest::Test

  def test_insert_site
    sites = [["Kamuzu Central Hospital", "Referral hospital in central region", "KCH"],
             ["Queen Elizabeth Central Hospital", "Referral hospital in southern region", "QCH"],
             ["Mzuzu Central Hospital", "Referral hospital in Northern region", "MCH"],
             ["Zomba Central Hospital", "Referral hospital in eastern region", "ZCH"]
    ]

    for site in sites do
      s = Site.new
      s.id = site[2]
      s.name = site[0]
      s.description = site[1]
      s.save
    end
    assert 4 == Site.count
  end

  def test_insert_ids
    id = ["HETTF0","HETTGH","HETTHE","HETTLD","HETTR9","HETTRU","HETTU1","HETTV8","HETTWD","HETTX0","HETU0A",
          "HETU8D","HETUA5","HETUAR","HETUDK","HETUEE","HETUKU","HETUU2","HETUV9","HETV27","HETV77","HETVAT",
          "HETVDX","HETVF2","HETVJY","HETVVV","HETW11","HETW1A","HETW28","HETW4L","HETW5H","HETWCE","HETWJM",
          "HETWLT","HETWU4","HETX7X","HETX8H","HETX8U","HETXNW","HETXRA","HETXUF","HETXUR","HETXYY","HETY06",
          "HETY5K","HETYEJ","HETYJ4","HEU007","HEU05L","HEU07C","HEU07M","HEU0AA","HEU0C8","HEU0F7","HEU0WK",
          "HEU0XG","HEU0Y3","HEU139","HEU17D","HEU1AC","HEU1LY","HEU1VF","HEU1W0","HEU20K","HEU27P","HEU2CX",
          "HEU2DH","HEU2GT","HEU2JV","HEU2KF","HEU2MH","HEU2RR","HEU2UK","HEU2VP","HEU33K","HEU34G","HEU3FL",
          "HEU3N5","HEU418","HEU43L","HEU44U","HEU4AF","HEU4LP","HEU4MK","HEU4R0","HEU4TR","HEU4V9","HEU50M",
          "HEU52G","HEU55R","HEU57H","HEU584","HEU5EF","HEU5KT","HEU5MJ","HEU60M","HEU64H","HEU6EP","HEU6JL",
          "HEU703","HEU727","HEU777","HEU7E7","HEU7EF","HEU7H6","HEU7KV","HEU7V0","HEU7Y9","HEU811","HEU82V",
          "HEU89D","HEU8F3","HEU8R2","HEU92W","HEU93E","HEU94Y","HEU95V","HEU98H","HEU9AK","HEU9N9","HEU9V2",
          "HEUA59","HEUA5K","HEUA71","HEUAJ4","HEUAK1","HEUAKY","HEUALJ","HEUANX","HEUAX5","HEUC07","HEUC4N",
          "HEUC8K","HEUC8W","HEUC96","HEUC9G","HEUCH1","HEUCKN","HEUCU7","HEUD2M","HEUDJ7","HEUDUV","HEUE3J",
          "HEUE4F","HEUE9J","HEUEAD","HEUED7","HEUEDH","HEUEHY","HEUEMU","HEUEP1","HEUEWY","HEUFG7","HEUG0A",
          "HEUG6W","HEUGAF","HEUGGV","HEUGYV","HEUH3Y","HEUH48","HEUH6X","HEUH7U","HEUHCD","HEUHJY","HEUHNR",
          "HEUHRU","HEUHV8","HEUJ3Y","HEUJG8","HEUJGV","HEUJK7","HEUJL4","HEUJNT","HEUJTF","HEUK9C","HEUKAG",
          "HEUKDX","HEUKEF","HEUKGW","HEUKLF","HEUKPP","HEUKW5","HEUL86","HEUL8G","HEULE9","HEULJM","HEULR2",
          "HEUM7L","HEUMAK","HEUMDD","HEUMNK","HEUMUF","HEUN0T","HEUN20","HEUN59","HEUNA0","HEUNHL","HEUNHV",
          "HEUNJ5","HEUNVD"]


    for i in id do
      w = Npid.new
      w.id = (id.index(i) + 1).to_s
      w.national_id = i.to_s
      w.site_code = ""
      w.assigned = false
      w.save
    end
    assert 200 == Npid.count
  end


end