directory node["solr_app"]["path"] do
  mode 00755
  action :create
end

ark 'solr_war' do
  url node["solr_app"]["url"]
  action :cherry_pick
  creates node["solr_app"]["archive_war_path"]
  path File.join(Chef::Config[:file_cache_path], "solr_app")
end

application "solr" do
  path node["solr_app"]["path"]
  owner node["tomcat"]["user"]
  group node["tomcat"]["group"]
#  repository File.join(Chef::Config[:file_cache_path], "solr_app", File.dirname(node["solr_app"]["archive_war_path"]))
  repository File.join(Chef::Config[:file_cache_path], "solr_app", node["solr_app"]["archive_war_path"] )
  revision File.basename(node["solr_app"]["archive_war_path"], ".war")
  strategy :java_local_file
  java_webapp
  tomcat
end
