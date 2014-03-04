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

	def update_spreadsheet
		connection = GoogleDrive.login(ENV["GMAIL_USERNAME"], ENV["GMAIL_PASSWORD"])
		#connect to GoogleDrive using login method, and passing the method the Environmental variables set in config/application.yml
		ss = connection.spreadsheet_by_title('Learn-Rails-Example') #Look for a spreadsheet in GoogleDrive that already exists
		if ss.nil?
			ss = connection.create_spreadsheet('Learn-Rails-Example') #if one doesn't exist, create one
		end
		ws = ss.worksheets[0] #spreadsheet contains multiple worksheets (ws), tell GoogleDrive to use the first one
		last_row = 1 + ws.num_rows #To retrieve the last empty row, need to add 1 to the number of rows (which is currently zero)
		ws[last_row, 1] = Time.new #append cells in the speadsheet by accessing [row_number, column_number]
		ws[last_row, 2] = self.name #Add name, email and content to the ws,
		ws[last_row, 3] = self.email #refer to current instance of the class Contact by using self
		ws[last_row, 4] = self.content
		ws.save #save the data to the worksheet
	end

end