{%- from "gitea/map.jinja" import gitea with context -%}

include:
  - gitea.user

gitea-package-deps:
  pkg.installed:
    - name: git

gitea-binary-dir:
  file.directory:
    - name: {{ gitea.install_dir }}

gitea-binary-package:
  archive.extracted:
    - name: {{ gitea.install_dir }}
    - source: {{ gitea.binary_archive }}
{%- if gitea.binary_archive_hash %}
    - source_hash: {{ gitea.binary_archive_hash }}
{%- endif %}
    - archive_format: tar
    - if_missing: {{ gitea.install_dir }}/gitea
{%- if salt['grains.get']('saltversioninfo') < [2014, 7, 1] %}
    # leading space and trailing dash are required for salt <2014.7.1
    - tar_options: ' --strip-components=1 -'
{%- elif salt['grains.get']('saltversioninfo') < [2016, 11, 0] %}
    - tar_options: '--strip-components=1'
{%- else %}
    - options: '--strip-components=1'
    - enforce_toplevel: False
{%- endif %}
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
      - archive: gitea-binary-package
