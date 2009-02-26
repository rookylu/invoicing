from turbogears import controllers, expose, redirect, identity
from turbogears.widgets import DataGrid

from utils import ControllerUtils
utils = ControllerUtils()

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
