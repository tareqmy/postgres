if [ $# -lt 1 ]
then
    echo "provide destination database name"
    exit 1;
fi

echo "deleting $1 if exists"
dropdb -U $POSTGRES_USER $1
echo "backing up $POSTGRES_DB to $1"
createdb -U $POSTGRES_USER -O $POSTGRES_USER -T $POSTGRES_DB $1
echo "done"
