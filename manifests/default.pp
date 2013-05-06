
class users::default {

  /*$user_ensure               = 'present'
  $user_alt_groups           = []
  $user_allowed_ssh_key_type = 'rsa'
  $user_ssh_key_type         = 'rsa'
  $user_shell                = '/bin/bash'
  $user_system               = false*/

  $common_aliases = {
    'cd..'    => 'cd ..',
    'ls'      => 'ls --color=auto',
    'll'      => 'ls -l',
    'la'      => 'ls -al',
    'dir'     => 'ls --color=auto --format=vertical',
    'vdir'    => 'ls --color=auto --format=long',
    'free'    => 'free -m',
    'grep'    => 'grep --color=auto',
    'fgrep'   => 'fgrep --color=auto',
    'egrep'   => 'egrep --color=auto'
  }

  #---

  case $::operatingsystem {
    debian, ubuntu: {
      $root_profile_template = 'users/root/debian.profile.erb'
      $root_bashrc_template  = 'users/root/debian.bashrc.erb'

      $root_aliases = deep_merge($common_aliases, {
        'search'  => 'apt-cache search',
        'update'  => 'apt-get update',
        'install' => 'apt-get install',
        'upgrade' => 'apt-get upgrade',
        'remove'  => 'apt-get remove',
        'purge'   => 'apt-get purge'
      })

      $skel_profile_template = 'users/skel/debian.profile.erb'
      $skel_bashrc_template  = 'users/skel/debian.bashrc.erb'
    }
    default: {
      fail("The users module is not currently supported on ${::operatingsystem}")
    }
  }
}
