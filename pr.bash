pr() {
	if [ -n "$1" ]; then

		if [ -n "$2" ] && [ "$2" != '-ee' ] ; then
			echo "Second argument must either be blank for public repo, or \"-ee\" for private repo."
			return
		fi

		local user=$( echo "$1" | cut -d ":" -f 1 )
		local branch=$( echo "$1" | cut -d ":" -f 2 )

		git fetch -n git@github.com:"$user"/liferay-portal"$2".git "$branch":"$branch"
		if [ $? -ne 0 ]; then
			echo "Could not fetch branch from specified user.  Please check your input values and try again."
			return
		fi

		read -p "Clear current repo and checkout fetched branch (y/n)?  (Unsaved changes will be lost): " ANSWER
		if [ $ANSWER == 'y' ] || [ $ANSWER == 'Y' ]; then
			git checkout .
			git clean -df
			git reset --hard
			git checkout "$branch"
		fi

		read -p "Push branch to Github (y/n)?: " ANSWER
		if [ $ANSWER != 'y' ] && [ $ANSWER != 'Y' ]; then
			return
		fi

		git push $([[ -n "$2" ]] && echo "origin" || echo "pr") "$branch"
		if [ $? -ne 0 ]; then
			echo "Could not push branch to github."
			return
		fi

		read -p "Would you like to submit a pull request (y/n)?: " ANSWER
		if [ $ANSWER != 'y' ] && [ $ANSWER != 'Y' ]; then
			return
		fi

		read -p "Cool!  What's the user you'd like to send to?: " REVIEWER

		read -p "And what's the base branch?  (Common examples include master, 7.3.x, 7.2.x): " BASEBRANCH

		local gitUserName=$( git config user.name)

		echo "Ok, the best I can do (for now) is generate a link for you.  Enjoy!"
		echo "###"
		echo "https://github.com/"$REVIEWER"/liferay-portal"$2"/compare/"$BASEBRANCH"..."$gitUserName":liferay-portal"$2":"$branch"?expand=1"
		echo "###"
	else
		echo "First argument is githubId:branchName, second (optional) is -ee"
		echo "Example: prNew ChrisKian:LPS-12345 -ee"
	fi
}