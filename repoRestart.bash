APP_SERVER_PROPS_FILENAME="app.server.liferay.properties"

gitCleanup() {
	git checkout .
	git clean -df
	git reset --hard
}

getAppServerType() {
	file="./${APP_SERVER_PROPS_FILENAME}"

	local retval=`grep "app.server.type" ${file} | cut -d'=' -f2`

	#Use the default value of tomcat if cannot find property
	if [ -z "$retval" ]; then
		retval=tomcat
	fi
	
	echo $retval
}

resetMySQLDB() {
	file="./${APP_SERVER_PROPS_FILENAME}"
	
	local dbName=`grep "db.name" ${file} | cut -d'=' -f2`
        
	if [ -z "$dbName" ]; then
		echo "Please set db.name value in app.server.USERNAME.properties file.  Once set, you can run just the resetMySQLDB method."
		return
	fi

	mysql -uroot -ptest -D $dbName -e "DROP DATABASE $dbName"
	
	mysql -uroot -ptest -e "CREATE SCHEMA $dbName DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;"
}

repoRestart() {
	if [ -z ${APP_SERVER_PROPS_FILENAME} ]; then
		echo "Please set APP_SERVER_PROPS_FILENAME value in bashrc"
		return
	fi

	file="./${APP_SERVER_PROPS_FILENAME}"
	
	local baseBranch=`grep "base.branch" ${file} | cut -d'=' -f2`
        
	if [ -z "$baseBranch" ]; then
		echo "Please set base.branch value in app.server.USERNAME.properties file."
		return
	fi


	read -p "Uncommitted changes will be lost.  Continue (y/n)? " ANSWER
	if [ $ANSWER != 'y' ] && [ $ANSWER != 'Y' ]; then
		return
	fi

	gitCleanup

	# checkout, fetch, and merge
	
	git checkout $baseBranch
	if [ $? -ne 0 ]; then
		echo "Could not checkout $baseBranch"
		return
	fi
	
	gitCleanup

	git fetch -n upstream $baseBranch
	if [ $? -ne 0 ]; then
		echo "Could not pull $baseBranch"
		return
	fi

	git merge upstream/$baseBranch
	if [ $? -ne 0 ]; then
		echo "Could not merge local and upstream $baseBranch branches"
		return
	fi
	
	gitCleanup
	
	ant -buildfile build-dist.xml unzip-"$(getAppServerType)"
	if [ $? -ne 0 ]; then
		echo "Error unzipping the app server files"
		return
	fi
	
	ant all
	if [ $? -ne 0 ]; then
		echo "Error running ant all"
		return
	fi

	read -p "Would you also like to reset MySQL schema (y/n)? " ANSWER
	if [ $ANSWER != 'y' ] && [ $ANSWER != 'Y' ]; then
		return
	fi

	resetMySQLDB
}