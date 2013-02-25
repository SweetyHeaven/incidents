require 'capybara/cucumber'


Given /^I am on home page$/ do
  visit '/'
 end

Then /^I should be at incidents index$/ do
  current_path.should ==("/")
end


Given /^I am a logged in user$/ do
 
 	visit '/users/sign_in'
 	fill_in "user_email", :with => 'Ahmed7890@gmail.com'
    fill_in "user_password", :with => '12345678'
 	click_button 'Sign in'
 	@user = User.find_by_email('Ahmed7890@gmail.com')
end


Given /^I am on the list of incidents$/ do
 visit '/incidents'
end


When /^I follow "(.*?)"$/ do |link|
  visit  new_incident_path
end

When /^I fill in "(.*?)" with "(.*?)"$/ do |feild, value|
  fill_in feild , :with => value
end

When /^I press "(.*?)"$/ do |button|
  click_button button
end

Then /^I should see "(.*?)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

When /^I go to Sign up page$/ do
  visit '/users/sign_up'
end

Given /^I have (\d+) users in the system$/ do |number_of_users|
  #creating 2 dummy users
  @user1 = User.create(:first_name => "user1", :last_name => "user", :email => "u1@u.com",:password => "12345678")
  @user2 = User.create(:first_name => "user2", :last_name => "user", :email => "u2@u.com",:password => "12345678")
end

When /^user(\d+) make positive incident related to user(\d+)$/ do |user1_id, user2_id|
 @old_score = @user2.score
 #make incident
 positive_incident = Incident.create(:assigned_to_id => 2 , :creator_id => 1)
 @user2 = positive_incident.assigned_to
 @new_score = @user2.score
 end

 When /^user(\d+) make negative incident related to user(\d+)$/ do |user1_id, user2_id|
 @old_score = @user2.score
 #make incident
 negative_incident = Incident.create(:assigned_to_id => 2 , :creator_id => 1 , :incident_type => -1)
 @user2 = negative_incident.assigned_to
 @new_score = @user2.score
 puts @new_score
 end

Then /^user(\d+) score should be increased by (\d+)$/ do |user2_id, score_icrease|
  #assert that 5 points have been added to user2
  @old_score += 5
  (@old_score).should == @new_score  
end

Then /^user(\d+) score should be deacreased by (\d+)$/ do |user2_id, score_icrease|
  #assert that 5 points have been added to user2
  @old_score -= 5
  (@old_score).should == @new_score  
end
