class UserMailer < ActionMailer::Base
  default from: "sweety.heaven.incident@gmail.com"

  #sends a mail to a user when a new related incident
  #is added to the system
  def incident_notification(incident)
  	@incident = incident
    @user = incident.assigned_to
    @url  = incident_url(incident)
    mail(:to => @user.email, :subject => "You have a new Incident!");
  end

  #sends a broadcast mail to all usera in the system when a new incident
  #is created
  def incident_broadcast(incident)
  	@incident = incident
    @url  = incident_url(incident)

    #get all users emails except the related user email
    @user_mails = User.where("id != ?", @incident.assigned_to.id).map {|user| user.email}

    mail(:to => @user_mails, :subject => "New Incident!");
  end

  def negative_incident_notification(incident)
  	@incident = incident
    @user = incident.assigned_to
    @url  = incident_url(incident)

    #get managers mails
 	  @manager_mails = User.where("role = 'Manager'").map{|user| user.email}   

    mail(:to => @manager_mails, :subject => "A Negative Incident is added!");
  end  

 
end
