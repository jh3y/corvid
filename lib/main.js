(function() {
  var colors, corvid, err, pkg, program;

  program = require('commander');

  colors = require('colors');

  pkg = require('../package.json');

  corvid = require('./corvid');

  program.version(pkg.version).option('-a, --all', 'use if more than 100 repos').option('-u, --username [username]', 'git username to be browsed').option('-r, --repos [count]', 'flag for grabbing repos and also defining number of repos for user').option('-i, --interactive', 'enables interactive search').option('-d, --detailed', 'return repo details').option('-o, --organisation [organisation]', 'git organisation to be browsed').option('-c, --clone', 'provide interactive cloning of defined user/org repos').option('--sort [criteria]', 'how to sort results [forks, stars, updated]').option('--order [order]', 'how to order results [asc, desc]').option('-l, --limit [limit]', 'limit the number of results [< 100]').option('--location [location]', 'a location for a user').option('--language [language]', 'a language used by a user or in a repo').option('--followers [followers]', 'amount of followers for a repo or user').option('-f, --forks [forks]', 'amount of forks for repo').option('-s, --stars [stars]', 'amount of stars for a repo');

  program.on('--help', function() {
    console.log('  Examples:');
    console.log('    $ ' + pkg.name + ' --username jh3y');
  });

  program.parse(process.argv);

  if (process.argv.length === 2) {
    program.help();
  } else {
    try {
      corvid.process({
        all: program.all,
        username: program.username,
        repos: program.repos,
        interactive: program.interactive,
        organisation: program.organisation,
        clone: program.clone,
        detailed: program.detailed,
        sort: program.sort,
        order: program.order,
        limit: program.limit,
        location: program.location,
        language: program.language,
        followers: program.followers,
        forks: program.forks,
        stars: program.stars
      });
    } catch (_error) {
      err = _error;
      console.log('[', 'corvid'.white, ']', err.toString().red);
    }
  }

}).call(this);
