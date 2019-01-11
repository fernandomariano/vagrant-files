{% for databasename, arg in salt['pillar.get']('mysql:database', {}).items() %}

mysql_{{ databasename }}_db_create:
  mysql_database.present:
    - name: {{ databasename }}
    - host: {{ arg.host }}
    - connection_user: {{ pillar['mysql']['root']['name'] }}
    - connection_pass:  {{ pillar['mysql']['root']['password'] }}
    - connection_charset: utf8

{% endfor %}
