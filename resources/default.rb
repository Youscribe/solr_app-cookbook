actions :create

default_action :create

attribute :name, :kind_of => String, :name_attribute => true
attribute :directory, :kind_of => String
attribute :cookbook, :kind_of => String
