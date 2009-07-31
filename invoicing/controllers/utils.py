#!/usr/bin/python
# -*- coding: iso-8859-15

from kid import XML
from turbogears import controllers

class ControllerUtils:

    def icon(self, image=None, title=""):
        img_line = None
        if image:
            img=controllers.url("/static/images/%s" % image)
            img_line = "<img src=\"%s\" title=\"%s\" />" % (img, title)
        return img_line

    def email_icon(self, obj, title="Email"):
        img_link = None
        if obj:
            img_link = self.item_link(obj, 'email', self.icon("internet-mail.png",title))
        return img_link

    def delete_icon(self, obj, title="Delete"):
        #url = "/%s/delete/%i" % (obj.__class__.__name__.lower(), obj.id)
        img_link = self.item_link(obj, 'delete', self.icon("dialog-cancel.png",title))
        return img_link

    def print_icon(self, obj, title="Print"):
        #url = "/%s/print/%i" % (obj.__class__.__name__.lower(), obj.id)
        img_link = self.item_link(obj, 'print', self.icon("document-print.png",title))
        return img_link

    def edit_icon(self, obj, title="Edit"):
        #url = "/%s/edit/%i" % (obj.__class__.__name__.lower(), obj.id)
        img_link = self.item_link(obj, 'edit', self.icon("edit.png",title))
        return img_link

    def tick_icon(self, title="Yes"):
        return self.icon("tick.png",title)

    def cross_icon(self, title="No"):
        return self.icon("dialog-cancel.png",title)

    def view_icon(self, obj, title="View"):
        return self.item_link(obj, 'view', self.icon("x-office-document.png", title))

    def item_link(self, obj, action="view", text="id"):
        """
        Format a link to an object in the system. Two optional arguments:
        action::
          edit/view/delete etc
        text::
          the text to display in the A tag. (could be an img tag)
        """
        url = "/%s/%s/%i" % (obj.__class__.__name__.lower(), action, obj.id)
        url = controllers.url(url)
        link = "<a href=\"%s\">%s</a>" % (url,text)
        return XML(link)

    def format_address(self, address=""):
        return XML(address.replace(',',',<br />'))

    def format_date(self, date):
        return date.strftime('%d %B %Y')

    def format_percentage(self, amount=0):
        return "%.2f%%" % (amount*100)

    def format_money(self, price):
        return u"£%.2f" % (price)

    def format_link(self, action="view", type="invoice", id=1):
        return controllers.url("/%s/%s/%i" % (action, type, id))

    def print_invoices(self, parent):
        if hasattr(parent, 'invoices'):
            #invoices = ["<a href=\"/invoice/%i\">%s</a>" % (invoice.id, invoice.ident) for invoice in parent.invoices]
            invoices = parent.invoices
        else:
            invoices = [parent.invoice for parent in parent.invoice_lines]
        invoices = ["<a href=\"%s\">%s</a>" % (utils.format_link('invoice','view',invoice.id), invoice.ident) for invoice in invoices]
        #for invoice in parent.invoices:
        #    invoices.append("<a href=\"/invoice/%i\">%s</a>" % (invoice.id, invoice.ident))
        invoices = "<br />".join(invoices)
        return XML(invoices)
