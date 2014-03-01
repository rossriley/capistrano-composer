set :composer_install_flags, '--no-dev --prefer-dist --no-scripts --quiet --optimize-autoloader'
set :composer_roles, :all
set :composer_dump_autoload_flags, '--optimize'
set :composer_download_url, "https://getcomposer.org/installer"