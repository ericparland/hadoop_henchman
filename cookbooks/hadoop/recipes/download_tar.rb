master_host=node[:hadoop][:hadoop_hosts][:master]
hadoop_distro=node[:hadoop][:version]

#Download and unpack tarballs
execute 'download tarball' do
  command 'wget '+master_host+':5000/files/'+hadoop_distro+'.tar.gz -O /tmp/hadoop.tar.gz'
  action :run
end