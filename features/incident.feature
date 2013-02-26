Feature: Manage Incidents
In order to make an incident
As an Employee 
I want to create an incident

Scenario: Sign Up
	Given I am on home page
	When I go to Sign up page
	And I fill in "First name" with "Ahmed"
	And I fill in "Last name" with "Mohsen"
	And I fill in "Email" with "Ahmed7890@gmail.com"
	And I fill in "user_password" with "12345678"
	And I fill in "user_password_confirmation" with "12345678"
	And "I" press "Sign up"
	Then I should be at incidents index 

Scenario: Positive Incident Creation
    Given I have 2 users in the system
    And there exist 2 tags
    When user1 make positive incident related to user2
    Then user2 score should be increased by 5

Scenario: Negative Incident Creation
    Given I have 2 users in the system
    And there exist 2 tags
    When user1 make negative incident related to user2
    Then user2 score should be deacreased by 5


Scenario: Incident undo
    Given I have 2 users in the system
    And there exist 2 tags
    When user1 make negative incident related to user2
    And user1 undo incident
    Then user2 score should be the same

