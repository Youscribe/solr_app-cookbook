Description
===========

Install solr and manage its configuration by LWRP

Requirements
============

Tested on Ubuntu.
Must work on Debian.
Need test/hack on other platforms.

Attributes
==========

* `node["solr_app"]["download_site"]`    - solr directory on an http server.
* `node["solr_app"]["version"]`          - solr version
* `node["solr_app"]["url"]`              - Final URL to solr .tgz - default: compute with "download_site" and "version"
* `node["solr_app"]["archive_war_path"]` - Path to the war in tgz - default: compute with "version"
* `node["solr_app"]["path"]`             - Path to install solr - default: "/opt/solr"
* `node["solr_app"]["solr_home"]`        - Path to solr_home - default: compute with "path"

Usage
=====

    include_recipe "solr_app"

Resources/Providers
===================

solr_app
--------

### Actions
- **:create : create a solr collection

### Attribute Parameters
- **name: name of the collection - default: name attribute
- **directory: directory in "files" of the collection configuration (with solrconfig.xml, schema.xml...) - default: name
- **cookbook: cookbook to find "directory" - default: current cookbook

### Example

    solr_app "products"

    solr_app "users" do
      name "users"
      directory "solr-users-conf"
      cookbook "my_cookbook_conf"
    end
