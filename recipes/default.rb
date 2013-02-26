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

directory node["solr_app"]["solr_home"] do
  owner node["tomcat"]["user"]
  group node["tomcat"]["group"]
  mode 00755
  action :create
end

template "solr.xml" do
  path File.join(node["solr_app"]["solr_home"],"solr.xml")
  owner node["tomcat"]["user"]
  group node["tomcat"]["group"]
  source "solr.xml.erb"
  cookbook "solr_app"
  variables(
    :collections => Pathname.new(node["solr_app"]["solr_home"]).children.select { |c| c.directory? }.collect { |p| p.basename }
  )
#  notifies :restart, "service[tomcat]"
end

application "solr" do
  path node["solr_app"]["path"]
  owner node["tomcat"]["user"]
  group node["tomcat"]["group"]
#  repository File.join(Chef::Config[:file_cache_path], "solr_app", File.dirname(node["solr_app"]["archive_war_path"]))
  repository File.join(Chef::Config[:file_cache_path], "solr_app", node["solr_app"]["archive_war_path"] )
  revision File.basename(node["solr_app"]["archive_war_path"], ".war")
  strategy :java_local_file
#  symlinks({"solr_home" => "solr_home"})
  java_webapp do
    context_template "tomcat.xml.erb"
  end
  tomcat
end
