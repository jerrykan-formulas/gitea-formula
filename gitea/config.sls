{%- from "gitea/map.jinja" import gitea with context -%}

include:
  - gitea.install

gitea-conf-dir:
  file.directory:
    - name: {{ gitea.conf_dir }}
    - mode: 755

gitea_conf_file:
  file.managed:
    - name: {{ gitea.conf_file }}
    - source: salt://gitea/files/app.ini.jinja
    - template: jinja
    - require:
      - file: gitea-conf-dir
    - require_in:
      - service: gitea-service
    - watch_in:
      - module: gitea-restart
