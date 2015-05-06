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

# Removing the deb
cleanup-tmp:
  file.absent:
    - name: /tmp/icaclient_13.1.0.285639_amd64.deb

# Emptying the apt-cache
cleanup-apt-cache:
  cmd.run:
    - name: 'apt-get -y -q clean'
