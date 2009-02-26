from turbogears import controllers, expose, redirect, identity, validate, error_handler
from turbogears.widgets import DataGrid

import logging
log = logging.getLogger("invoicing.controllers.product")

from utils import ControllerUtils
utils = ControllerUtils()

from invoicing import model
from invoicing.widgets import *

class ProductController(controllers.Controller, identity.SecureResource):
    require = identity.not_anonymous()

    product_table = DataGrid(fields=[
        ('Name', lambda x: utils.item_link(x, 'show', x.name)),
        ('Price', 'price'),
        ('Invoices', lambda x: model.InvoiceLine.query.filter(model.InvoiceLine.product==x).count()),
        ('Edit', utils.edit_icon),
        ('Email', utils.email_icon),
        ('Print', utils.print_icon),
        ('Delete', utils.delete_icon)
        ])

    def get_parents(self, exclude=None):
        parents = [(-1, "")] # This is to be able to select no parent
        parents.extend([(p.id, p.name) for p in model.Product.all_root_products().all()])
        return parents

    @expose()
    def index(self):
        raise redirect('list')

    @expose(template='invoicing.templates.products')
    def list(self):
        company=identity.current.user.company
        products=self.product_table.display(company.products)
        return dict(products=products)

    @expose(template='invoicing.templates.product')
    @identity.require(identity.not_anonymous())
    def show(self, id, **kw):
        product=model.Product.get(id)
        return dict(product=product)

    @expose(template='invoicing.templates.edit_product')
    def new(self, tg_errors=None, **kw):
        if tg_errors:
            flash('There were problems with the form you submitted')
        form_options = dict(parent=self.get_parents)
        return dict(product_form=new_product_form,
                    form_values=dict(company=identity.current.user.company.id),
                    form_options=form_options)

    @expose(template='invoicing.templates.edit_product')
    def edit(self, id=-1, **kw):
        product=model.Product.get(id)
        if product == None:
            parent = model.Product.get(kw['parent'])
            company = model.Company.get(kw['company'])
            if parent:
                details=parent.details
                price=parent.price
                name="%s %s" % (parent.name, kw['name'])
                parent_id = parent.id
            else:
                details=""
                price=0.0
                name=kw['name']
                parent_id = None
            product = model.Product(parent=parent,
                                    name=name,
                                    company=company,
                                    details=details,
                                    price=price)
            product.flush()
        else:
            if product.parent:
                parent_id = product.parent.id
            else:
                parent_id = None
        form_options = dict(parent=lambda: self.get_parents(product))
        
        form_values = dict(price=product.price,
                           details=product.details,
                           product_id=product.id,
                           company=product.company.id,
                           parent=parent_id,
                           name=product.name)
        return dict(product_form=edit_product_form,
                    form_options=form_options,
                    form_values=form_values)

    @expose()
    @validate(form=new_product_form)
    @error_handler(new)
    def save(self, **data):
        if 'product_id' in data:
            product = model.Product.get(data['product_id'])
            product.name = data['name']
            product.price = data['price']
            product.details = data['details']
            product.company = model.Company.get(data['company'])
            product.parent = model.Product.get(data['parent'])
        else:
            log.debug("In theory this shouldn't happen. There is no product_id.")
            parent = model.Product.get(data['parent'])
            company = model.Company.get(data['company'])
            product = model.Product(name=data['name'],
                                    price=data['price'],
                                    details=data['details'],
                                    company=company,
                                    parent=parent)
        product.flush()
        redirect('list')
