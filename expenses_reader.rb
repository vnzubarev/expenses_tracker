require 'rexml/document' # xml parser
require 'date'           # we will use operations with date

current_path = File.dirname(__FILE__)
file_name = current_path + '/my_expenses.xml'

abort 'Cant find your file, try again please' unless File.exist?(file_name)

# file open
file = File.new(file_name)
# creating parser object
doc = REXML::Document.new(file)

amount_by_day = {}

# loop through all elements of the xml tree along the path (xPath)
doc.elements.each('expenses/expense') do |item|
  # how much we spend
  loss_sum = item.attributes['amount'].to_i
  # date of spend
  loss_date = Date.parse(item.attributes['date'])
  # conditional assignment "expression || = value",
  # if the expression is empty, then assign it a value
  amount_by_day[loss_date] ||= 0
  amount_by_day[loss_date] += loss_sum
end
file.close

# month spend hash
sum_by_month = {}

# current month pointer
current_month = amount_by_day.keys.min.strftime('%B %Y')

amount_by_day.keys.sort.each do |key|
  sum_by_month[key.strftime('%B %Y')] ||= 0
  sum_by_month[key.strftime('%B %Y')] += amount_by_day[key]
end

puts "---[ #{current_month}, whole spend: $#{sum_by_month[current_month]}]---"

amount_by_day.keys.sort.each do |key|
  if key.strftime('%B %Y') != current_month
    current_month = key.strftime('%B %Y')
    puts "---[ #{current_month}, whole spend: $#{sum_by_month[current_month]}]---"
  end
  puts "\t#{key.day}: $#{amount_by_day[key]}"
end
