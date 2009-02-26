from turbogears.widgets import forms
from turbogears.widgets import big_widgets
from turbogears import validators
from invoicing.model import ClientGroup, invoice_status_values, Client, Product

class NewClientFields(forms.WidgetsList):
    """Form to create a client"""

    name = forms.TextField(validator=validators.NotEmpty())
    abbreveated = forms.TextField(validator=validators.NotEmpty(), attrs={'size':2})
    address = forms.TextArea(validator=validators.NotEmpty())
    country = forms.TextField(validator=validators.NotEmpty())
    vat_number = forms.TextField(validator=validators.NotEmpty(),label="VAT number")
    email_address = forms.TextField(validator=validators.Email(not_empty=True),label="Email address")
    client_group = forms.SingleSelectField(validator=validators.NotEmpty(),
                                           label="Client Group",
                                           options=[(g.id, g.name) for g in ClientGroup.all_client_groups().all()])

new_client_form = forms.TableForm(
    fields=NewClientFields(),
    action="save_client"
    )

class NewProductFields(forms.WidgetsList):
    """Form to create a new product"""

    parent = forms.SingleSelectField(validator=validators.NotEmpty(),
                                     label="Parent product")
                                     #options=[(p.id, p.name) for p in Product.all_root_products().all()])
    name = forms.TextField(validator=validators.NotEmpty(),
                           attrs=dict(size=40))
    company = forms.HiddenField()

new_product_form = forms.TableForm(
    fields=NewProductFields(),
    action="/product/edit"
    )

class EditProductFields(forms.WidgetsList):
    price = forms.TextField(validator=validators.Money())
    details = forms.TextArea()
    
    product_id = forms.HiddenField()

edit_product_form = forms.TableForm(
    fields=NewProductFields()+EditProductFields(),
    action="/product/save"
    )

class NewInvoiceFields(forms.WidgetsList):
    """Form widgets needed to create an invoice"""
    dateformat='%d/%m/%Y'

    date = big_widgets.CalendarDatePicker(format=dateformat,
                                          validator=validators.DateTimeConverter(format=dateformat,
                                                                                 not_empty=False))
    #terms = TermsFormFields(sel_params=dict(options=[('d',"Days"),('m',"Months"),('y',"Years")]))
    terms = forms.TextField(validator=validators.Number(), default=30)
    term_length = forms.SingleSelectField(validator=validators.NotEmpty(),
                                         label="Term type",
                                         options=["Days","Months","Years"])
    status = forms.SingleSelectField(validator=validators.NotEmpty(),
                                     options=invoice_status_values)
    client = forms.SingleSelectField(validator=validators.NotEmpty(),
                                     options=[(c.id, c.name) for c in Client.all_clients().all()])

new_invoice_form = forms.TableForm(
    fields=NewInvoiceFields(),
    action="/invoice/save",
    )
