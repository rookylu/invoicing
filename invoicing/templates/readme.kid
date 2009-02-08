<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:py="http://purl.org/kid/ns#"
    py:extends="'master.kid'">
<head>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type" py:replace="''"/>
<title>Welcome to TurboGears</title>
</head>
<body>
  <div id="getting_started">
    <h4 class="right"><a href="http://github.com/wjlroe/invoicing/tree/master">github project page</a>|<a href="http://code.google.com/p/tg-invoicing/issues/list">Issues</a></h4>
    <h2>Here is the README file from this project:</h2>
    <iframe src="${tg.url('/readme')+'?tg_format=iframe'}" width="100%" height="800px">
      <p>Your browser does not support iframes - respect!</p>
    </iframe>
  </div>
</body>
</html>
