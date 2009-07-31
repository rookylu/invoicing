#!/usr/bin/python
# -*- coding: iso-8859-15

import turbogears as tg
from turbogears import controllers, expose, flash, error_handler
from turbogears import identity, redirect, validate, config, paginate
from turbogears.database import session
from turbogears.widgets import DataGrid
import turbogears
from cherrypy import request, response
from invoicing import json
import logging
log = logging.getLogger("invoicing.controllers")
from invoicing import model
from invoicing.widgets import *
import os
import os.path
from docutils.core import publish_string
from kid import XML

## Subcontrollers
from invoice import InvoiceController
from product import ProductController
from client import ClientController
# Controller utils
from utils import ControllerUtils
utils = ControllerUtils()

class Root(controllers.RootController):

    invoice = InvoiceController()
    product = ProductController()
    client = ClientController()

    def company_logo(self, company):
        logo = "<img src=\"%s\" />" % controllers.url('/static/images/companies/'+company.logo)
        return XML(logo)

    def company_users(self, company):
        user_line = []
        #users = model.Company.select(company.id).throughTo.users
        for user in company.users:
            #log.debug("company_users: ", user)
            user_line.append("<a href=\"%s\">%s</a>" % (utils.format_link('user','view',user.user_id), user.display_name))
        user_line = "<br />".join(user_line)
        return XML(user_line)

    def print_products(self, parent):
        #products = "<br />".join(["<a href=\"/product/%s\">%s</a>" % (line.product.id, line.product.name) for line in parent.products])
        products = "%i products @ %s" % (parent.product_quantity, parent.net_total)
        return XML(products)

    def group_users(self, group):
        users = []
        for user in group.users:
            users.append("<a href=\"%s\">%s</a>" % (utils.format_link('user','view',user.user_id), user.display_name))
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
            #('Logo', self.company_logo),
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

        self.menu_items = [["Clients",("All Clients","/client/list"),("New Client","/client/new")],
                           ["Invoices",("All Invoices","/invoice/list"),("New Invoice","/invoice/new")],
                           ["Products", ("All Products","/product/list"),("New Product","/product/new")],
                           ["Admin",
                            ("VAT Rates","/vat_rates"),
                            ("Companies","/companies"),
                            ("Users","/users"),
                            ("Groups","/groups"),
                            ("README","/readme")]]
        turbogears.view.variable_providers.append(self.add_custom_stdvars)

    @expose(template='invoicing.templates.menu')
    def get_menu(self):
        return dict(menu_items=self.menu_items)

    def absolute_to_local(self, request):
        "Resolves an absolute URL to a local one, so that the JS can match menu entries against the location bar."
        toRemove = "%s" % request.remote_host
        log.debug("toRemove: %s" % toRemove)
        if request.remote_port:
            toRemove = "%s%s" % (toRemove, str(request.remote_port))
        log.debug("toRemove: %s" % toRemove)
        link = request.browser_url[len(toRemove):]
        return link

    def add_custom_stdvars(self,vars):
        "Lots of lovely utility functions to be used from the templates"
        return vars.update({"get_menu": self.get_menu,
                            'format_address': utils.format_address,
                            'format_date': utils.format_date,
                            'format_money': utils.format_money,
                            'link': utils.format_link,
                            'print_icon': utils.print_icon,
                            'delete_icon': utils.delete_icon,
                            'view_icon': utils.view_icon,
                            'edit_icon': utils.edit_icon,
                            'email_icon': utils.email_icon,
                            'tick_icon': utils.tick_icon,
                            'cross_icon': utils.cross_icon,
                            'abs_to_local': self.absolute_to_local,
                            'format_percentage': utils.format_percentage})

    @expose(template="invoicing.templates.welcome")
    @identity.require(identity.not_anonymous())
    def index(self):
        rates=self.vat_rates_table.display(session.query(model.VATRate))
        companies=self.company_table.display(session.query(model.Company))
        users=self.user_table.display(session.query(model.User))
        groups=self.group_table.display(session.query(model.Group))
        clients=self.client.client_table.display(session.query(model.Client))
        products=self.product.product_table.display(session.query(model.Product))
        invoices=self.invoice.invoice_table.display(session.query(model.Invoice))

        return dict(rates=rates,
                    companies=companies,
                    users=users,
                    groups=groups,
                    clients=clients,
                    products=products,
                    invoices=invoices)

    @expose(template='invoicing.templates.readme')
    @expose(template='invoicing.templates.iframe', as_format='iframe')
    def readme(self):
        "Return the README.rst formatted as HTML that is embeded in an iframe"
        file_to_read = config.get('invoicing.readme')
        filefd = open(file_to_read, 'r')
        readme = publish_string(
            source=filefd.read(),
            settings_overrides={'file_insertion_enabled': 0, 'raw_enabled': 0},
            writer_name='html')
        return dict(readme=readme)

    """@expose(template='.templates.invoices')
    @identity.require(identity.not_anonymous())
    def invoices(self):
        company=identity.current.user.company
        #client_groups=company.client_groups
        invoices=self.invoice_table.display(company.invoices)
        return dict(invoices=invoices)"""

    """@expose(template='.templates.invoice')
    #@identity.require(identity.in_group("admin"))
    def invoice(self, action="view", invoice_id=None):
        if action == 'print':
            redirect("/invoice_pdf/%s/%s" % (action, invoice_id))
        invoice = model.Invoice.get(invoice_id)
        next = invoice.next_invoice()
        previous = invoice.previous_invoice()
        return dict(invoice=invoice, next=next, previous=previous)"""

    @expose(template="invoicing.templates.invoice-fo", fragment=True, format="xml")
    def invoice_fo(self, action="view", invoice_id=None):
        invoice = model.Invoice.get(invoice_id)
        company=invoice.company
        company_address = company.address.split(",")
        address_lines = invoice.client.address.split(",")
        return dict(invoice=invoice, address_lines=address_lines, company=company, company_address=company_address)

    @expose()
    def invoice_pdf(self, action="view", invoice_id=None):
        fo=self.invoice_fo("view", invoice_id)
        filename_fo='invoicing/static/invoices/invoice-%s.fo' % invoice_id
        fo_fd = open(filename_fo, 'w')
        fo_fd.write(fo)
        fo_fd.close()
        filename_pdf=filename_fo.replace(".fo", ".pdf")
        cmd="fop %s %s" % (filename_fo, filename_pdf)
        log.debug("Gonna run fop like: %s in dir: %s" % (cmd, os.getcwd()))
        os.system(cmd)
        redirect("/static/invoices/invoice-%s.pdf" % invoice_id)

    @expose(template='invoicing.templates.vat_rates')
    @identity.require(identity.not_anonymous())
    def vat_rates(self):
        vat_rates=self.vat_rates_table.display(model.VATRate.query())
        return dict(vat_rates=vat_rates)

    @expose(template='invoicing.templates.companies')
    @identity.require(identity.not_anonymous())
    def companies(self):
        companies=self.company_table.display(model.Company.query())
        return dict(companies=companies)

    @expose(template='invoicing.templates.users')
    @identity.require(identity.not_anonymous())
    def users(self):
        users=self.user_table.display(model.User.query())
        return dict(users=users)

    @expose(template='invoicing.templates.groups')
    @identity.require(identity.not_anonymous())
    def groups(self):
        groups=self.group_table.display(model.Group.query())
        return dict(groups=groups)

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
        companylogo = config.get('invoicing.login.logo')
        response.status = 401
        return dict(logging_in=True, message=msg,
            forward_url=forward_url, previous_url=request.path_info,
            original_parameters=request.params, companylogo=companylogo)

    @expose()
    def logout(self):
        identity.current.logout()
        redirect("/")
