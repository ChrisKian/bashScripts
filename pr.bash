pr() {
        if [ -n "$1" -a -n "$2" ]
        then
                git fetch -n git@github.com:"$1"/liferay-portal"$4".git "$2"

                if [ -n "$3" ]
                then
                        git checkout .
                        git clean -df
                        git reset --hard
                        git checkout FETCH_HEAD
                        git checkout -B "$3"
                fi
        else
                echo First argument is githubId, second is branch name, third is new branch name, fourth (optional) is -ee
				echo Example: pr ChrisKian LPS-12345 pr-LPS-12345 -ee
        fi
}