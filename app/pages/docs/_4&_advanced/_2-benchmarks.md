---
title: Benchmarks
published: false
---

> ![note]
> **Requests Per Second:** This CPU-bound metric is a relatively small slice of time in comparison to the IO-bound tasks of web applications, such as waiting for the database.

## Raindeer VS Roda

> ![warn]
> Raindeer does **extra THINGS!**, so this is not an apples-to-apples comparison

In addition to routing, Raindeer also does:
- Events + Event Tree for Terminal and Web UI
- Observers
- Logging [UNRELEASED]
- Type checking [OPTIONAL]
