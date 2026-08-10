---
title: Pipelines [UNRELEASED]
published: true
section: advanced
---

<{ :toc }>

In a web application you often want to run periodic tasks to send emails, process data or a similar repeating workflow. 

In Raindeer these are called pipelines, and they work a bit differently to traditional jobs in that they execute in the same memory as your application. This means that you get access to your entire application from inside a job, rather than going to the database in each step for results from the previous step.

> [!note]
> Pipelines are also known as jobs, workers, tasks, cron jobs/tasks, queues.

## Defining pipelines

```ruby
class UserUpdatePipeline < Pipeline
  def list
    # The first step produces a value.
  end

  def update(event: PipelineEvent)
    # Each subsequent step takes a value from the previous step and returns a new value.
  end

  def save(event: PipelineEvent)
    # The last step's return value is returned to the caller.
  end
end
```

## Calling pipelines

### Directly

Call a pipeline from anywhere:

```ruby
UserUpdatePipeline[:list, :update, :save]
```

### Intervals

In your pipeline definition you can just observe time itself:

```ruby
class UserUpdatePipeline < Pipeline
  observe Interval[every_minute: 3, hour: 2]
end
```

## Integrations

Job frameworks like Sidekiq have their place and Raindeer is completely open to integrating with these libraries.

Please consider contributing an integration to Raindeer.
