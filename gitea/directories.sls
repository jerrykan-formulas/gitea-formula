{%- from "gitea/map.jinja" import gitea with context -%}

include:
  - gitea

gitea_data_dir:
  file.directory:
    - name: {{ gitea.data_dir }}
    - user: {{ gitea.user }}
    - group: {{ gitea.user }}
    - makedirs: True
    - require:
      - user: gitea-user

gitea_logs_dir:
  file.directory:
    - name: {{ gitea.logs_dir }}
    - user: {{ gitea.user }}
    - group: {{ gitea.user }}
    - makedirs: True
    - require:
      - user: gitea-user

gitea_repositories_dir:
  file.directory:
    - name: {{ gitea.repo_root_dir }}
    - user: {{ gitea.user }}
    - group: {{ gitea.user }}
    - makedirs: True
    - require:
      - user: gitea-user
