beacons:
  inotify:
    - files:
{% if grains['os_family']=="RedHat" %}
        /etc/my.cnf.d/server.cnf:
{% endif %}
{% if grains['os_family']=="Debian" %}
        /etc/mysql/mysql.conf.d/mysqld.cnf:
{% endif %}
          mask:
            - modify
    - disable_during_state_run: True
