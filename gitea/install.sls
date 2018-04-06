{%- from "gitea/map.jinja" import gitea with context -%}

include:
  - gitea.user

gitea-package-deps:
  pkg.installed:
    - name: git

gitea-binary-dir:
  file.directory:
    - name: {{ gitea.install_dir }}

gitea-binary:
  file.managed:
    - name: {{ gitea.install_dir }}/gitea
    - source: {{ gitea.binary }}
{%- if gitea.binary_hash %}
    - source_hash: {{ gitea.binary_hash }}
{%- endif %}
    - mode: 755
    - require:
      - file: gitea-binary-dir

{# TODO: conditional based on init system?? -#}
gitea-systemd-file:
  file.managed:
    - name: /etc/systemd/system/gitea.service
    - source: salt://gitea/files/gitea.service.jinja
    - template: jinja

gitea-service:
  service.running:
    - name: gitea
    - enable: True
    - require:
      - file: gitea-systemd-file
      - user: gitea-user

gitea-restart:
  module.wait:
    - name: service.restart
    - m_name: gitea
    - require:
      - service: gitea-service
    - watch:
      - file: gitea-binary
      - file: gitea-systemd-file
