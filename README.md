# Pay it Forward
[![Build Status](https://img.shields.io/travis/asm-products/pay-it-forward.svg)](https://travis-ci.org/asm-products/pay-it-forward)
[![Code Climate](https://img.shields.io/codeclimate/github/asm-products/pay-it-forward.svg)](https://codeclimate.com/github/asm-products/pay-it-forward)
[![Coverage Status](https://img.shields.io/coveralls/asm-products/pay-it-forward.svg)](https://coveralls.io/r/asm-products/pay-it-forward)
[![Dependency Status](https://img.shields.io/gemnasium/asm-products/pay-it-forward.svg)](https://gemnasium.com/asm-products/pay-it-forward)

## Built With

Pay it Forward is built from the following open source components:

- [Ruby on Rails](https://github.com/rails/rails)
- [PostgreSQL](http://www.postgresql.org/)
- [jQuery](http://jquery.com/)
- [Bootstrap](https://github.com/twbs/bootstrap)

## Setup
#### Setup Backing Resources
- [Setup Postgres](https://wiki.postgresql.org/wiki/Detailed_installation_guides)
- Run `./bin/setup`
  - If you run into any error, configure the `.env` file and retry.

## Contributing
This project's git flow is based on [A successful Git branching model](http://nvie.com/posts/a-successful-git-branching-model/)

1. Find or Submit Bounty
2. Make a Feature Branch from `develop`
  - Name it based on bounty: `18-init-project`
3. Make Changes
  - Use micro commits
  - Use the imperative, present tense: "change", not "changed" or "changes".
4. Write tests
  - Will not accept PRs that reduce coverage
5. Open PR back into develop
  - Make PR Description links to the Bounty and add a comment to the Bounty linking the PR
