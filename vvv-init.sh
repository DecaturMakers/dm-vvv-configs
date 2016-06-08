# Init script for WordPress trunk site

echo "Commencing Decatur Makers WordPress Setup"

# Make a database, if we don't already have one
echo "Creating database (if it's not already there)"
mysql -u root --password=root -e "CREATE DATABASE IF NOT EXISTS wordpress_decaturmakers"
mysql -u root --password=root -e "GRANT ALL PRIVILEGES ON wordpress_decaturmakers.* TO wp@localhost IDENTIFIED BY 'wp';"
echo "Database created"

# Check for the presence of a `htdocs` folder.
if [ ! -d htdocs ]
then
    echo "Cloning WordPress via Git"
    # If `htdocs` folder doesn't exist, check out WordPress
    # as that folder
    git clone --recursive git@github.com:DecaturMakers/DecaturMakers.org.git htdocs
    # Change into the `htdocs` folder we've checked SVN out into
    cd htdocs/wp
    # Use WP CLI to create a `wp-config.php` file
     wp core config --dbname="wordpress_decaturmakers" --dbuser=wp --dbpass=wp --dbhost="localhost" --allow-root
    # Use WP CLI to install WordPress
    wp core install --url=decaturmakers.dev --title="Decatur Makers Development WordPress" --admin_user=admin --admin_password=password --admin_email=demo@example.com --allow-root
    # Change folder to the parent folder of `htdocs`
    cd ../..
else
    echo "Updating Decatur Makers WordPress"
    # If the `htdocs` folder exists, then run update master
    cd htdocs
    git pull origin master
    echo "Updating Decatur Makers Website Codebase to latest version"
    git submodule init
    git submodule update
    echo "updating wp submodule"
fi

# The Vagrant site setup script will restart Nginx for us

# Let the user know the good news
echo "Decatur Makers WordPress now installed";

