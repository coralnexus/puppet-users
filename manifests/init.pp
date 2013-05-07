# Class: users
#
#   This module configures user environments and manages users.
#
#   Adrian Webb <adrian.webb@coraltech.net>
#   2012-05-22
#
#   Tested platforms:
#    - Ubuntu 12.04
#
# Parameters: (see <examples/params.json> for Hiera configurations)
#
# Actions:
#
#   Configures user environments and manages users.
#
#   Provides users::user() and users::conf() definitions.
#
# Requires:
#
# Sample Usage:
#
#   include users
#
class users inherits users::params {

  $base_name = $users::params::base_name

  #-----------------------------------------------------------------------------
  # Configuration

  coral::file { "${base_name}_skel":
    resources => {
      profile => {
        path    => $users::params::skel_profile_file,
        content => template($users::params::skel_profile_template)
      },
      bashrc => {
        path    => $users::params::skel_bashrc_file,
        content => template($users::params::skel_bashrc_template),
      },
      aliases => {
        path    => $users::params::skel_aliases_file,
        content => render($users::params::alias_template, $users::params::common_aliases),
      }
    },
    defaults => {
      owner => $users::params::root,
      group => $users::params::root
    }
  }

  #---

  users::conf { $users::params::root:
    label            => $users::params::root_label,
    email            => $users::params::root_email,
    home_dir         => $users::params::root_home_dir,
    profile_template => $users::params::root_profile_template,
    bashrc_template  => $users::params::root_bashrc_template,
    aliases          => $users::params::root_aliases,
    ssh_key_type     => $users::params::root_ssh_key_type,
    public_ssh_key   => $users::params::root_public_ssh_key,
    private_ssh_key  => $users::params::root_private_ssh_key,
    prompt           => $users::params::root_prompt,
    umask            => $users::params::root_umask
  }

  #-----------------------------------------------------------------------------
  # Actions

  coral::exec { $base_name: }

  #-----------------------------------------------------------------------------
  # Resources

  coral_resources('users::conf', "${base_name}::conf", "${base_name}::conf_defaults")
  coral_resources('users::user', "${base_name}::user", "${base_name}::user_defaults")
}
