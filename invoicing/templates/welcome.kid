<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:py="http://purl.org/kid/ns#"
    py:extends="'master.kid'">
<head>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type" py:replace="''"/>
<title>Welcome to TurboGears</title>
</head>
<body>
  <div id="getting_started">
    <h3>VAT Rates</h3>
    The System VAT Rates:
    ${rates}
    <h3>Companies</h3>
    ${companies}
    <h3>Users</h3>
    ${users}
    <h3>Groups</h3>
    ${groups}
    <h3>Clients</h3> <a href="/add_client">Add</a>
    ${clients}
    <h3>Products</h3>
    ${products}
    <h3>Invoices</h3>
    ${invoices}
  </div>
</body>
</html>
