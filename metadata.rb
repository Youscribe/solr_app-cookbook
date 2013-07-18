name             "solr_app"
maintainer       "Guilhem Lettron"
maintainer_email "guilhem.lettron@youscribe.com"
license          "Apache v2.0"
description      "Install solr"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.3"

supports         "debian"
supports         "ubuntu"

depends          "application"
depends          "application_java", ">= 1.1.0"
depends          "tomcat"
depends          "ark"
