class VisitorsController <ApplicationController

	def new
		@visitor = Visitor.new
	end

	def create
		@visitor = Visitor.new(secure_params)
		if @visitor.valid?
			#if the validation requirements are met in Vistors model, we subscribe @visitor.email to MailChimp list
			@visitor.subscribe
			flash[:notice] = "Signed up #{@visitor.email}."
			redirect_to root_path
		else
			render :new
		end
	end

	private

	def secure_params
		#Method to protect against mass assignment vulnerabilities
		#Recall params is a hash, it requires a :visitor key and will only permit an email parameter
		params.require(:visitor).permit(:email)
	end
end