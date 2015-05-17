# Citrix ICAClient Salt State

## Description

Salt state that installs and configures the [ICAClient](https://www.citrix.com/downloads/citrix-receiver/linux/receiver-for-linux-131.html)

## Requirements

* [Ubuntu 14.04 Desktop](http://ubuntu.com)
* [Citrix ICAClient](https://www.citrix.com/downloads/citrix-receiver/linux/receiver-for-linux-131.html)
* [Salt](http://saltstack.com)

Tested with **Salt 2014.7.5** and **2015.5.0**, **Ubuntu 14.04** and **ICAClient 13.1**

This state can be run on virtual machine as well.

## States

### init

This initial state installs the client, and configures it with Firefox

### cleanup

This state removes the deb file from tmp and flushes the apt cache

## Usage

* Clone the repository to the `/srv/salt/citrixica/` directory
* Download the current ICAClient installer deb on the PC
* Put the deb file in the `files/` directory
* Set the `icaclient_file` variable in the `init.sls` file, eg:
```
# init.sls
(...)
{% set icaclient_file = 'icaclient_13.1.0.285639_amd64.deb' %}
(...)
```
* Add the state(s) to your Salt state tree

Example `top.sls` file:
```
base:
  '*':
    - citrixica
```

## Contributing

1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Added some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request

## License

Author: Tamas Molnar

Copyright 2015, Tamas Molnar.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
