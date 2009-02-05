from turbogears.widgets import forms
from turbogears import validators
from invoicing.model import ClientGroup

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
