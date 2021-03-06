#Execute steps to download and setup Hadoop
include_recipe "hadoop::download_tar"
include_recipe "hadoop::unpack_tar"
include_recipe "hadoop::create_hadoop_user"
include_recipe "hadoop::passwordless_ssh"
include_recipe "hadoop::generate_bashrc"
include_recipe "hadoop::generate_core-site_xml"
include_recipe "hadoop::generate_hdfs-site_xml"
include_recipe "hadoop::generate_mapred-site_xml"
include_recipe "hadoop::generate_yarn-site_xml"
include_recipe "hadoop::generate_masters_and_slaves"
