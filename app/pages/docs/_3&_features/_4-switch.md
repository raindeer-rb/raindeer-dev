---
title: Dumb Dead Man's Switch [CONCEPT STAGE]
menu: Dead Man's Switch
published: true
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
- 👤 *Personal* - Use the same static site for your personal website and dead man's switch

**Requirements:**
- Repository must be private
- Server must not list directories (most don't)

## How it works

You define a period of time that you can be inactive for. If you build your static site again within this time period then your secret files are hidden. If you don't rebuild your site in that period of time then a person with the secret link can now view those files.

Secrecy is achieved by leading the person with the secret link on a wild goose chase through thousands of random files, with the final file revealing the data. These files take an entire month (configurable) to traverse, and if the site is rebuilt before the month is out then the final file will no longer be accessible.

The secret link can be random or a human-readable path for a trusted person that doesn't change. When you visit this link you will see a webpage with a loading bar that will process the random files over the defined period of time.

> ![note]
> Secret files must be loaded sequentially, as you don't know their file names and one leads to the other. Server farms can speed up this process but they can be [mitigated](#attack-mitigation).

## Basic Setup

✅ **Advantages:**
- Peace of mind that everything is working while you're around

❌ **Disadvantages:**
- Email can only be sent at the start of the inactivity period
- The "find time" is always equal to the inactivity period

In the basic setup you just click a build button or push a commit. Because there's no cron/jobs/workers requirement you can deploy to any server easily.

An email can be sent each time you build/delay your dead man's switch, notifying a trusted person(s) of the secret link. This email is optional... you could also put the link on a piece of paper.

The benefit of this setup is that there is need for CI or recurring periodical jobs, but the downside is that you can't send emails before the inactivity period is close to expiring or expires.

## Advanced Setup

✅ **Advantages:**
- Send emails whenever you want
- Reduce the "find time" by rebuilding more frequently

❌ **Disadvantages:**
- More moving parts, more to go wrong
- More setup time

Run daily jobs to keep your site up to date with exactly how long you've been inactive for. This reduces the "find time" of the secret links by generating less secret files for the trusted person to traverse through. It also allows you to send more meaningful emails; like "inactivity period about to be reached". These automatic daily rebuilds are different to the manual "I'm alive!" delay/build central to the concept of a Dead Man's Switch.

## Emails

Technically an email can be sent from your computer when you build the Dumb Dead Man's Switch, but you may want to use an email service for increased deliverability.

## Deployment

You can deploy static files to a custom server or a service like Cloudflare Pages. The destination environment will determine how many random secret files can be generated. For example, Cloudflare has a limit of 20,000 files per repo on their free plan, so we will export 15,000 files to this environment.

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

## Architecture

Each file name looks like this:
```
abc1234
```

Each file has the contents:
```
def5679
```

With this simple structure we can create a chain, where each file links to the next.

### File Limit

When there is a limit to how many files can be exported, each file will contain multiple hashes that all link to other files. The number of hashes per file must be less than the number of files, so that each file never links to itself. Each line will look like:
```
abc1234 1
```

...where `1` is the line number in the corresponding secret file to get the next hash from.

## Multiple Secrets

Multiple secrets could be shared with multiple emails/URLs, but this will increase the amount of secret files needed to be generated. A more "public key/private key" approach could be used to bring this number down but I'm not smart enough to achieve it yet currently.

## Configuration

### Global Config

- **file_limit** - Defaults to 15,000
- **file_delay** - If you set your server up to delay files by 2 seconds, 5 seconds etc... you can decrease the amount of files generated

### Per Secret Config

- **start_path** - Replace the default random path with a human-readable path that your trusted person can just go to any time.

## Building

To export `app/switch` to a static site run:
```bash
rain switch build
```

This exports secret files to `/public/secrets`. Each file name is so random that it would be near dang difficult to find the file by URL without knowing its name.
