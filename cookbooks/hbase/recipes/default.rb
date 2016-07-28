#Execute steps to download and setup HBase
include_recipe "hbase::download_tar"
include_recipe "hbase::unpack_tar"
include_recipe "hbase::create_hbase_user"
include_recipe "hbase::passwordless_ssh"
include_recipe "hbase::generate_hbase-site_xml"
include_recipe "hbase::generate_backup-masters"
include_recipe "hbase::generate_regionservers"

