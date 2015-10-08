# create 1000 ids
j = 1
(1..1000).collect{|n| n}.shuffle.each do |i|
    id = NationalPatientId.new(i).to_s.gsub(/\-/, "")
    Npid.find_by__id((j + 1).to_s).destroy rescue nil
    n = Npid.create(incremental_id: j, national_id: id, site_code: CONFIG["sitecode"], assigned: false, region: CONFIG["region"]) rescue nil
    j += 1
    puts "National ID number: #{j - 1} value: #{n.national_id}" unless n.blank?
end
    
# create site
s = Site.find(CONFIG["sitecode"])
unless s.blank?
    s.destroy
end
s = Site.new
s.site_code = CONFIG["sitecode"]
s.name = "My Local Site"
s.region = CONFIG["region"]
s.save!

puts "succesfully created #{s.name}"
