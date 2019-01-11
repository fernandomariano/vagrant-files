set_hostname:
  salt.function:
    - name: network.mod_hostname
    - tgt: 'minion-ce1'
    - arg:
      - newhostname1

configure_db_minion:
  salt.state:
    - tgt: 'minion-ce2'
    - highstate: True

configure_web_minion:
  salt.state:
    - tgt: 'minion-ce3'
    - sls:
      - mysql.client
