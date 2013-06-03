action :create do
  run_context.include_recipe "solr_app"

  remote_directory "Solr collection" do
    path ::File.join(node["solr_app"]["solr_home"], new_resource.name)
    source new_resource.directory || new_resource.name
    cookbook new_resource.cookbook if new_resource.cookbook
    owner node["tomcat"]["user"]
    group node["tomcat"]["group"]
    action :create
    notifies :create, "template[solr.xml]"
  end
  new_resource.updated_by_last_action(true)
end
