namespace :composer do
  desc "Installs composer to the shared directory"
  task :install_executable do
    on roles fetch(:composer_roles) do
      within fetch(:shared_path) do
        unless test "[", "-e", "#{fetch(:composer_filename)}", "]"
          composer_version = fetch(:composer_version, nil)
          composer_version_option = composer_version ? "-- --version=#{composer_version}" : ""
          composer_filename_option = "--  --filename=#{fetch(:composer_filename)}"
          execute :curl, "-s", fetch(:composer_download_url), "|", :php, composer_version_option, composer_filename_option
        end
      end
    end
  end

  task :run, :command do |t, args|
    args.with_defaults(:command => :list)
    on roles fetch(:composer_roles) do
      within fetch(:release_path) do
        execute "./#{fetch(:composer_filename)}", args[:command], *args.extras
      end
    end
  end

  desc <<-DESC
        Install the project dependencies via Composer. By default, require-dev \
        dependencies will not be installed.

        You can override any of the defaults by setting the variables shown below.

          set :composer_install_flags, '--no-dev --no-scripts --quiet --optimize-autoloader'
          set :composer_roles, :all
    DESC
  task :install do
    invoke "composer:run", :install, fetch(:composer_install_flags)
  end

  task :dump_autoload do
    invoke "composer:run", :dumpautoload, fetch(:composer_dump_autoload_flags)
  end

  desc <<-DESC
        Run the self-update command for composer.phar

        You can update to a specific release by setting the variables shown below.

          set :composer_version, '1.0.0-alpha8'
    DESC
  task :self_update do
    invoke "composer:run", :selfupdate, fetch(:composer_version, '')
  end

end


namespace :load do
  task :defaults do
    set :composer_install_flags, '--no-dev --prefer-dist --no-scripts --optimize-autoloader'
    set :composer_roles, :all
    set :composer_dump_autoload_flags, '--optimize'
    set :composer_download_url, "https://getcomposer.org/installer"
    set :composer_filename, "composer"
  end
end