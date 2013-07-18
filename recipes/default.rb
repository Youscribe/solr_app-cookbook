#
# Cookbook Name:: solr_app
# Recipe:: default
#
# Author:: Stanislav Bogatyrev <realloc@realloc.spb.ru>
# Author:: Guilhem Lettron <guilhem.lettron@youscribe.com>
#
# Copyright 2013, Societe Publica.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require "pathname"

include_recipe "tomcat"

directory node["solr_app"]["path"] do
  mode 00755
  recursive true
  action :create
end


# Extract war file from solr archive
ark 'solr_war' do
  url node["solr_app"]["url"]
  action :cherry_pick
  creates node["solr_app"]["archive_war_path"]
  path ::File.join(Chef::Config[:file_cache_path], "solr_app")
  strip_leading_dir false
end

# Since solr 4.3.0 we need slf4j jar http://wiki.apache.org/solr/SolrLogging#Solr_4.3_and_above
# TODO use an external cookbook
["slf4j-jdk14-1.6.6.jar", "log4j-over-slf4j-1.6.6.jar", "slf4j-api-1.6.6.jar", "jcl-over-slf4j-1.6.6.jar"].each do |file|
  ark file do
    url "http://www.slf4j.org/dist/slf4j-1.6.6.tar.gz"
    action :cherry_pick
    creates ::File.join("slf4j-1.6.6", file)
    path ::File.join(node["tomcat"]["home"],"lib")
  end
end

d = directory node["solr_app"]["solr_home"] do
  owner node["tomcat"]["user"]
  group node["tomcat"]["group"]
  mode 00755
  recursive true
  action :nothing
end
d.run_action(:create)

template "solr.xml" do
  path ::File.join(node["solr_app"]["solr_home"],"solr.xml")
  owner node["tomcat"]["user"]
  group node["tomcat"]["group"]
  source "solr.xml.erb"
  cookbook "solr_app"
  variables(
    :collections => Array(Pathname.new(node["solr_app"]["solr_home"]).children.select { |c| c.directory? }.collect { |p| p.basename })
  )
#  notifies :restart, "service[tomcat]"
end

application "solr" do
  path node["solr_app"]["path"]
  owner node["tomcat"]["user"]
  group node["tomcat"]["group"]
  repository ::File.join(Chef::Config[:file_cache_path], "solr_app", node["solr_app"]["archive_war_path"] )
  scm_provider Chef::Provider::File::Deploy
  java_webapp do
    context_template "tomcat.xml.erb"
  end
  tomcat
end
