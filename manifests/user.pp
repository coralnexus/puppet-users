
define users::user(

  $user                 = $name,
  $ensure               = 'present',
  $system               = false,
  $gid                  = undef,
  $group                = $name,
  $alt_groups           = [],
  $password             = '',
  $shell                = '/bin/bash',
  $home_dir             = undef,
  $file_mode            = $users::params::default_file_mode,
  $profile_file         = $users::params::profile_file,
  $profile_template     = $users::params::skel_profile_template,
  $bashrc_file          = $users::params::bashrc_file,
  $bashrc_template      = $users::params::skel_bashrc_template,
  $aliases_file         = $users::params::aliases_file,
  $alias_template       = $users::params::alias_template,
  $aliases              = $users::params::common_aliases,
  $ssh_dir              = $users::params::ssh_dir,
  $ssh_dir_mode         = $users::params::ssh_dir_mode,
  $allowed_ssh_key      = undef,
  $allowed_ssh_key_type = $users::params::default_ssh_key_type,
  $ssh_key_type         = $users::params::default_ssh_key_type,
  $public_ssh_key_mode  = $users::params::public_ssh_key_mode,
  $public_ssh_key       = undef,
  $private_ssh_key_mode = $users::params::private_ssh_key_mode,
  $private_ssh_key      = undef,
  $known_hosts          = [],
  $label                = $users::params::user_label,
  $email                = $users::params::user_email,
  $editor               = $users::params::editor,
  $umask                = $users::params::umask,
  $use_color            = $users::params::use_color,
  $prompt               = $users::params::prompt

) {
  $base_name       = $users::params::base_name
  $definition_name = name("${base_name}_user_${user}")

  $user_dir     = ensure($home_dir, $home_dir, "${users::params::home_dir}/${user}")
  $user_ssh_dir = ensure($ssh_dir, "${user_dir}/${ssh_dir}")

  #-----------------------------------------------------------------------------
  # User and home directory

  if ! defined(Group[$group]) {
    corl::group { $definition_name:
      resources => {
        primary => {
          name   => $group,
          gid    => $gid,
          ensure => $ensure,
          system => $system
        }
      },
      require => Corl::File["${base_name}_skel"]
    }
  }

  #---

  if ! defined(User[$user]) and ! defined(Users::Conf[$user]) {
    corl::user { $definition_name:
      resources => {
        primary => {
          name       => $user,
          password   => $password,
          gid        => $group,
          groups     => $alt_groups,
          comment    => $label,
          ensure     => $ensure,
          home       => $user_dir,
          managehome => true,
          shell      => $shell,
          system     => $system,
        }
      },
      require => Corl::Group[$definition_name]
    }

    #---

    users::conf { $user:
      home_dir             => $user_dir,
      mode                 => $file_mode,
      profile_file         => $profile_file,
      profile_template     => $profile_template,
      bashrc_file          => $bashrc_file,
      bashrc_template      => $bashrc_template,
      aliases_file         => $aliases_file,
      alias_template       => $alias_template,
      aliases              => $aliases,
      ssh_dir              => $ssh_dir,
      ssh_dir_mode         => $ssh_dir_mode,
      ssh_key_type         => $ssh_key_type,
      public_ssh_key_mode  => $public_ssh_key_mode,
      public_ssh_key       => $public_ssh_key,
      private_ssh_key_mode => $private_ssh_key_mode,
      private_ssh_key      => $private_ssh_key,
      known_hosts          => $known_hosts,
      label                => $label,
      email                => $email,
      editor               => $editor,
      umask                => $umask,
      use_color            => $use_color,
      prompt               => $prompt,
      require              => Corl::User[$definition_name]
    }
  }

  #---

  corl::ssh_authorized_key { $definition_name:
    resources => {
      primary => {
        name    => ensure($allowed_ssh_key, "${user}-${allowed_ssh_key_type}-key"),
        ensure  => 'present',
        key     => $allowed_ssh_key,
        type    => $allowed_ssh_key_type,
        target  => "${user_ssh_dir}/authorized_keys",
      }
    },
    defaults => { user => $user },
    require => Users::Conf[$user]
  }
}
