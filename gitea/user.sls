{%- from "gitea/map.jinja" import gitea with context -%}

gitea-user:
  user.present:
    - name: {{ gitea.user }}
    - home: {{ gitea.home_dir }}
    - createhome: False
    - shell: /bin/bash
    - system: True
