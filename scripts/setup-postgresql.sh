# postgresql.sh

function createdb-if-needed {
    for dbname in $@; do
        $(psql -l | grep -q "$dbname") || createdb "$dbname"
    done
}

function dropdb-if-needed {
    for dbname in $@; do
        $(psql -l | grep -q "$dbname") && dropdb "$dbname"
    done
}

if [ ! -e ~/.setup/postgresql ]; then
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
    echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" |sudo tee  /etc/apt/sources.list.d/pgdg.list
    apt-install-if-needed postgresql-12 postgresql-contrib-12 \
        postgresql-doc-12 postgresql-server-dev-12

    sudo -u postgres createuser --superuser $USER &> /dev/null
    sudo -u postgres createdb $USER &> /dev/null

    touch ~/.setup/postgresql
fi

