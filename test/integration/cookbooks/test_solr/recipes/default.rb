#
# Cookbook Name:: test_solr
# Recipe:: default
#
# Copyright (C) 2014 
#
# 

include_recipe 'apt' if platform_family? 'debian'
package 'curl'
solr_app 'dummy' do
  cookbook cookbook_name.to_s
end
