require 'rexml/document' # xml parser
require 'date'           # we will use operations with date

puts 'Money spent on: '
expense_text = STDIN.gets.chomp

puts 'Amount: '
expense_amount = STDIN.gets.chomp.to_i

puts 'Spent date in a format 29.10.2018 (today, if empty): '
date_input = STDIN.gets.chomp

# expense_date = nil

expense_date = if date_input.empty?
                 Date.today
               else
                 Date.parse(date_input)
               end

puts 'Category: '
expense_category = STDIN.gets.chomp.downcase

current_path = File.dirname(__FILE__)
file_name = current_path + '/my_expenses.xml'

# file open with read flag encoding in UTF-8
file = File.new(file_name, 'r:UTF-8')
# creating parser object
begin
  doc = REXML::Document.new(file)
rescue REXML::ParseException => error
  puts 'XML file crash, check it, please'
  abort error.message
end
file.close
# save expanses root tag in a variable
expenses = doc.elements.find('expenses').first

expense = expenses.add_element 'expense', {
  'amount' => expense_amount,
  'category' => expense_category,
  'date' => expense_date.to_s
}
expense.text = expense_text
# file open with write flag encoding in UTF-8
file = File.new(file_name, 'w:UTF-8')
doc.write(file, 2)
file.close

puts 'Successfully saved'
