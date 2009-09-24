from turbogears import controllers, expose, redirect, identity, validate, error_handler, flash
from turbogears.widgets import DataGrid

from utils import ControllerUtils
utils = ControllerUtils()

from invoicing.widgets import *
from invoicing import model

class ClientController(controllers.Controller, identity.SecureResource):
    require = identity.not_anonymous()

    client_table = DataGrid(fields=[
            ('Name', 'name'),
            ('Address', 'address'),
            ('Country', 'country'),
            ('VAT number', 'vat_number'),
            ('Invoices', utils.print_invoices),
            ('Next Ident', 'next_invoice_ident'),
            ('Group', 'group.name')
            ])

    @expose()
    def index(self):
        raise redirect('list')

    @expose(template='invoicing.templates.clients')
    def list(self):
        company=identity.current.user.company
        clients=self.client_table.display(company.clients)
        return dict(clients=clients)

    @expose(template='invoicing.templates.add_client')
    def new(self, tg_errors=None):
        if tg_errors:
            flash('There were problems with the data submitted!')
        return dict(client_form=new_client_form)

    @expose()
    @validate(form=new_client_form)
    @error_handler(new)
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
