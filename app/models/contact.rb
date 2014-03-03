class Contact < ActiveRecord::Base #name our model "Contact" and have it inherit from the ActiveRecord clas
	has_no_table #disable the database features of ActiveRecord using activerecord-tableless gem

	#specify attributes (data fields) for the model by using the column keyword from the activerecord-tableless gem
	#These match fields in the contact form view file.
	column :name, :string
	column :email, :string
	column :content, :string

	#Check that name, email and content exist (NO blanks are allowed)
	validates_presence_of :name
	validates_presence_of :email
	validates_presence_of :content
	#provide a complex regex to test if the email address is valid. 
	validates_format_of :email,
		:with => /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i
	#Declare a the message content cannot exceed 500 characters 
	validates_length_of :content, :maximum => 500 
end