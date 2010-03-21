Feature: 1.1 Invoices
  As a company
  I would like to be able to bill my clients
  So that I get paid

  Scenario Outline: 1.1.1 Create invoice
    Given the scene one company and one client
    When I go to the invoice new page
    And I fill in "Ident" with "<ident>"
    And I select "<client>" from "Client"
    And I select "2008-05-04" as the date
    And I press "Create"
    Then show me the page
    Then I should see "Invoice successfully created"

  Examples:
    | ident   | client         |
    | WOOT001 | Example Client |
