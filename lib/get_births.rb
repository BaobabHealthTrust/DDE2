def get_births
	puts 'yayambika'
	i = 0
	people  = Person.all
	jan_start = "01-Jan-2017".to_date
	jan_end = jan_start.end_of_month
	jan_dates  = (jan_start..jan_end).to_a
	
	jan_people = []
	people.each do |person|
		next if person.birthdate.blank?
		birthdate = person.birthdate.to_date
		if jan_dates.include?(birthdate)
			jan_people << person
		end
		i += 1
		puts i
	end
	
	jan_people.each.count
end

get_births

# jan_people.each do |person|
#
# end
