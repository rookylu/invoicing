Invoicing
=========

First class objects
-------------------

* Invoices
* Clients
* Products
* Users
* Companies

Second level objects
~~~~~~~~~~~~~~~~~~~~

* Proforma (optional) - converts to an invoice
* Recurring product (e.g. hosting) - set recurrance interval (monthly, by-monthly, yearly)
* Groups of clients - "External web development" (optional)


Invoices
--------

* Assigned to a client
* Contain products with prices
* VAT summary
* Standard configurable template (in standard markup - e.g. reStructuredText etc.)
* Invoice date (different from created date)

Users
-----

* Authenticate with IMAP server (future with LDAP)
* Email address
* Assigned to a company

Companies
---------

* Assigned employees
* Company logo (on invoice template)
* Company name
* Company address
* Company VAT number (required)

Improve...
----------

* Widgets for commonly occuring displayed data
* Off-page accordion menu thing
* Company logo in the header
* IMAP login
* Associated table for invoice lines - (product, price, quantity)
 
