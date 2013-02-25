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
 positive_incident = Incident.create(:assigned_to_id => user2_id.to_i , :creator_id => user1_id.to_i , :info => "I am a positive incident")
 @user2 = positive_incident.assigned_to
 @new_score = @user2.score
 end

 When /^user(\d+) make negative incident related to user(\d+)$/ do |user1_id, user2_id|
 @old_score = @user2.score
 #make incident
 negative_incident = Incident.create(:assigned_to_id => 2 , :creator_id => 1 , :incident_type => -1, :info => "I am a negative incident")
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

Given /^I have (\d+) manager in the system$/ do |arg1|
  @manager = User.create(:first_name => "manager1", :last_name => "manager", :email => "m1@u.com",:password => "12345678" , :role => "Manager")
end

When /^"(.*?)" go to "(.*?)"$/ do |user, page_url|
  visit page_url
end

Then /^negative incident should appear$/ do
 table = page.all("#incidentsTable").map(&:text)
 table.should have_content "negative"
end

When /^manager sign_in$/ do
  visit '/users/sign_in'
  fill_in "user_email", :with => @manager.email
  fill_in "user_password", :with => '12345678'
  click_button 'Sign in'
end

When /^employee sign_in$/ do
  visit '/users/sign_in'
  fill_in "user_email", :with => @user1.email
  fill_in "user_password", :with => '12345678'
  click_button 'Sign in'
end

Then /^negative incident should not appear$/ do
 table = page.all("#incidentsTable").map(&:text)
 table.should_not have_content "negative"
end
