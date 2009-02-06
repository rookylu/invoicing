<div xmlns:py="http://purl.org/kid/ns#" id="menu">
  <div py:for="submenu in menu_items">
    <h4>${submenu[0]}</h4>
    <ul class="submenu">
      <li py:for="link in submenu"><a href="${tg.url(link[1])}">${link[0]}</a></li>
    </ul>
  </div>
</ul>
