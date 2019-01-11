{% from "mysql/map.jinja" import mysql with context %}

mysql_server_install:
  pkg.installed:
    - name: {{ mysql.server }}

{% if grains['os_family'] == 'Debian' %}

mysql_debconf_utils_install:
  pkg.installed:
    - name: debconf-utils

mysql_debconf_install:
  pkg.installed:
    - name: debconf
    - require:
      - pkg: mysql_debconf_utils_install

mysql_debconf_settings:
  debconf.set:
    - name: {{ mysql.server }}
    - data:
        'mysql-server/root_password': {'type':'password', 'value':'{{ pillar['mysql']['root']['password'] }}'}
        'mysql-server/root_password_again': {'type':'password', 'value':'{{ pillar['mysql']['root']['password'] }}'}
    - require:
      - pkg: debconf
    - require_in:
      - mysql_server_install

{% endif %}
