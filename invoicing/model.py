"""
Invoicing Model module

This contains all the class definitions necessary to persist Invoice data.

:Classes:
  Invoice

  User

  Group

  InvoiceLine

  Product

  Client

  Company

  ClientGroup

  VATRate

  Visit

  VisitIdentity
"""

from datetime import datetime
from datetime import date
from turbogears.database import metadata, session
import pkg_resources
pkg_resources.require("SQLAlchemy>=0.3.10")
pkg_resources.require("Elixir>=0.4.0")
# import the basic Elixir classes and functions for declaring the data model
# (see http://elixir.ematia.de/trac/wiki/TutorialDivingIn)
from elixir import Entity, Field, OneToMany, ManyToOne, ManyToMany, ColumnProperty, OneToOne
from elixir import options_defaults, using_options, setup_all
# import some datatypes for table columns from Elixir
# (see http://www.sqlalchemy.org/docs/04/types.html for more)
from elixir import String, Unicode, Integer, DateTime, Numeric, using_table_options
from turbogears import identity
from sqlalchemy.sql.expression import func, and_
from sqlalchemy import UniqueConstraint
from invoicing.model_types import Enum

options_defaults['autosetup'] = False

class Invoice(Entity):
    """
    Invoice object - contains all info relevant to an invoice
    """
    using_options(tablename="invoice")
    ident = Field(String, unique=True)
    created = Field(DateTime, default=datetime.now)
    date = Field(DateTime, nullable=False)
    date_sent = Field(DateTime)
    paid = Field(DateTime, default=None)
    terms = Field(String, default="30 days")
    status = Field(Enum(["Proforma","Invoice","Cancelled"]))
    client = ManyToOne('Client') # and OneToMany('Invoice') in Client class
    vat_rate = Field(Numeric(precision=3, scale=1)) # scale?
    vat = Field(Numeric)
    next_invoice = OneToOne('Invoice', inverse='previous_invoice')
    previous_invoice = ManyToOne('Invoice', inverse='next_invoice')
    products = OneToMany('InvoiceLine')

    def __repr__(self):
        return "%s: date: %s for client: %s" % (self.ident, self.invoice_date, self.client.name)

    @property
    def created_date(self):
        return self.created.strftime("%d/%m/%Y")

    @property
    def invoice_date(self):
        return self.date.strftime("%d/%m/%Y")

    @property
    def hasPrevious(self):
        return self.previous_invoice != None

    @property
    def hasNext(self):
        return self.next_invoice != None

    @property
    def number_of_lines(self):
        return len(products)

    @property
    def product_quantity(self):
        num = 0
        for line in self.products:
            num += line.quantity
        return num

    @property
    def total(self):
        total = 0.0
        for line in self.products:
            total += line.total
        return total

    @property
    def vat(self):
        vat = self.total * float(self.vat_rate)
        return vat

    @property
    def net_total(self):
        return self.vat + self.total

    def add_product(self, product=None, quantity=0, price=0.0):
        invoice_line = InvoiceLine(invoice=self,
                                   product=product,
                                   price=price,
                                   quantity=quantity)
        self.products.append(invoice_line)
        self.flush()

class InvoiceLine(Entity):
    invoice = ManyToOne('Invoice')
    product = ManyToOne('Product')
    price = Field(Numeric)
    quantity = Field(Integer, default=1)
    total = ColumnProperty(lambda c: c.quantity * c.price)
    using_table_options(UniqueConstraint('invoice_id', 'product_id'))
    using_options(tablename="invoice_line")

    @property
    def vat(self):
        return self.invoice.vat_rate.vat_rate * self.total

class Client(Entity):
    using_options(tablename="client")
    name = Field(String, unique=True)
    abbreveated = Field(String(2), unique=True)
    billing_person = Field(Unicode)
    phone_number = Field(Unicode)
    address = Field(Unicode)
    country = Field(Unicode)
    vat_number = Field(String)
    email_address = Field(Unicode(255), unique=True)
    invoices = OneToMany('Invoice')
    group = ManyToOne('ClientGroup')
    full_address = ColumnProperty(lambda c: c.name + c.abbreveated)

    @property
    def invoices_this_year(self):
        from_date = date(datetime.today().year, 1, 1)
        print from_date
        to_date = date(datetime.today().year+1, 1, 1)
        print to_date
        return Invoice.query.filter(and_(
                                    Invoice.client == self,
                                    Invoice.created >= from_date,
                                    Invoice.created < to_date))

    @property
    def next_invoice_ident(self):
        num = self.invoices_this_year.count() + 1
        return self.abbreveated + str(datetime.today().year) + '-' + "%02i" % num

