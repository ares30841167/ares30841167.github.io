# hexo-blog

Personal Hexo blog for `https://blog.guanyu.dev`, built with Hexo 7 and the Next theme.

## Features
- Hexo 7.x static site generation
- Next theme in `themes/next`
- Search index via `hexo-generator-searchdb`
- Sitemap via `hexo-generator-sitemap`
- Tag cloud via `hexo-tag-cloud`
- Hidden posts support via `hexo-hide-posts`

## Requirements
- Node.js (matches `Dockerfile` base image `node:25.6.1` or any recent LTS)
- npm or yarn

## Setup
```bash
npm install
npm run server
```

Or with yarn:
```bash
yarn install
yarn server
```

The site will be available at `http://localhost:4000`.

## Scripts
- `npm run server` - start the local dev server
- `npm run build` - generate static files into `public/`
- `npm run clean` - clean the generated files
- `npm run deploy` - deploy (requires deploy config in `_config.yml`)

## Project Structure
- `_config.yml` - site configuration
- `source/` - posts, pages, and assets
- `themes/next/` - active theme
- `public/` - generated output (do not edit by hand)

## Docker
Build the image:
```bash
docker build -t hexo .
```

Run the container and mount the repo:
```bash
docker run -it --rm -p 127.0.0.1:3000:4000 -v "${PWD}:/Hexo" hexo
```

Inside the container:
```bash
npm install
npm run server
```
