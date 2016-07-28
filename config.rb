root = File.absolute_path(File.dirname(__FILE__))

log_level           :info
#log_level           :debug
root_path           root
file_cache_path     root
cookbook_path       [root + '/cookbooks']

