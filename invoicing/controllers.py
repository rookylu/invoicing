#!/usr/bin/python
# -*- coding: iso-8859-15

import turbogears as tg
from turbogears import controllers, expose, flash, error_handler
from turbogears import identity, redirect, validate, config
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

class Root(controllers.RootController):
    #require = identity.not_anonymous()

    def company_logo(self, company):
        logo = "<img src=\"%s\" />" % controllers.url('/static/images/companies/'+company.logo)
        return XML(logo)

    def company_users(self, company):
        user_line = []
        #users = model.Company.select(company.id).throughTo.users
        for user in company.users:
            #log.debug("company_users: ", user)
            user_line.append("<a href=\"%s\">%s</a>" % (self.format_link('user','view',user.user_id), user.display_name))
        user_line = "<br />".join(user_line)
        return XML(user_line)

    def print_invoices(self, parent):
        if hasattr(parent, 'invoices'):
            #invoices = ["<a href=\"/invoice/%i\">%s</a>" % (invoice.id, invoice.ident) for invoice in parent.invoices]
            invoices = parent.invoices
        else:
            invoices = [parent.invoice for parent in parent.invoice_lines]
        invoices = ["<a href=\"%s\">%s</a>" % (self.format_link('invoice','view',invoice.id), invoice.ident) for invoice in invoices]
        #for invoice in parent.invoices:
        #    invoices.append("<a href=\"/invoice/%i\">%s</a>" % (invoice.id, invoice.ident))
        invoices = "<br />".join(invoices)
        return XML(invoices)

    def print_products(self, parent):
        #products = "<br />".join(["<a href=\"/product/%s\">%s</a>" % (line.product.id, line.product.name) for line in parent.products])
        products = "%i products @ %s" % (parent.product_quantity, parent.net_total)
        return XML(products)

    def group_users(self, group):
        users = []
        for user in group.users:
            users.append("<a href=\"%s\">%s</a>" % (self.format_link('user','view',user.user_id), user.display_name))
        users = "<br />".join(users)
        return XML(users)

    def icon(self, link, image):
        src=controllers.url(link)
        img=controllers.url("/static/images/%s" % image)
        #log.debug(src)
        return XML("<a href=\"%s\"><img src=\"%s\" /></a>" % (src, img))

    def email_icon(self, obj):
        url = self.format_link(obj.__class__.__name__.lower(), 'email', obj.id)
        img_link = self.icon(url,"internet-mail.png")
        #log.debug(img_link)
        return img_link

    def delete_icon(self, obj):
        url = "/%s/delete/%i" % (obj.__class__.__name__.lower(), obj.id)
        img_link = self.icon(url,"dialog-cancel.png")
        return img_link

    def print_icon(self, obj):
        url = "/%s/print/%i" % (obj.__class__.__name__.lower(), obj.id)
        img_link = self.icon(url,"document-print.png")
        return img_link

    def edit_icon(self, obj):
        url = "/%s/edit/%i" % (obj.__class__.__name__.lower(), obj.id)
        img_link = self.icon(url,"edit.png")
        return img_link
    
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
            ('Created on', 'created_date'),
            ('Date', 'invoice_date'),
            ('Sent on', 'date_sent'),
            ('Paid on', 'paid'),
            ('Num. Products', 'product_quantity'),
            ('Net. Total', 'net_total'),
            ('Edit', self.edit_icon),
            ('Email', self.email_icon),
            ('Print', self.print_icon),
            ('Delete', self.delete_icon)
            ], template='invoicing.templates.datagrid')

        self.menu_items = [["Clients",("All Clients","/clients"),("New Client","/add_client")],
                           ["Invoices",("All Invoices","/invoices"),("New Invoice","/add_invoice")],
                           ["Products", ("All Products","/products"),("New Product","/add_product")],
                           ["Admin",
                            ("VAT Rates","/vat_rates"),
                            ("Companies","/companies"),
                            ("Users","/users"),
                            ("Groups","/groups"),
                            ("README","/readme")]]
        turbogears.view.variable_providers.append(self.add_custom_stdvars)

    @expose(template='.templates.menu')
    def get_menu(self):
        return dict(menu_items=self.menu_items)

    def format_address(self, address):
        return XML(address.replace(',',',<br />'))

    def format_date(self, date):
        return date.strftime('%d %B %Y')

    def format_percentage(self, amount):
        return "%.2f%%" % (amount*100)

    def format_money(self, price):
        return u"£%.2f" % (price)

    def format_link(self, action="view", type="invoice", id=1, ):
        return controllers.url("/%s/%s/%i" % (action, type, id))

    def add_custom_stdvars(self,vars):
        return vars.update({"get_menu": self.get_menu,
                            'format_address': self.format_address,
                            'format_date': self.format_date,
                            'format_money': self.format_money,
                            'link': self.format_link,
                            'format_percentage': self.format_percentage})
    
    @expose(template="invoicing.templates.welcome")
    #@identity.require(identity.in_group("admin"))
    def index(self):
        rates=self.vat_rates_table.display(session.query(model.VATRate))
        companies=self.company_table.display(session.query(model.Company))
        users=self.user_table.display(session.query(model.User))
        groups=self.group_table.display(session.query(model.Group))
        clients=self.client_table.display(session.query(model.Client))
        products=self.product_table.display(session.query(model.Product))
        invoices=self.invoice_table.display(session.query(model.Invoice))
        
        return dict(rates=rates,
                    companies=companies,
                    users=users,
                    groups=groups,
                    clients=clients,
                    products=products,
                    invoices=invoices)

    @expose(template='.templates.readme')
    @expose(template='.templates.iframe', as_format='iframe')
    def readme(self):
        file_to_read = config.get('invoicing.readme')
        filefd = open(file_to_read, 'r')
        readme = publish_string(
            source=filefd.read(),
            settings_overrides={'file_insertion_enabled': 0, 'raw_enabled': 0},
            writer_name='html')
        return dict(readme=readme)

    @expose(template='.templates.invoices')
    #@identity.require(identity.in_group("admin"))
    def invoices(self):
        invoices=self.invoice_table.display(session.query(model.Invoice))
        return dict(invoices=invoices)

    @expose(template='.templates.invoice')
    #@identity.require(identity.in_group("admin"))
    def invoice(self, action="view", invoice_id=None):
        invoice = model.Invoice.get(invoice_id)
        next = invoice.next_invoice()
        previous = invoice.previous_invoice()
        return dict(invoice=invoice, next=next, previous=previous)

    @expose(template='.templates.add_client')
    def add_client(self, tg_errors=None):
        if tg_errors:
            flash('There were problems with the data submitted!')
        return dict(client_form=client_form)

    @expose()
    @validate(form=client_form)
    @error_handler(add_client)
    def save_client(self, **data):
        client_group = model.ClientGroup.get(data['client_group'])
        client = model.Client(name=data['name'],
                              abbreveated=data['abbreveated'],
                              address=data['address'],
                              country=data['country'],
                              vat_number=data['vat_number'],
                              email_address=data['email_address'],
                              client_group=client_group)
        client.flush()
        redirect('/')

    @expose(template='.templates.add_invoice')
    def add_invoice(self, tg_errors=None):
        if tg_errors:
            flash('There were problems with the form you submitted')
        return dict(invoice_form=invoice_form)

    @expose()
    @validate(form=invoice_form)
    @error_handler(add_invoice)
    def save_invoice(self, **data):
        client = model.Client.get(data['client'])
        ## TODO: Get this adding a new client when non-existent client data provided.
        # Pick a VAT Rate..
        vat_rate = model.VATRate.get_vat_rate(data['date'])
        invoice = model.Invoice(ident=client.next_invoice_ident,
                                date=data['date'],
                                client=client,
                                vat_rate=vat_rate.vat_rate,
                                term_length=data['terms'],
                                term_type=data['term_length'],
                                status=data['status'])
        invoice.flush()
        redirect('/') # TODO: should redirect to edit invoice - to add products later

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
