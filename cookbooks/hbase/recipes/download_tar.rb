master_host=node[:hadoop][:hadoop_hosts][:master]
hbase_distro=node[:hbase][:version]

#Download and unpack tarballs
execute 'download tarball' do
  command 'wget '+master_host+':5000/files/'+hbase_distro+'-bin.tar.gz -O /tmp/hbase.tar.gz'
  action :run
end