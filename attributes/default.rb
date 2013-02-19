default["solr_app"]["download_site"]	= "http://apache.crihan.fr/dist/lucene/solr"
default["solr_app"]["version"]		= "4.1.0"
default["solr_app"]["url"]		= node["solr_app"]["download_site"] + '/' + node["solr_app"]["version"] + '/' + "solr-#{node["solr_app"]["version"]}.tgz"

default["solr_app"]["archive_war_path"]	= File.join("solr-#{node["solr_app"]["version"]}", "dist", "solr-#{node["solr_app"]["version"]}.war")

default["solr_app"]["path"]		= "/opt/solr"
