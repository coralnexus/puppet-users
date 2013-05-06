
class users::params inherits users::default {

  $base_name = 'users'

  #---

  $home_dir                  = module_param('home_dir', '/home')

  $user_label                = module_param('user_label', 'User account')
  $user_email                = module_param('user_email')

  $editor                    = module_param('editor', 'vim')
  $umask                     = module_param('umask', '002')
  $use_color                 = module_param('use_color', 'yes')
  $prompt                    = module_param('prompt', '\[\033[01;32m\]\u\[\033[00m\]@\[\033[35m\]\t\[\033[00m\]:\[\033[01;34m\]\w')

  #---

  $default_file_mode         = module_param('default_file_mode', '0644')

  $profile_file              = module_param('profile_file', '.profile')
  $bashrc_file               = module_param('bashrc_file', '.bashrc')
  $aliases_file              = module_param('aliases_file', '.bash_aliases')
  $alias_template            = module_param('alias_template', 'Aliases')
  $common_aliases            = module_hash('common_aliases')

  $ssh_dir                   = module_param('ssh_dir', '.ssh')
  $ssh_dir_mode              = module_param('ssh_dir_mode', '0700')
  $public_ssh_key_mode       = module_param('public_ssh_key_mode', '0644')
  $private_ssh_key_mode      = module_param('private_ssh_key_mode', '0600')
  $default_ssh_key_type      = module_param('default_ssh_key_type', 'rsa')


  $skel_home_dir             = module_param('skel_home_dir', '/etc/skel')
  $skel_profile_file         = module_param('skel_profile_file', "${skel_home_dir}/${profile_file}")
  $skel_profile_template     = module_param('skel_profile_template')
  $skel_bashrc_file          = module_param('skel_bashrc_file', "${skel_home_dir}/${bashrc_file}")
  $skel_bashrc_template      = module_param('skel_bashrc_template')
  $skel_aliases_file         = module_param('skel_aliases_file', "${skel_home_dir}/${aliases_file}")

  $root                      = module_param('root', 'root')
  $root_name                 = module_param('root_name', 'Root account')
  $root_email                = module_param('root_email')
  $root_home_dir             = module_param('root_home_dir', '/root')
  $root_profile_template     = module_param('root_profile_template')
  $root_bashrc_template      = module_param('root_bashrc_template')
  $root_public_ssh_key       = module_param('root_public_ssh_key')
  $root_private_ssh_key      = module_param('root_private_ssh_key')
  $root_ssh_key_type         = module_param('root_ssh_key_type', 'rsa')
  $root_umask                = module_param('root_umask', '022')
  $root_prompt               = module_param('root_prompt', '\[\033[01;31m\]\u\[\033[00m\]@\[\033[35m\]\t\[\033[00m\]:\[\033[01;34m\]\w')
  $root_aliases              = module_hash('root_aliases')

  #---

  $user_ensure               = module_param('user_ensure')
  $user_gid                  = module_param('user_gid')
  $user_group                = module_param('user_group')
  $user_alt_groups           = module_array('user_alt_groups')
  $user_email                = module_param('user_email')
  $user_comment              = module_param('user_comment')
  $user_allowed_ssh_key      = module_param('user_allowed_ssh_key')
  $user_allowed_ssh_key_type = module_param('user_allowed_ssh_key_type')
  $user_public_ssh_key       = module_param('user_public_ssh_key')
  $user_private_ssh_key      = module_param('user_private_ssh_key')
  $user_ssh_key_type         = module_param('user_ssh_key_type')
  $user_password             = module_param('user_password')
  $user_shell                = module_param('user_shell')
  $user_system               = module_param('user_system')
}
