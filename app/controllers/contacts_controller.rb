class ContactsController < ApplicationController

	def new
		@contact = Contact.new #create a new instance of the model contact.rb to pass to the view file for contacts
	end

	def create #This method is executed by the controller when form data is submitted, broswer requests this URL as destination
		@contact = Contact.new(secure_params) #create a new instance of the model but this pass it the attriburtes from params hash
		if @contact.valid?
			@contact.update_spreadsheet
			#TODO send message
			flash[:notice] = "Message sent from #{@contact.name}"
			redirect_to root_path
		else
			render :new
		end
	end

	private

	def secure_params #params hash has two methods associated with it for security purposes to prevent mass-assignment vulenerabilities
		params.require(:contact).permit(:name, :email, :content)
	end

end