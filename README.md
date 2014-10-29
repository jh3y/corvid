[![Build Status](https://travis-ci.org/jh3y/corvid.svg)](https://travis-ci.org/jh3y/corvid)

Corvid
===

__Corvid__ is an interactive CLI github API browser and cloning aid available via npm (mouthful).

It allows you to search for users, search for repos and clone multiple repos at once from the command line.

    corvid -u jh3y -r corvid

![alt tag](https://raw.github.com/jh3y/pics/master/corvid/corvid.png)


##Install

    npm install -g corvid

##Usage
You can use corvid to browse users and repos whilst also cloning repos that you find using the following options.

![alt tag](https://raw.github.com/jh3y/pics/master/corvid/clone.png)

###Options
* `-a, --all` - use if expecting more than 100 results
* `-u, --username [username]` - git username
* `-r, --repos [count]` - defines flag for grabbing repos, repo name or number of repos for user
* `-i, --interactive` - enables interactive search criteria generation
* `-b, --bare` - return less information in results
* `-c, --clone` - provide interactive cloning of user/org repos
* `--sort [criteria]` - how to sort results [forks, stars, updated]
* `--order [order]` - how to order results [asc, desc]
* `-l, --limit [limit]` - limit the number of results [< 100]
* `--location [location]` - location for a user
* `--language [language]` - language for user or repo
* `--followers [followers]` - minimum amount of followers for a repo or user
* `-f, --forks [forks]` - minimum amount of forks for repo
* `-s, --stars [stars]` - minimum amount of stars for a repo

###Examples
* Top 5 repos for users twbs

      corvid -u twbs -r --limit 5

* Search for users named Tom with over 1000 followers

      corvid -u Tom --followers 1000

* Get data for user jh3y

      corvid -u jh3y

* Find users in New York who write CSS

      corvid -u --language CSS --location "New York"

* Find CoffeeScript repos with over 1000 stars ordered by last updated

      corvid -r --language CoffeeScript --stars 1000 --order updated


##Why make corvid?
To be honest, I was going to make a simple utility for cloning multiple git repositories at once for those that don't configure their own aliases on the command line.

But I've also been meaning to put something together using the Github API for a while and this seemed like the opportunity.

Some people might find it useful but of course you can just search on Github.

##Warning
Remember, that if you do plan on using __corvid__ it uses the public Github API and therefore you are limited to 60 requests per an hour when using the tool combined with any requests you make not with the tool.

##Contributions and Suggestions
Are of course always welcome, so please leave an issue or tweet me @_jh3y !

##TODO
* Implement Github API request quota checker.


@jh3y 2014
