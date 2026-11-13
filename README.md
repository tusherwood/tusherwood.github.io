# personal-website

My academic website. Built with [Jekyll](https://jekyllrb.com/) on the [al-folio](https://github.com/alshedivat/al-folio) theme, deployed to GitHub Pages by GitHub Actions from `tru489/personal-website`.

> **Heads up — the URL config doesn't match the repo yet.** [\_config.yml](_config.yml) declares `url: https://thomas-usherwood.github.io` with an empty `baseurl`, but the repo is `tru489/personal-website`, so Pages serves it at `https://tru489.github.io/personal-website/` (neither URL responds yet — Pages likely still needs enabling on the `gh-pages` branch). Pick one and set both keys together:
>
> - **Project site** (no rename needed): `url: https://tru489.github.io` + `baseurl: /personal-website/`
> - **User site**: rename the repo to `tru489.github.io`, then `url: https://tru489.github.io` + `baseurl: ""`
> - **Custom domain**: keep `baseurl: ""`, set `url:` to the domain, and add a `CNAME` file
>
> Getting these wrong breaks every CSS and image path on the deployed site (it looks fine locally either way).

## Run it locally

```bash
./bin/serve.sh
```

Serves on <http://localhost:8080> with live reload — save a file and the browser refreshes itself. The raw command, if you'd rather type it:

```bash
bundle exec jekyll serve --livereload --port 8080
```

Ctrl-C to stop. Optional args: `./bin/serve.sh 4000` for a different port, and anything else (e.g. `--drafts`) is passed through to `jekyll serve`.

**Changes to `_config.yml` are not live-reloaded** — stop and restart the server for those.

### First-time setup

```bash
brew install ruby imagemagick   # imagemagick generates the responsive .webp images
bundle install                  # gems from the Gemfile (serve.sh does this if needed)
```

For the CV, and only if you're regenerating the PDF:

```bash
pip install -r requirements.txt   # rendercv, nbconvert, scholarly
```

### Docker alternative

If the Ruby toolchain ever breaks, the theme ships a Docker setup that serves the same thing on port 8080 with live reload:

```bash
docker compose up          # add --build after changing the Dockerfile or Gemfile
docker compose down        # stop and free the port
```

Slower to start, but it needs no local Ruby, gems, or imagemagick. Docker isn't currently installed on this machine — `./bin/serve.sh` is the working path.

## Where things live

| What                    | File / directory                                       |
| ----------------------- | ------------------------------------------------------ |
| About page + bio text   | [\_pages/about.md](_pages/about.md)                    |
| Site-wide settings      | [\_config.yml](_config.yml)                            |
| Publications            | [\_bibliography/papers.bib](_bibliography/papers.bib)  |
| CV content (RenderCV)   | [\_data/cv.yml](_data/cv.yml)                          |
| CV PDF linked from /cv/ | [assets/pdf/tru_resume.pdf](assets/pdf/tru_resume.pdf) |
| News / announcements    | [\_news/](_news/)                                      |
| Blog posts              | [\_posts/](_posts/)                                    |
| Projects                | [\_projects/](_projects/)                              |
| Nav pages               | [\_pages/](_pages/)                                    |
| Profile picture         | `assets/img/prof_pic.jpg`                              |
| Social links / email    | [\_data/socials.yml](_data/socials.yml)                |

Nav bar contents are controlled per-page by the `nav: true` and `nav_order:` keys in each page's front matter — currently blog, CV, projects, publications, and repositories.

### The CV page

`_pages/cv.md` sets `cv_format: rendercv`, so the rendered page comes from [\_data/cv.yml](_data/cv.yml). The download button points at `cv_pdf: /assets/pdf/tru_resume.pdf` — a hand-maintained PDF, _not_ the RenderCV output. Editing `_data/cv.yml` triggers [render-cv.yml](.github/workflows/render-cv.yml), which writes a PDF into `assets/rendercv/rendercv_output/` and commits it; that output is currently the leftover `Albert_Einstein_CV.pdf` and isn't what the site links to. Keep updating `tru_resume.pdf` by hand, or point `cv_pdf` at the RenderCV output once `_data/cv.yml` is fully yours.

### Adding a publication

Append a BibTeX entry to [\_bibliography/papers.bib](_bibliography/papers.bib). Useful non-standard fields al-folio understands: `abbr`, `selected={true}` (surfaces it on the about page), `pdf`, `html`, `code`, `bibtex_show={true}`, `award`.

Author-name bolding comes from `scholar.last_name` / `scholar.first_name` in [\_config.yml](_config.yml), currently `[Usherwood]` / `[Thomas, T.]`. Note that entries where the bib spells you `Usherwood, Thomas R.` are **not** matched — add `Thomas R.` to `first_name` (or drop the middle initial in the bib) to bold those too.

### Adding a news item

Drop a file in [\_news/](_news/) following the pattern in `announcement_1.md` — `inline: true` renders the text directly in the news list on the about page.

## Before committing

```bash
npx prettier . --write   # formats md/yml/liquid/js; CI fails on unformatted files
```

Needs Node — `brew install node` if `npx` isn't found. Then check the local server for the pages you touched.

## Deployment

Pushing to `main` triggers [.github/workflows/deploy.yml](.github/workflows/deploy.yml), which builds with `JEKYLL_ENV=production`, purges unused CSS, and pushes the result to the `gh-pages` branch. Nothing to do by hand — just push. Watch the run under the Actions tab if the live site doesn't update.

Other workflows worth knowing about: `prettier.yml` (formatting check), `broken-links.yml` (link checker), `render-cv.yml` (rebuilds the CV PDF via RenderCV), `update-citations.yml` (refreshes citation counts).

## Theme leftovers

This started from the al-folio template, so example content is still around: `_posts/` is all theme demo posts, `_projects/1_project.md` … `9_project.md` are placeholders, `_data/cv.yml` has commented-out Einstein entries, and `_config.yml` still carries template defaults — `description`, `blog_name: al-folio`, `keywords`, `disqus_shortname`, and the `external_sources` medium.com/Google feeds. Also note `enable_darkmode: false`, so the light/dark toggle is off.

Theme documentation, kept from upstream: [CUSTOMIZE.md](CUSTOMIZE.md) (how features are configured), [INSTALL.md](INSTALL.md), [TROUBLESHOOTING.md](TROUBLESHOOTING.md), [FAQ.md](FAQ.md), [ANALYTICS.md](ANALYTICS.md), [SEO.md](SEO.md), [QUICKSTART.md](QUICKSTART.md).

## License

Site content © Thomas Usherwood. The underlying al-folio theme is [MIT licensed](LICENSE).
