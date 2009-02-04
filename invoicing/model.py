from datetime import datetime
from datetime import date
import pkg_resources
pkg_resources.require("SQLAlchemy>=0.3.10")
pkg_resources.require("Elixir>=0.4.0")
# import the basic Elixir classes and functions for declaring the data model
# (see http://elixir.ematia.de/trac/wiki/TutorialDivingIn)
from elixir import Entity, Field, OneToMany, ManyToOne, ManyToMany, ColumnProperty
from elixir import options_defaults, using_options, setup_all
# import some datatypes for table columns from Elixir
# (see http://www.sqlalchemy.org/docs/04/types.html for more)
from elixir import String, Unicode, Integer, DateTime, Numeric
from turbogears import identity

options_defaults['autosetup'] = False

class Invoice(Entity):
    ident = Field(String, unique=True) # unique?
    created = Field(DateTime, default=datetime.now)
    paid = Field(DateTime, default=None)
    terms = Field(String, default="30 days")
    #status = Field # Don't know about Enum yet, might have to use own type
    client = ManyToOne('Client') # and OneToMany('Invoice') in Client class
    vat_rate = Field(Numeric(precision=3, scale=1)) # scale?
    vat = Field(Numeric)

    products = ManyToMany('Product')

class Client(Entity):
    name = Field(String, unique=True)
    abreveated = Field(String(2), unique=True)
    address = Field(Unicode)
    country = Field(Unicode)
    vat_number = Field(String)
    invoices = OneToMany('Invoice')
    group = ManyToOne('ClientGroup')
    number_invoices = ColumnProperty(select([func.count(invoices if invoice.created.year==datetime.today().year]))
    #next_invoice_ident = ColumnProperty(lambda c: c.abreveated + '-' + datetime.now().strftime("%Y") + '-' + str(c.number_invoices))

class Product(Entity):
    name = Field(Unicode, unique=True)
    price = Field(Numeric)
    invoices = ManyToMany('Invoice')
    

class VATRate(Entity):
    name = Field(String, default="Standard Rate")
    vat_rate = Field(Numeric(precision=3, scale=1), default=1.175)
    effective_from = Field(DateTime, default=date(1970,1,1),unique=True)
    effective_to = Field(DateTime, default=date(2999,12,1))

class Company(Entity):
    name = Field(Unicode, unique=True)
    logo = Field(String)
    address = Field(Unicode)
    vat_number = Field(String)
    users = OneToMany('User')
    client_groups = OneToMany('ClientGroup')

class ClientGroup(Entity):
    name = Field(Unicode, unique=True)
    company = ManyToOne('Company')
    clients = OneToMany('Client')

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
