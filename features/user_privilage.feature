Feature: User Privilage
In order to view nagative incidents
As a User 
I need to have Manager role

Scenario: Manager view incidents
    Given I have 2 users in the system
    And I have 1 manager in the system
    And there exist 2 tags
    When user1 make positive incident related to user2
    And user2 make negative incident related to user1
    And manager sign_in
    And "manager" go to "/"
    Then negative incident should appear

Scenario: Employee view incidents
    Given I have 2 users in the system
    And I have 1 manager in the system
    And there exist 2 tags
    When user1 make positive incident related to user2
    And user2 make negative incident related to user1
    And employee sign_in
    And "employee" go to "/"
    Then negative incident should not appear

Scenario: Manager view users
    Given I have 2 users in the system
    And I have 1 manager in the system
    When manager sign_in
    And "manager" press "Users" link
    Then users index should appear


Scenario: Manager view tags
    Given I have 1 manager in the system
    When manager sign_in
    And "manager" go to "/tags"
    Then tags index should appear


Scenario: Manager show incident
    Given I have 2 users in the system
    And I have 1 manager in the system
    And there exist 2 tags
    When user1 make positive incident related to user2
    And manager sign_in
    And "manager" go to "/"
    And "manager" press "Show"
    And "manager" press "tag1" link
    Then tag1 show page should appear    