---
title: Dumb Dead Man's Switch [CONCEPT STAGE]
menu: Dead Man's Switch
---

<{ :toc }>

<p class="slogan">The world's first statically generated dead man's switch</p>

**How can a website know if you're dead?** It could email you and do something if you don't reply... but how can a static site tell if you're dead? It can't? The server-side has no mind and the client-side can't be trusted. Raindeer achieves the impossible; a static site that acts as a dead man's switch without any user input or inactivity logic, just by using the passage of time to create a trustless system.

> ![note]
> Raindeer is a dynamic web framework and could be used to make a **dynamic** dead man's switch too... but why trust a dynamic site to not break down when you're not around?

**Features:**
- 🌊 *Passive* - No logic deciding if you're inactive
- 👁️ *Trustless* - Not even the person with the secret link can access the site until the inactivity period is up
- 🍯 *Stable* - Static sites have less moving parts and less to go wrong

**Requirements:**
- Repository must be private
- Server must not list directories (most don't)

## How it works

You define a period of time that you can be inactive for. If you build your static site again within this time period then your secret files are hidden. If you don't rebuild your site in that period of time then a person with the secret link can now view those files.

Secrecy is achieved by leading the person with the secret link on a wild goose chase through thousands of random files, with the final file revealing the data. These files take an entire month (configurable) to traverse, and if the site is rebuilt before the month is out then the final file will no longer be accessible.

The secret link takes you to a web page with a loading bar that will process the random files over the defined period of time.

> ![note]
> Files have to be loaded sequentially, you don't know their file names and one leads to the other. Server farms can speed up this process but they can be [mitigated](#attack-mitigation).

## Basic Mode

In the most basic setup there is need for CI or recurring actions/workers/jobs, just click a build button or push a commit. Because there's no CI requirement you can deploy anywhere, even to your own custom server.

An email can be sent each time you build/delay your dead man's switch, notifying a trusted person of the secret link.

## Advanced Mode

Use CI to keep your site up to date with exactly how long you've been inactive for. This reduces the "find time" of the secret links and allows you to send more meaningful emails; like "inactivity period about to be reached".

## Emails

Technically an email can be sent from the computer you build the Dumb Dead Man's Switch on, but you may want to use an email service for increased deliverability.

## Deployment

You can deploy static files to a custom server or a service like CloudFlare Pages.

## Attack Mitigation

The Dumb Dead Man's Switch works on an assumption that only so many requests can be made to a server over a prolonged period of time; say 1 request from 1 IP address every 1 second. This assumption can be thwarted by server farms, so you may want to add additional protection. Simply configuring your secret files to take 1 second to download is enough to stop bad actors. Now whoever gets the secret link first will be the first one to reveal it's yummy gooey innards.

### Cloudflare

Add a Cloudflare Pages Function:

```js
// Place this code in "/functions/files/_middleware.js" (repo top level).
export async function onRequest(context) {
  const start = Date.now();
  const response = await context.next();
  const remaining = 1000 - (Date.now() - start);

  if (remaining > 0) {
    await new Promise((r) => setTimeout(r, remaining));
  }

  return response;
}
```

This limits requests to 100K a day (free plan), or roughly 3 hours worth of making very fast requests (10ms * 60s * 60m * 3 = 108K requests).
