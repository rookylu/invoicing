from turbogears.widgets import forms
from turbogears import validators

class ClientFields(forms.WidgetsList):
    """Form to create a client"""

    #def __init__(self, groups):
    name = forms.TextField(validator=validators.NotEmpty())
    abreveated = forms.TextField(validator=validators.NotEmpty(), attrs={'size':2})
    address = forms.TextArea(validator=validators.NotEmpty())
    country = forms.TextField(validator=validators.NotEmpty())
    vat_number = forms.TextField(validator=validators.NotEmpty())
    email_address = forms.TextField(validator=validators.Email(not_empty=True))
        #self.group = forms.SingleSelectField(options=[(g.id, g.name) for g in groups])


