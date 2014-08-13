class nfs::client::debian::service {

  Service{
    require => Class['nfs::client::debian::configure']
  }

  $portmap_service_name = $operatingsystem ? {
    ubuntu => 'rpcbind',
    default => 'portmap'
  }

    service { $portmap_service_name:
      ensure    => running,
      enable    => true,
      hasstatus => false,
    } 

  if $nfs::client::debian::nfs_v4 {
    service {
      'idmapd':
        ensure => running,
        subscribe => Augeas['/etc/idmapd.conf', '/etc/default/nfs-common'],
    }
  } else {
      service {
        'idmapd':
          ensure => stopped,
      }
  }
}
