import turbogears as tg
from turbogears import controllers, expose, flash
from turbogears import identity, redirect
from turbogears.database import session
from turbogears.widgets import DataGrid
from cherrypy import request, response
from invoicing import json
import logging
log = logging.getLogger("invoicing.controllers")
from invoicing import model
from invoicing.widgets import *
from kid import XML

class Root(controllers.RootController):

    def company_logo(self, company):
        logo = "<img src=\"/static/images/companies/%s\" />" % company.logo
        return XML(logo)

    def company_users(self, company):
        user_line = []
        #users = model.Company.select(company.id).throughTo.users
        for user in company.users:
            #log.debug("company_users: ", user)
            user_line.append("<a href=\"/user/%i\">%s</a>" % (user.user_id, user.display_name))
        user_line = "<br />".join(user_line)
        return XML(user_line)

    def print_invoices(self, parent):
        invoices = []
        for invoice in parent.invoices:
            invoices.append("<a href=\"/invoice/%i\">%s</a>" % (invoice.id, invoice.ident))
        invoices = "<br />".join(invoices)
        return XML(invoices)

    def print_products(self, parent):
        products = "<br />".join(["<a href=\"/product/%s\">%s</a>" % (product.id, product.name) for product in parent.products])
        return XML(products)

    def group_users(self, group):
        users = []
        for user in group.users:
            users.append("<a href=\"/user/%i\">%s</a>" % (user.user_id, user.display_name))
        users = "<br />".join(users)
        return XML(users)

    def __init__(self):
        self.vat_rates_table = DataGrid(fields=[
            ('Name', 'name'),
            ('VAT Rate', 'vat_rate'),
            ('Effective From', 'effective_from'),
            ('Effective To', 'effective_to')
            ])
        
        self.company_table = DataGrid(fields=[
            ('Name','name'),
            ('Logo', self.company_logo),
            ('Address', 'address'),
            ('VAT number', 'vat_number'),
            ('Users', self.company_users)
            ])

        self.user_table = DataGrid(fields=[
            ('UserName', 'user_name'),
            ('Name', 'display_name'),
            ('Email', 'email_address'),
            ('Created', 'created'),
            ('Company', 'company.name')
            ])

        self.group_table = DataGrid(fields=[
            ('Name', 'display_name'),
            ('Created', 'created'),
            ('Users', self.group_users)
            ])

        self.client_table = DataGrid(fields=[
            ('Name', 'name'),
            ('Address', 'address'),
            ('Country', 'country'),
            ('VAT number', 'vat_number'),
            ('Invoices', self.print_invoices),
            ('Next Ident', 'next_invoice_ident'),
            ('Group', 'group.name')
            ])

        self.product_table = DataGrid(fields=[
            ('Name', 'name'),
            ('Price', 'price'),
            ('Invoices', self.print_invoices)
            ])

        self.invoice_table = DataGrid(fields=[
            ('Ident', 'ident'),
            ('Client', 'client.name'),
            ('Status', 'status'),
            ('Created on', 'created'),
            ('Date', 'date'),
            ('Paid on', 'paid'),
            ('Products', self.print_products)
            ])
    
    @expose(template="invoicing.templates.welcome")
    # @identity.require(identity.in_group("admin"))
    def index(self):
        rates=self.vat_rates_table.display(session.query(model.VATRate))
        companies=self.company_table.display(session.query(model.Company))
        users=self.user_table.display(session.query(model.User))
        groups=self.group_table.display(session.query(model.Group))
        clients=self.client_table.display(session.query(model.Client))
        products=self.product_table.display(session.query(model.Product))
        invoices=self.invoice_table.display(session.query(model.Invoice))
        #client_form=ClientFields(session.query(model.ClientGroup))
        client_form = forms.TableForm(
            #fields=ClientFields(session.query(model.ClientGroup)),
            fields=ClientFields(),
            action="save"
            )
        return dict(rates=rates,
                    companies=companies,
                    users=users,
                    groups=groups,
                    clients=clients,
                    products=products,
                    invoices=invoices,
                    client_form=client_form)

    @expose(template="invoicing.templates.login")
    def login(self, forward_url=None, *args, **kw):

        if forward_url:
            if isinstance(forward_url, list):
                forward_url = forward_url.pop(0)
            else:
                del request.params['forward_url']

        if not identity.current.anonymous and identity.was_login_attempted() \
                and not identity.get_identity_errors():
            redirect(tg.url(forward_url or '/', kw))

        if identity.was_login_attempted():
            msg = _("The credentials you supplied were not correct or "
                   "did not grant access to this resource.")
        elif identity.get_identity_errors():
            msg = _("You must provide your credentials before accessing "
                   "this resource.")
        else:
            msg = _("Please log in.")
            if not forward_url:
                forward_url = request.headers.get("Referer", "/")

        response.status = 401
        return dict(logging_in=True, message=msg,
            forward_url=forward_url, previous_url=request.path_info,
            original_parameters=request.params)

    @expose()
    def logout(self):
        identity.current.logout()
        redirect("/")
