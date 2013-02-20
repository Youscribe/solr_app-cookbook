require "pathname"

def update_solr_xml
  template "solr.xml" do
    path File.join(node["solr_app"]["solr_home"],"solr.xml")
    source "solr.xml.erb"
    cookbook "solr_app"
    variable(
       :collections => Pathname.new(node["solr_app"]["solr_home"]).children.select { |c| c.directory? }.collect { |p| p.to_s }
    )
  end
end
