# lucaa2000.github.io

Luca Deuschel's personal website, built with Jekyll and the [Chirpy theme](https://github.com/cotes2020/jekyll-theme-chirpy).

## Local development

Install the Ruby dependencies and start the development server:

```shell
bundle install
bash tools/run.sh
```

Run the production build and internal-link checks with:

```shell
bash tools/test.sh
```

## Updating the books page

The books page is generated from the committed `_data/goodreads_books.yml` snapshot. Refresh it from Luca's public Goodreads RSS feed, review the diff, and commit it with:

```shell
bundle exec ruby tools/update_goodreads.rb
git diff -- _data/goodreads_books.yml
```

Keeping the snapshot in the repository makes site builds reproducible and prevents a Goodreads outage from breaking a deployment.

## Deployment

Pushes to `main` are built, checked, and deployed to GitHub Pages by `.github/workflows/pages-deploy.yml`.

## License

The site is based on [Chirpy Starter](https://github.com/cotes2020/chirpy-starter) and remains available under the [MIT License](LICENSE).
