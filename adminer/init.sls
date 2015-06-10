{% from "adminer/map.jinja" import adminer with context %}

include:
  - nginx.ng.config
  - nginx.ng.service
  - nginx.ng.vhosts




{{ adminer.base_dst }}:
  file.directory:
    - name: {{ adminer.base_dst }}/
    - user: {{ adminer.user }}


index.php:
  file.managed:
    - name: {{ adminer.base_dst }}/index.php
    - source: salt://adminer/files/index.php
    - user: {{ adminer.user }}
    - require:
      - file: {{ adminer.base_dst }}


adminer-4.2.1-mysql.php:
  file.managed:
    - name: {{ adminer.base_dst }}/adminer-4.2.1-mysql.php
    - source: salt://adminer/files/adminer-4.2.1-mysql.php
    - user: {{ adminer.user }}
    - require:
      - file: {{ adminer.base_dst }}

adminer-plugins.php:
  file.managed:
    - name: {{ adminer.base_dst }}/adminer-plugins.php
    - source: salt://adminer/files/adminer-plugins.php
    - user: {{ adminer.user }}
    - require:
      - file: {{ adminer.base_dst }}

adminer.php:
  file.managed:
    - name: {{ adminer.base_dst }}/adminer.php
    - source: salt://adminer/files/adminer-config.php.tmpl
    - user: {{ adminer.user }}
    - template: jinja
    - context:
        adminer: {{ adminer }}
    - require:
      - file: {{ adminer.base_dst }}

adminer.sql.gz:
  file.symlink:
    - name: {{ adminer.base_dst }}/adminer.sql.gz
    - target: {{ adminer.base_dst }}/{{ salt['pillar.get']('adminer:lookup:adminer_sql_import', 'adminer.sql.gz') }}
    - require:
      - file: {{ adminer.base_dst }}