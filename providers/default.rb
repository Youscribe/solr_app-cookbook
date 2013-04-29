action :create do
  remote_directory "Solr collection" do
    path "#{node["solr_app"]["solr_home"]}/#{new_resource.name}"
    source new_resource.directory || new_resource.name
    if new_resource.cookbook then cookbook new_resource.cookbook end
    owner node["tomcat"]["user"]
    group node["tomcat"]["group"]
    action :create
    notifies :create, "template[solr.xml]"
  end
  new_resource.updated_by_last_action(true)
end
