{% from "mysql/map.jinja" import mysql with context %}

mysql_restart:
  module.wait:
    - name: service.restart
    - m_name: {{ mysql.service }}
    # - onchanges:
    #   - mysql_server_config

# mariadb.server-service:
#   service.running:
#     - name: mariadb
#     - require:
#       - pkg: mysql_server_install
#       - file: mysql_server_config
#     - enable: True
#     - listen:
#       - file: mysql_server_config
