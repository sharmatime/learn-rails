class Visitor < ActiveRecord::Base #inherit behaviour from the ActiveRecord module, Base class
	has_no_table #use activerecord_tableless gem to turn off ActiveRecord database functions
	column :email, :string 
	validates_presence_of :email
	validates_format_of :email, :with => /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i

	def subscribe
		#method connects to MailChimp server to add visitor to the mailing list. Method will be called by VisitorsController
		mchimp_connection = Gibbon::API.new #create a new instance of the Gibbon object, which provides all the connectivity
		#The gibbon gem automatically looks in the ENV variable for the MAILCHIMP_API_KEY 
		#below, assign result to our instance of Gibbon, tag with methods .list.subscribe, which takes five parameters
		result = mchimp_connection.lists.subscribe({
			:id => ENV['MAILCHIMP_LIST_ID'], #ENV variable to identify MailChimp list
			:email => {:email => self.email}, #email address of the visitor (inside a hash)
			:double_optin => false, #setting true sends a double-opt-in comfirmation message
			:update_existing => true, #updates a subscriber record if they already exist
			:send_welcome => true #sends a "Welcome Email" to the new subscriber
			#more parameters in MailChimp API
		})
		#If application sucessfully adds a new subscriber, we write a message to the logger.
		#If we get an error when trying to add the subscriber Gibbon raises an exception 
		Rails.logger.info("Subscribed #{self.email} to MailChimp") if result
	end
end