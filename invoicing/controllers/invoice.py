from turbogears import controllers, expose, redirect, identity, validate, error_handler
from turbogears.widgets import DataGrid

from utils import ControllerUtils
utils = ControllerUtils()

from invoicing.widgets import *

class InvoiceController(controllers.Controller, identity.SecureResource):
    require = identity.not_anonymous()

    invoice_table = DataGrid(fields=[
        ('Ident', lambda x: utils.item_link(x, 'view', x.ident)),
        ('Client', 'client.name'),
        ('Status', 'status'),
        ('Created on', 'created_date'),
        ('Date', 'invoice_date'),
        ('Sent on', 'date_sent'),
        ('Paid on', 'paid'),
        ('Num. Products', 'product_quantity'),
        ('Net. Total', lambda x: utils.format_money(x.net_total)),
        ('Edit', utils.edit_icon),
        ('Email', utils.email_icon),
        ('Print', utils.print_icon),
        ('Delete', utils.delete_icon)
        ], template='invoicing.templates.datagrid')

    @expose()
    def index(self):
        raise redirect('list')

    # TODO: To be refactored to sub directories of templates...
    @expose(template='invoicing.templates.invoices')
    def list(self):
        company=identity.current.user.company
        invoices=self.invoice_table.display(company.invoices)
        return dict(invoices=invoices)

    @expose(template='invoicing.templates.add_invoice')
    def new(self, tg_errors=None):
        if tg_errors:
            flash('There were problems with the form you submitted')
        return dict(invoice_form=new_invoice_form)

    @expose()
    @validate(form=new_invoice_form)
    @error_handler(new)
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
        redirect(controllers.url('/invoice/edit/%i' % invoice.id)) # TODO: should redirect to edit invoice - to add products later
