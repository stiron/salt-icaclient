# Copyright 2015, Tamas Molnar
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

{% if grains['os'] == 'Ubuntu' and grains['osrelease'] == '14.04' %}

# Client file name in variable
{% set icaclient_file = 'icaclient_13.1.0.285639_amd64.deb' %}

# Dependencies for installing the ICAClient
{% set package_dep_list = [
  'libxerces-c3.1',
  'libwebkitgtk-1.0-0',
  'libc6:i386',
  'libstdc++6:i386',
  'libgtk2.0-0:i386',
  'libxext6:i386',
  'libxmu6:i386',
  'libxpm4:i386',
  'libasound2:i386',
  'libx11-6:i386',
  'libice6:i386',
  'libsm6:i386',
  'libspeex1:i386',
  'libvorbis0a:i386',
  'libvorbisenc2:i386',
  'libcanberra-gtk-module:i386'
] %}

# Downloading the ICAClient deb file to /tmp
/tmp/{{ icaclient_file }}:
  file.managed:
    - source: salt://citrixica/files/{{ icaclient_file }}
    - user: root
    - group: root
    - mode: 644

# Adding the 32bit architecture to the system
add-arch:
  cmd.run:
    - name: 'dpkg --add-architecture i386'
    - unless:
      - dpkg -l icaclient

# Updating the package cache
update-cache:
  cmd.run:
    - name: 'apt-get -y -q update'
    - unless:
      - dpkg -l icaclient

# Installing dependencies
install-deps:
  pkg.installed:
    - names:
      {% for package in package_dep_list %}
      - {{ package }}
      {% endfor %}

# Installing the ICAClient
install-ica:
  cmd.run:
    - name: 'dpkg -i /tmp/{{ icaclient_file }}'
    - unless:
      - dpkg -l icaclient
    - creates: /opt/Citrix/ICAClient/
    - require:
      - file: /tmp/{{ icaclient_file }}

# Adding certificates to the client
add-mozilla-certs:
  cmd.run:
    - name: 'ln -s /usr/share/ca-certificates/mozilla/* /opt/Citrix/ICAClient/keystore/cacerts/'
    - unless:
      - ls /opt/Citrix/ICAClient/keystore/cacerts/NetLock_Business_=Class_B=_Root.crt

rehash-keystore:
  cmd.run:
    - name: 'c_rehash /opt/Citrix/ICAClient/keystore/cacerts/'
    - onchanges:
      - cmd: add-mozilla-certs

# Configuring firefox plugins (for 64bit systems)
remove-npwrapper:
  cmd.run:
    - name: 'rm -f /usr/lib/mozilla/plugins/npwrapper.npica.so /usr/lib/firefox/plugins/npwrapper.npica.so'
    - onlyif:
      - ls /usr/lib/mozilla/plugins/npwrapper.npica.so

remove-npica:
  cmd.run:
    - name: 'rm -f /usr/lib/mozilla/plugins/npica.so'
    - onchanges:
      - cmd: remove-npwrapper

symlink-the-right-so:
  cmd.run:
    - name: 'ln -s /opt/Citrix/ICAClient/npica.so /usr/lib/mozilla/plugins/npica.so'
    - onchanges:
      - cmd: remove-npica

{% endif %}
