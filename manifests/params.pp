
class users::params {

  $base_name = 'users'

  #---

  $home_dir = module_param('home_dir', '/home')

  $user_label = module_param('user_label', 'User account')
  $user_email = module_param('user_email')

  $editor    = module_param('editor', 'vim')
  $umask     = module_param('umask', '002')
  $use_color = module_param('use_color', 'yes')
  $prompt    = module_param('prompt', '\[\033[01;32m\]\u\[\033[00m\]@\[\033[35m\]\t\[\033[00m\]:\[\033[01;34m\]\w')

  #---

  $default_file_mode = module_param('default_file_mode', '0644')

  $profile_file   = module_param('profile_file', '.profile')
  $bashrc_file    = module_param('bashrc_file', '.bashrc')
  $aliases_file   = module_param('aliases_file', '.bash_aliases')
  $alias_template = module_param('alias_template', 'aliases')
  $common_aliases = module_hash('common_aliases')

  $ssh_dir              = module_param('ssh_dir', '.ssh')
  $ssh_dir_mode         = module_param('ssh_dir_mode', '0700')
  $public_ssh_key_mode  = module_param('public_ssh_key_mode', '0644')
  $private_ssh_key_mode = module_param('private_ssh_key_mode', '0600')
  $default_ssh_key_type = module_param('default_ssh_key_type', 'rsa')

  $hosthash_file    = module_param('hosthash_file', 'host_hash')
  $sed              = module_param('sed', "sed 's/,/\\n/g'")
  $sha              = module_param('sha', "sha512sum")
  $awk              = module_param('awk', "awk '{ print \$1 }'")
  $hash             = module_param('hash', "sha512sum | ${awk}")
  $known_hosts_file = module_param('known_hosts_file', 'known_hosts')
  $known_hosts      = module_array('known_hosts')

  $skel_home_dir         = module_param('skel_home_dir', '/etc/skel')
  $skel_profile_file     = module_param('skel_profile_file', "${skel_home_dir}/${profile_file}")
  $skel_profile_template = module_param('skel_profile_template')
  $skel_bashrc_file      = module_param('skel_bashrc_file', "${skel_home_dir}/${bashrc_file}")
  $skel_bashrc_template  = module_param('skel_bashrc_template')
  $skel_aliases_file     = module_param('skel_aliases_file', "${skel_home_dir}/${aliases_file}")

  $root                  = module_param('root', 'root')
  $root_label            = module_param('root_label', 'Root account')
  $root_email            = module_param('root_email')
  $root_home_dir         = module_param('root_home_dir', '/root')
  $root_profile_template = module_param('root_profile_template')
  $root_bashrc_template  = module_param('root_bashrc_template')
  $root_public_ssh_key   = module_param('root_public_ssh_key')
  $root_private_ssh_key  = module_param('root_private_ssh_key')
  $root_ssh_key_type     = module_param('root_ssh_key_type', 'rsa')
  $root_known_hosts      = module_array('root_known_hosts')
  $root_umask            = module_param('root_umask', '022')
  $root_prompt           = module_param('root_prompt', '\[\033[01;31m\]\u\[\033[00m\]@\[\033[35m\]\t\[\033[00m\]:\[\033[01;34m\]\w')
  $root_aliases          = module_hash('root_aliases')
}
