require 'csv'
require 'pry'


file = File.join(Rails.root, 'db', 'heroku_import', 'members.csv')
csv_text = File.read(file)
csv = CSV.parse(csv_text, :headers => true)

csv.each do |row|
  # pb with photos == "null"
  r = row.to_hash
  member = Member.new(r)
  member.save(validate: false)
end


file = File.join(Rails.root, 'db', 'heroku_import', 'events.csv')
csv_text = File.read(file)
csv = CSV.parse(csv_text, :headers => true)

csv.each do |row|
  # pb with photos == "null"
  r = row.to_hash
  r.delete("photos")
  event = Event.new(r)
  event.save(validate: false)
end
