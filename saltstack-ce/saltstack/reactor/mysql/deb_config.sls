restore_deb_mysql_server_config:
  local.state.single:
    - tgt: 'E@minion-ce* and G@os_family:Debian'
    - tgt_type: compound
    - args:
      - fun: file.managed
      - name: /etc/mysql/mysql.conf.d/mysqld.cnf
      - source: salt://mysql/files/deb_mysqld.cnf
