gitea-logrotate-conf:
  file.managed:
    - name: /etc/logrotate.d/gitea
    - source: salt://gitea/files/logrotate.jinja
    - template: jinja
