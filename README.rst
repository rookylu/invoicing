Invoicing
=========

`Source code <http://github.com/wjlroe/invoicing/tree>`_ 

`Bugs/Issues <http://code.google.com/p/tg-invoicing/issues/list>`_

`Project/API documentation <http://wjlr.org.uk/projects/tg-invoicing/>`_  


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
* Groups of clients - "External web development" (optional) - done.


Invoices
--------

* Assigned to a client
* Contain products with prices
* VAT summary
* Standard configurable template (in standard markup - e.g. reStructuredText etc.)
* Invoice date (different from created date)

Users
-----

* Authenticate with IMAP server (future with LDAP) - done.
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
* Off-page accordion menu thing - done
* Company logo in the header - done
* IMAP login - done
* Associated table for invoice lines - (product, price, quantity) - done
 
Funtionality to add
-------------------

* Add invoice form / Edit invoice
* Add company form / Edit company
* Add user form / Edit user
* Add client form / Edit client
* Add product parent (hierarchy of products) (e.g. "Hosting" -> "Hosting for www.example.com")
* Link with invoice generator (PDF export)
* Paginate all tablulated data
* All tables sortable