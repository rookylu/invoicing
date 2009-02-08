<table xmlns:py="http://purl.org/kid/ns#" id="${name}" class="grid" cellpadding="0" cellspacing="0" border="1">
<thead py:if="columns">
  <tr>
    <th py:for="i, col in enumerate(columns)" class="col_${i}" py:content="col.title"/>
  </tr>
</thead>
<tbody>
  <tr py:for="i, row in enumerate(value)" class="${i%2 and 'odd' or 'even'}">
    <td py:for="col in columns" align="${col.get_option('align', None)}" py:content="col.get_field(row)"/>
  </tr>
</tbody>
</table>
