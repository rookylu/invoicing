<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:py="http://purl.org/kid/ns#"
    py:extends="'master.kid'">
<head>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type" py:replace="''"/>
<title>Welcome to TurboGears</title>
</head>
<body>
  <div id="getting_started">
    <div class="right">
      <span class="actionIcons">${tg.edit_icon(product)} ${tg.delete_icon(product)}</span>
    </div>
    <h3>Product:</h3> ${product.name}<br />
    <span py:if="product.parent"><h3>Parent product:</h3> ${product.parent.name}<br /></span>
    <h3>Price:</h3> ${tg.format_money(product.price)}<br />
    <h3>Details: </h3> ${product.details}
  </div>
</body>
</html>
