Feature: Manage books
  In order to create book
  [stakeholder]
  wants created books from files
  
  Scenario: Register new book from fb2 file
    Given I am with new fb2 file
     And file not registered in db
    When I place fb2 in input catalog
     And start register script
    Then book must be created in db
     And book fields should be loaded from file
     And book must have unique fbguid
