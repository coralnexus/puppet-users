
define users::conf (

  $user                 = $name,
  $ensure               = 'present',
  $home_dir             = undef,
  $mode                 = $users::params::default_file_mode,
  $profile_file         = $users::params::profile_file,
  $profile_template     = $users::params::skel_profile_template,
  $bashrc_file          = $users::params::bashrc_file,
  $bashrc_template      = $users::params::skel_bashrc_template,
  $aliases_file         = $users::params::aliases_file,
  $alias_template       = $users::params::alias_template,
  $aliases              = $users::params::common_aliases,
  $ssh_dir              = $users::params::ssh_dir,
  $ssh_dir_mode         = $users::params::ssh_dir_mode,
  $ssh_key_type         = $users::params::default_ssh_key_type,
  $public_ssh_key_mode  = $users::params::public_ssh_key_mode,
  $public_ssh_key       = undef,
  $private_ssh_key_mode = $users::params::private_ssh_key_mode,
  $private_ssh_key      = undef,
  $label                = $users::params::user_label,
  $email                = $users::params::user_email,
  $editor               = $users::params::editor,
  $umask                = $users::params::umask,
  $use_color            = $users::params::use_color,
  $prompt               = $users::params::prompt,
  $ssh_config           = $users::params::ssh_config,
  $known_hosts          = []

) {
  $base_name       = $users::params::base_name
  $definition_name = name("${base_name}_conf_${name}")

  $user_dir     = ensure($home_dir, $home_dir, "${users::params::home_dir}/${user}")
  $user_ssh_dir = ensure($ssh_dir, "${user_dir}/${ssh_dir}")
  
  $ssh_config_file = "${user_ssh_dir}/${users::params::ssh_config_file}"
  
  $hosthash_file    = "${user_ssh_dir}/${users::params::hosthash_file}"
  $sed              = $users::params::sed
  $sha              = $users::params::sha
  $awk              = $users::params::awk
  $hash             = $users::params::hash
  $known_hosts_file = "${user_ssh_dir}/${users::params::known_hosts_file}"
  
  $all_known_hosts  = corl_merge($users::params::known_hosts, $known_hosts)

  #-----------------------------------------------------------------------------
  # Configuration

  corl::file { $definition_name:
    resources => {
      dir => {
        path   => $user_dir,
        ensure => directory
      },
      profile => {
        path    => ensure($profile_file, "${user_dir}/${profile_file}"),
        content => template($profile_template),
        require => 'dir'
      },
      bashrc => {
        path    => ensure($bashrc_file, "${user_dir}/${bashrc_file}"),
        content => template($bashrc_template),
        require => 'dir'
      },
      aliases => {
        path    => ensure($aliases_file, "${user_dir}/${aliases_file}"),
        content => render($alias_template, $aliases),
        require => 'dir'
      },
      ssh_dir => {
        path    => $user_ssh_dir,
        ensure  => directory,
        mode    => $ssh_dir_mode,
        require => 'dir'
      },
      ssh_conf => {
        path             => $ssh_config_file,
        content          => $ssh_config,
        content_template => $corl::params::ssh::config_template,
        require          => [ Class['corl::params'], 'ssh_dir' ]
      },
      hosthash => {
        path      => $hosthash_file,
        subscribe => Exec["${definition_name}_hosthash"]  
      },
      known_hosts => {
        path      => $known_hosts_file,
        subscribe => Exec["${definition_name}_known_hosts"]  
      }
    },
    defaults => {
      ensure => $ensure,
      owner  => $user,
      group  => $user,
      mode   => $mode
    },
    require => Corl::File["${base_name}_skel"]
  }
   
  #---

  corl::file { "${definition_name}_private_keys":
    resources => {
      primary => {
        path    => ensure($private_ssh_key, "id_${ssh_key_type}"),
        content => $private_ssh_key
      }
    },
    defaults => {
      ensure        => $ensure,
      owner         => $user,
      group         => $user,
      mode          => $private_ssh_key_mode,
      path_template => $users::params::prefix_template
    },
    options => {
      normalize_path  => false,
      template_prefix => "${user_ssh_dir}/"
    },
    require => File["${definition_name}_ssh_dir"]
  }
    
  #---

  corl::file { "${definition_name}_public_keys":
    resources => {
      primary => {
        path    => ensure($public_ssh_key, "id_${ssh_key_type}.pub"),
        content => $public_ssh_key
      }
    },
    defaults => {
      ensure        => $ensure,
      owner         => $user,
      group         => $user,
      mode          => $public_ssh_key_mode,
      path_template => $users::params::prefix_template
    },
    options => {
      normalize_path  => false,
      template_prefix => "${user_ssh_dir}/"
    },
    require => File["${definition_name}_ssh_dir"]
  }
  
  #---
    
  corl::exec { $definition_name:
    resources => {
      hosthash => {
        command  => "echo '${all_known_hosts}' | ${sha} | ${awk} > ${hosthash_file}",
        'unless' => "[ -f ${hosthash_file} ] && [ `${sha} ${hosthash_file} | ${awk}` = `echo '${all_known_hosts}' | ${sha} | ${awk} | ${sha} | ${awk}` ]"
      },
      known_hosts => {
        command     => "echo '${all_known_hosts}' | ${sed} | ssh-keyscan -H -f - > ${known_hosts_file}",
        refreshonly => true,
        subscribe   => 'hosthash'  
      }
    },
    defaults => {
      user  => $user,
      group => $user
    },
    require => [ Corl::File["${base_name}_skel"], File["${definition_name}_ssh_dir"] ]
  }
}
