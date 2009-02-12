from turbogears.widgets import forms
from turbogears.widgets import big_widgets
from turbogears import validators
from invoicing.model import ClientGroup, invoice_status_values, Client

class ClientFields(forms.WidgetsList):
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

client_form = forms.TableForm(
    fields=ClientFields(),
    action="save_client"
    )

#class TermsFormFields(forms.CompoundFormField):
#    #terms = forms.TextField(validator=validators.Number())
#    #term_length = forms.SingleSelectField(validator=validators.NotEmpty(),
#    #                                     label="Term type",
#    #                                     options=["Days","Months","Years"])
#    member_widgets = ['terms','term_length']
#    template = """
#    <div xmlns:py="http://purl.org/kid/ns#" class="${field_class}">
#        ${display_field_for(terms)}
#        ${display_field_for(term_length)}
#    </div>
#    """
#    def __init__(self, tfield_params={}, sel_params={}, *args, **kw):
#        # Call super cooperatively so our params get bound to the widget
#        # instance
#        super(TermsFormFields, self).__init__(*args, **kw)
#        # initialize our child widgets
#        tfield_params.setdefault('validator', validators.Number())
#        self.terms = forms.TextField("terms", **tfield_params)
#        # Assign a default valiator to our selection field
#        sel_params.setdefault('validator', validators.NotEmpty())
#        self.term_length = forms.SingleSelectField("term_length", **sel_params)

class InvoiceFields(forms.WidgetsList):
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

invoice_form = forms.TableForm(
    fields=InvoiceFields(),
    action="save_invoice",
    )