class Product(Entity):
    using_options(tablename="product")
    name = Field(Unicode, unique=True)
    price = Field(Numeric)
    details = Field(Unicode)
    invoice_lines = OneToMany('InvoiceLine')
    parent = ManyToOne('Product', inverse='children')
    children = OneToMany('Product', inverse='parent')

class VATRate(Entity):
    using_options(tablename="vat_rate")
    name = Field(String, default="Standard Rate")
    vat_rate = Field(Numeric(precision=3, scale=1), default=0.175)
    effective_from = Field(DateTime, default=date(1970,1,1),unique=True)
    effective_to = Field(DateTime, default=date(2999,12,1))

    def getVATRate(self, date):
        rate = VATRate.query.filter(and_(VATRate.effective_from <= date, VATRate.effective_to >= date)).one()
        return rate
    get_vat_rate = classmethod(getVATRate)

class Company(Entity):
    using_options(tablename="company")
    name = Field(Unicode, unique=True)
    logo = Field(String)
    phone_number = Field(Unicode)
    email_address = Field(Unicode, unique=True)
    url = Field(String, default=None)
    address = Field(Unicode)
    vat_number = Field(String)
    users = OneToMany('User')
    client_groups = OneToMany('ClientGroup')

class ClientGroup(Entity):
    using_options(tablename="client_group")
    name = Field(Unicode, unique=True)
    company = ManyToOne('Company')
    clients = OneToMany('Client')

    def getClientGroups(self):
        return ClientGroup.query()
    all_client_groups = classmethod(getClientGroups)

class Visit(Entity):
    """
    A visit to your site
    """
    using_options(tablename='visit')

    visit_key = Field(String(40), primary_key=True)
    created = Field(DateTime, nullable=False, default=datetime.now)
    expiry = Field(DateTime)

    def lookup_visit(cls, visit_key):
        return Visit.get(visit_key)
    lookup_visit = classmethod(lookup_visit)


class VisitIdentity(Entity):
    """
    A Visit that is link to a User object
    """
    using_options(tablename='visit_identity')

    visit_key = Field(String(40), primary_key=True)
    user = ManyToOne('User', colname='user_id', use_alter=True)


class Group(Entity):
    """
    An ultra-simple group definition.
    """
    using_options(tablename='tg_group')

    group_id = Field(Integer, primary_key=True)
    group_name = Field(Unicode(16), unique=True)
    display_name = Field(Unicode(255))
    created = Field(DateTime, default=datetime.now)
    users = ManyToMany('User', tablename='user_group')
    permissions = ManyToMany('Permission', tablename='group_permission')


class User(Entity):
    """
    Reasonably basic User definition.
    Probably would want additional attributes.
    """
    using_options(tablename='tg_user')

    user_id = Field(Integer, primary_key=True)
    user_name = Field(Unicode(16), unique=True)
    email_address = Field(Unicode(255), unique=True)
    display_name = Field(Unicode(255))
    password = Field(Unicode(40))
    created = Field(DateTime, default=datetime.now)
    groups = ManyToMany('Group', tablename='user_group')

    def permissions(self):
        p = set()
        for g in self.groups:
            p |= set(g.permissions)
        return p
    permissions = property(permissions)

    company = ManyToOne('Company')

    def __repr__(self):
        return "ID: %i User: %s Display: %s Email: %s Company: %s" % (self.user_id, self.user_name, self.display_name, self.email_address, self.company.name)

class Permission(Entity):
    """
    A relationship that determines what each Group can do
    """
    using_options(tablename='permission')

    permission_id = Field(Integer, primary_key=True)
    permission_name = Field(Unicode(16), unique=True)
    description = Field(Unicode(255))
    groups = ManyToMany('Group', tablename='group_permission')


# Set up all Elixir entities declared above

setup_all()
