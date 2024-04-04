`swift-otel` has a bug that causes it to take 30 seconds to shut down.

You can reproduce it using the following command:

```sh
$ swift run run cmd
```

This command only call a `print`, but it takes time to finish.

This phenomenon occurs when the otel exporter fails to connect.
It will finish immediately if Jaeger is started as follows. 
A `docker-compose.yml` for this purpose is available in this repository.

In the first terminal window: 

```sh
$ docker compose up
```

In the second terminal window:

```sh
$ swift run run cmd
```

Also, by increasing the log level as shown below, you can get hints about the situation.

```sh
$ LOG_LEVEL=debug swift run run cmd
```

This issue has been submitted as a report to the official repository.

https://github.com/slashmo/swift-otel/issues/111
