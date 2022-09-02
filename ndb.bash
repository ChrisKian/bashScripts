ndb() {
	if [ -z "$1" ]; then
		echo "Please add argument of MySQL DB schema name you'd like to drop and re-create."
		return
	fi

	mysql -uroot -ptest -D $1 -e "DROP DATABASE $1"
	
	mysql -uroot -ptest -e "CREATE SCHEMA $1 DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;"
}