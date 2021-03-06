Feature: User checks inbox
  In order to view my received and sent messages
  As a user
  I want to be able to go to my inbox and view my messages
  
  @javascript
  Scenario: Viewing messages
    Given there are following users:
      | person | 
      | kassi_testperson1 |
      | kassi_testperson2 |
    And there is favor request with title "Massage" from "kassi_testperson1"
    And there is a message "Test message" from "kassi_testperson2" about that listing
    And I am logged in as "kassi_testperson1"
    When I follow "inbox-link"
    Then I should see "Massage" within ".inbox-feed"
    And I should see "Messages" within ".selected"
    And I should see "Notifications" within ".left-navi"
    And I should not see "Notifications" within ".selected"
    And I should see "Test message" within ".inbox-feed"
  
  @javascript
  Scenario: Viewing a single conversation
    Given there are following users:
      | person | 
      | kassi_testperson1 |
      | kassi_testperson2 |
    And there is favor request with title "Massage" from "kassi_testperson1"
    And there is a message "Test message" from "kassi_testperson2" about that listing
    And I am logged in as "kassi_testperson1"
    When I follow "inbox-link"
    And I follow "conversation_title_link_1"
    Then I should see "Test message" within "h2"

  @javascript
  Scenario: Viewing received messages when there are multiple messages from different senders
    Given there are following users:
      | person | 
      | kassi_testperson1 |
      | kassi_testperson2 |
      | kassi_testperson3 |
    And there is favor request with title "Massage" from "kassi_testperson1"
    And there is a message "Reply to massage" from "kassi_testperson2" about that listing
    And there is a message "Another test" from "kassi_testperson3" about that listing
    And there is a reply "great" to that message by "kassi_testperson1"
    And there is housing offer with title "Apartment" from "kassi_testperson2" and with share type "sell"
    And there is a message "Test1" from "kassi_testperson3" about that listing
    And there is item offer with title "Hammer" from "kassi_testperson2" and with share type "lend"
    And there is a message "Test2" from "kassi_testperson1" about that listing
    And there is rideshare offer from "Helsinki" to "Turku" by "kassi_testperson2"
    And there is a message "Test3" from "kassi_testperson1" about that listing
    And there is a reply "Fine" to that message by "kassi_testperson2"
    And I am logged in as "kassi_testperson1"
    When I follow "inbox-link"
    Then I should see "Reply to massage"
    And I should see "Massage"
    And I should see "Another test"
    And I should see "great"
    And I should not see "Test1"
    And I should see "Test2"
    And I should see "Helsinki - Turku" 
    And I should see "Fine"
    And I should see "3" within ".inbox-toggle"
    And I follow "Fine"
    And I follow "inbox-link"
    And I should not see "Fine" within ".unread"
    And I should see "2" within ".inbox-toggle"  
  
  @javascript
  Scenario: Viewing sent messages when there are multiple messages from different senders
    Given there are following users:
      | person | 
      | kassi_testperson1 |
      | kassi_testperson2 |
      | kassi_testperson3 |
    And there is favor request with title "Massage" from "kassi_testperson1"
    And there is a message "Reply to massage" from "kassi_testperson2" about that listing
    And there is a message "Another test" from "kassi_testperson3" about that listing
    And there is a reply "Ok" to that message by "kassi_testperson1"
    And there is housing offer with title "Apartment" from "kassi_testperson2" and with share type "sell"
    And there is a message "Test1" from "kassi_testperson3" about that listing
    And there is item offer with title "Hammer" from "kassi_testperson2" and with share type "lend"
    And there is a message "Test2" from "kassi_testperson1" about that listing
    And there is rideshare offer from "Helsinki" to "Turku" by "kassi_testperson2"
    And there is a message "Test3" from "kassi_testperson1" about that listing
    And there is a reply "Fine" to that message by "kassi_testperson2"
    And I am logged in as "kassi_testperson1"
    When I follow "inbox-link"
    Then I should see "Ok"
    And I should see "Massage"
    And I should see "Another test"
    And I should not see "Test1"
    And I should see "Test2"
    And I should see "Hammer"
    And I should see "Helsinki - Turku"
    And I should see "Fine"
  
  @javascript
  Scenario: Trying to view inbox without logging in
    Given there are following users:
      | person | 
      | kassi_testperson1 |
    And I am not logged in
    When I try to go to inbox of "kassi_testperson1"
    Then I should see "You must log in to Sharetribe to view your inbox." within ".flash-notifications"
    And I should see "Log in to Sharetribe" within "h2"
  
  @javascript
  Scenario: Trying to view somebody else's inbox
    Given there are following users:
      | person | 
      | kassi_testperson1 |
      | kassi_testperson2 |
    And I am logged in as "kassi_testperson2"
    When I try to go to inbox of "kassi_testperson1"
    Then I should see "You are not authorized to view this content" within ".flash-notifications"
  
  @javascript
  Scenario: Trying to view somebody else's single conversation
    Given there are following users:
      | person | 
      | kassi_testperson1 |
      | kassi_testperson2 |
      | kassi_testperson3 |
    And there is favor request with title "Massage" from "kassi_testperson2"
    And there is a message "Reply to massage" from "kassi_testperson3" about that listing
    And I am logged in as "kassi_testperson1"
    When I go to the conversation path of "kassi_testperson1"
    Then I should see "You are not authorized to view this content" within ".flash-notifications"  