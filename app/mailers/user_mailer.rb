class UserMailer < ActionMailer::Base #UserMailer inherits behaviour from the ActionMailer parent class. 
  default from: "do-not-reply@example.com" #defualt for all messages that do not set a "from" address

  def contact_email(contact) #method definition that assigns the contact arguement to the instance variable @contact
  	@contact = contact #in this case an instance of @contact with attributes will already be defined by the ContactsController
  	#Like a controller that combines a model with a view, our mailer class makes the instance variable available in the view
  	mail(to: ENV["OWNER_EMAIL"], from: @contact.email, :subject => "Blog reader #{@contact.name} has a message for you")
  	#Call this method in ContactsController to trigger email delivery
  end
end
