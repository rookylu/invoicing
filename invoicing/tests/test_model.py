# If your project uses a database, you can set up database tests
# similar to what you see below. Be sure to set the db_uri to
# an appropriate uri for your testing database. sqlite is a good
# choice for testing, because you can use an in-memory database
# which is very fast.

from turbogears import testutil, database
from invoicing.model import Invoice, User, Group, Product, InvoiceLine
#database.set_db_uri("sqlite:///devdata.sqlite")
#turbogears.database.bind_meta_data()

class TestUser(testutil.DBTest):
    company = None
    user = None
    def setUp(self):
        pass
    def tearDown(self):
        pass
    def get_model(self):
        return User
    
    def test_1_company_creation(self):
        "Company creation"
        obj = Company(name=u"Acme Inc.",
                      phone_number=u"08465975",
                      email_address=u"sales@acme.com",
                      url=u"www.acme.com",
                      address=u"167 Silicone Valley Road, Next to M$ building, Cardboard box",
                      vat_number="US 748 27849")
        obj.flush()
        self.company = obj
        assert obj.name == u"Acme Inc."
        
    def test_2_user_creation(self):
        "Object creation should set the name"
        obj = User(user_name = u"username2",
                   email_address = u"user@example2.com",
                   display_name = u"Mr Example",
                   password = u"password",
                   company=self.company)
        obj.flush()
        self.user = obj
        assert obj.display_name == "Mr Example"

    # = Deletion objects below = #
    """def test_deletion(self):
        obj = User.query.filter_by(user_name=u"username").one()
        obj.delete()
        assert (True)"""
