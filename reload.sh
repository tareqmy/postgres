if [ $# -lt 1 ]
then
    echo "provide source database name"
    exit 1;
fi

echo "deleting $POSTGRES_DB"
dropdb -U $POSTGRES_USER $POSTGRES_DB
echo "loading from backup $1"
createdb -U $POSTGRES_USER -O $POSTGRES_USER -T $1 $POSTGRES_DB
echo "done"
