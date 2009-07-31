from turbogears.identity.saprovider import SqlAlchemyIdentityProvider, SqlAlchemyIdentity
from turbogears import config
from turbogears.database import session
from turbogears.util import load_class
from sqlalchemy.orm import exc as orm_exc
import imaplib
import logging
log = logging.getLogger("invoicing.identity")

class ImapSqlAlchemyIdentityProvider(SqlAlchemyIdentityProvider):
    """
    An IMAP identity provider. Taken from here:
    http://achievewith.us/public/articles/2007/06/13/change-your-identity-in-turbogears-with-entry-points
    and also from here:
    http://groups.google.to/group/turbogears/browse_thread/thread/a552b9fdac34b9d6/dc2084e93b244411?lnk=gst&q=entry+point+identity#dc2084e93b244411
    """
    def __init__(self):
        SqlAlchemyIdentityProvider.__init__(self)
        
        # These three lines get the configuration parameters we set in app.cfg
        self.imap_authoritative = config.get("identity.imapprovider.imap_authoritative", False)
        self.server = config.get("identity.imapprovider.server", "localhost")
        self.port = config.get("identity.imapprovider.port", 143)
        self.ssl = config.get("identity.imapprovider.ssl", False)

        # These four lines make the user and visit classes available for
        # later use
        user_class_path = config.get("identity.saprovider.model.user", None)
        self.user_class = load_class(user_class_path)
        visit_class_path = config.get("identity.saprovider.model.visit", None)
        self.visit_class = load_class(visit_class_path)


    def validate_identity(self, user_name, password, visit_key):
        if self.validate_password(None, user_name, password):
            log.debug("validate: user_name: " + user_name)
            user = session.query(self.user_class).filter_by(email_address=user_name).one()
            if not user:
                if self.imap_authoritative:
                    user = self.user_class()
                    user.user_name = user_name
                    user.save()
                    session.flush()
                else:
                    return None
            try:
                link = session.query(self.visit_class).filter_by(visit_key=visit_key).one()
                link.user_id = user.user_id
            except orm_exc.NoResultFound:
                link = self.visit_class(visit_key=visit_key, user_id=user.user_id)
                session.save(link)
            session.flush()
            return SqlAlchemyIdentity(visit_key, user)
        return None

    def validate_password(self, user, user_name, password):
        rc = False
        try:
            if self.ssl:
                imapcon = imaplib.IMAP4_SSL(self.server, self.port)
            else:
                imapcon = imaplib.IMAP4(self.server, self.port)
        except:
            log.error("Could not establish connection to server at %s:%d" % (self.server, self.port))
            return rc

        try:
            if imapcon.login(user_name, password)[0] == 'OK':
                rc = True
        except:
            # Probably threw an error for invalid username/password
            log.info("Passwords don't match for user: %s", user_name)
        imapcon.shutdown()
        return rc

if __name__ == '__main__':
    from sys import argv
    imapsa = ImapSqlAlchemyIdentityProvider()
    print validate_password(argv[1], argv[2], argv[3])
