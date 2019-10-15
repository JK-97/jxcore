
[global_tags]
  # dc = "us-east-1" # will tag all metrics with dc=us-east-1
  # rack = "1a"
  ## Environment variables can be used as tags, and throughout the config file
  # user = "$USER"


# Configuration for telegraf agent
[agent]
  ## Default data collection interval for all inputs
  interval = "10s"
  ## Rounds collection interval to 'interval'
  ## ie, if interval="10s" then always collect on :00, :10, :20, etc.
  round_interval = true

  ## Telegraf will send metrics to outputs in batches of at most
  ## metric_batch_size metrics.
  ## This controls the size of writes that Telegraf sends to output plugins.
  metric_batch_size = 1000

  ## For failed writes, telegraf will cache metric_buffer_limit metrics for each
  ## output, and will flush this buffer on a successful write. Oldest metrics
  ## are dropped first when this buffer fills.
  ## This buffer only fills when writes fail to output plugin(s).
  metric_buffer_limit = 10000

  ## Collection jitter is used to jitter the collection by a random amount.
  ## Each plugin will sleep for a random time within jitter before collecting.
  ## This can be used to avoid many plugins querying things like sysfs at the
  ## same time, which can have a measurable effect on the system.
  collection_jitter = "0s"

  ## Default flushing interval for all outputs. Maximum flush_interval will be
  ## flush_interval + flush_jitter
  flush_interval = "20s"
  ## Jitter the flush interval by a random amount. This is primarily to avoid
  ## large write spikes for users running a large number of telegraf instances.
  ## ie, a jitter of 5s and interval 10s means flushes will happen every 10-15s
  flush_jitter = "0s"

  ## By default or when set to "0s", precision will be set to the same
  ## timestamp order as the collection interval, with the maximum being 1s.
  ##   ie, when interval = "10s", precision will be "1s"
  ##       when interval = "250ms", precision will be "1ms"
  ## Precision will NOT be used for service inputs. It is up to each individual
  ## service input to set the timestamp at the appropriate precision.
  ## Valid time units are "ns", "us" (or "µs"), "ms", "s".
  precision = ""

  ## Logging configuration:
  ## Run telegraf with debug log messages.
  debug = false
  ## Run telegraf in quiet mode (error log messages only).
  quiet = false
  ## Specify the log file name. The empty string means to log to stderr.
  logfile = ""

  ## Override default hostname, if empty use os.Hostname()
  hostname = "{{.WORKER_ID}}"
  ## If set to true, do no set the "host" tag in the telegraf agent.
  omit_hostname = false


###############################################################################
#                            OUTPUT PLUGINS                                   #
###############################################################################

# Configuration for sending metrics to InfluxDB
[[outputs.influxdb]]
  ## The full HTTP or UDP URL for your InfluxDB instance.
  ##
  ## Multiple URLs can be specified for a single cluster, only ONE of the
  ## urls will be written to each interval.
  # urls = ["unix:///var/run/influxdb.sock"]
  # urls = ["udp://127.0.0.1:8089"]
   urls = ["http://127.0.0.1:8086"]

  ## The target database for metrics; will be created as needed.
   database = "telegraf"

[[outputs.influxdb]]
  ## The full HTTP or UDP URL for your InfluxDB instance.
  ##
  ## Multiple URLs can be specified for a single cluster, only ONE of the
  ## urls will be written to each interval.
  # urls = ["unix:///var/run/influxdb.sock"]
  # urls = ["udp://127.0.0.1:8089"]
   urls = ["http://{{.MASTER_IP}}:8086"]

  ## The target database for metrics; will be created as needed.
   database = "telegraf"

  ## If true, no CREATE DATABASE queries will be sent.  Set to true when using
  ## Telegraf with a user without permissions to create databases or when the
  ## database already exists.
  # skip_database_creation = false

  ## Name of existing retention policy to write to.  Empty string writes to
  ## the default retention policy.  Only takes effect when using HTTP.
  # retention_policy = ""

  ## Write consistency (clusters only), can be: "any", "one", "quorum", "all".
  ## Only takes effect when using HTTP.
  # write_consistency = "any"

  ## Timeout for HTTP messages.
  # timeout = "5s"

  ## HTTP Basic Auth
  # username = "telegraf"
  # password = "metricsmetricsmetricsmetrics"

  ## HTTP User-Agent
  # user_agent = "telegraf"

  ## UDP payload size is the maximum packet size to send.
  # udp_payload = "512B"

  ## Optional TLS Config for use on HTTP connections.
  # tls_ca = "/etc/telegraf/ca.pem"
  # tls_cert = "/etc/telegraf/cert.pem"
  # tls_key = "/etc/telegraf/key.pem"
  ## Use TLS but skip chain & host verification
  # insecure_skip_verify = false

  ## HTTP Proxy override, if unset values the standard proxy environment
  ## variables are consulted to determine which proxy, if any, should be used.
  # http_proxy = "http://corporate.proxy:3128"

  ## Additional HTTP headers
  # http_headers = {"X-Special-Header" = "Special-Value"}

  ## HTTP Content-Encoding for write request body, can be set to "gzip" to
  ## compress body or "identity" to apply no encoding.
  # content_encoding = "identity"

  ## When true, Telegraf will output unsigned integers as unsigned values,
  ## i.e.: "42u".  You will need a version of InfluxDB supporting unsigned
  ## integer values.  Enabling this option will result in field type errors if
  ## existing data has been written.
  # influx_uint_support = false


# # Configuration for Amon Server to send metrics to.
# [[outputs.amon]]
#   ## Amon Server Key
#   server_key = "my-server-key" # required.
#
#   ## Amon Instance URL
#   amon_instance = "https://youramoninstance" # required
#
#   ## Connection timeout.
#   # timeout = "5s"


# # Publishes metrics to an AMQP broker
# [[outputs.amqp]]
#   ## Broker to publish to.
#   ##   deprecated in 1.7; use the brokers option
#   # url = "amqp://localhost:5672/influxdb"
#
#   ## Brokers to publish to.  If multiple brokers are specified a random broker
#   ## will be selected anytime a connection is established.  This can be
#   ## helpful for load balancing when not using a dedicated load balancer.
#   brokers = ["amqp://localhost:5672/influxdb"]
#
#   ## Maximum messages to send over a connection.  Once this is reached, the
#   ## connection is closed and a new connection is made.  This can be helpful for
#   ## load balancing when not using a dedicated load balancer.
#   # max_messages = 0
#
#   ## Exchange to declare and publish to.
#   exchange = "telegraf"
#
#   ## Exchange type; common types are "direct", "fanout", "topic", "header", "x-consistent-hash".
#   # exchange_type = "topic"
#
#   ## If true, exchange will be passively declared.
#   # exchange_declare_passive = false
#
#   ## Exchange durability can be either "transient" or "durable".
#   # exchange_durability = "durable"
#
#   ## Additional exchange arguments.
#   # exchange_arguments = { }
#   # exchange_arguments = {"hash_propery" = "timestamp"}
#
#   ## Authentication credentials for the PLAIN auth_method.
#   # username = ""
#   # password = ""
#
#   ## Auth method. PLAIN and EXTERNAL are supported
#   ## Using EXTERNAL requires enabling the rabbitmq_auth_mechanism_ssl plugin as
#   ## described here: https://www.rabbitmq.com/plugins.html
#   # auth_method = "PLAIN"
#
#   ## Metric tag to use as a routing key.
#   ##   ie, if this tag exists, its value will be used as the routing key
#   # routing_tag = "host"
#
#   ## Static routing key.  Used when no routing_tag is set or as a fallback
#   ## when the tag specified in routing tag is not found.
#   # routing_key = ""
#   # routing_key = "telegraf"
#
#   ## Delivery Mode controls if a published message is persistent.
#   ##   One of "transient" or "persistent".
#   # delivery_mode = "transient"
#
#   ## InfluxDB database added as a message header.
#   ##   deprecated in 1.7; use the headers option
#   # database = "telegraf"
#
#   ## InfluxDB retention policy added as a message header
#   ##   deprecated in 1.7; use the headers option
#   # retention_policy = "default"
#
#   ## Static headers added to each published message.
#   # headers = { }
#   # headers = {"database" = "telegraf", "retention_policy" = "default"}
#
#   ## Connection timeout.  If not provided, will default to 5s.  0s means no
#   ## timeout (not recommended).
#   # timeout = "5s"
#
#   ## Optional TLS Config
#   # tls_ca = "/etc/telegraf/ca.pem"
#   # tls_cert = "/etc/telegraf/cert.pem"
#   # tls_key = "/etc/telegraf/key.pem"
#   ## Use TLS but skip chain & host verification
#   # insecure_skip_verify = false
#
#   ## If true use batch serialization format instead of line based delimiting.
#   ## Only applies to data formats which are not line based such as JSON.
#   ## Recommended to set to true.
#   # use_batch_format = false
#
#   ## Data format to output.
#   ## Each data format has its own unique set of configuration options, read
#   ## more about them here:
#   ## https://github.com/influxdata/telegraf/blob/master/docs/DATA_FORMATS_OUTPUT.md
#   # data_format = "influx"


# # Send metrics to Azure Application Insights
# [[outputs.application_insights]]
#   ## Instrumentation key of the Application Insights resource.
#   instrumentation_key = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxx"
#
#   ## Timeout for closing (default: 5s).
#   # timeout = "5s"
#
#   ## Enable additional diagnostic logging.
#   # enable_diagnostic_logging = false
#
#   ## Context Tag Sources add Application Insights context tags to a tag value.
#   ##
#   ## For list of allowed context tag keys see:
#   ## https://github.com/Microsoft/ApplicationInsights-Go/blob/master/appinsights/contracts/contexttagkeys.go
#   # [outputs.application_insights.context_tag_sources]
#   #   "ai.cloud.role" = "kubernetes_container_name"
#   #   "ai.cloud.roleInstance" = "kubernetes_pod_name"


# # Send aggregate metrics to Azure Monitor
# [[outputs.azure_monitor]]
#   ## Timeout for HTTP writes.
#   # timeout = "20s"
#
#   ## Set the namespace prefix, defaults to "Telegraf/<input-name>".
#   # namespace_prefix = "Telegraf/"
#
#   ## Azure Monitor doesn't have a string value type, so convert string
#   ## fields to dimensions (a.k.a. tags) if enabled. Azure Monitor allows
#   ## a maximum of 10 dimensions so Telegraf will only send the first 10
#   ## alphanumeric dimensions.
#   # strings_as_dimensions = false
#
#   ## Both region and resource_id must be set or be available via the
#   ## Instance Metadata service on Azure Virtual Machines.
#   #
#   ## Azure Region to publish metrics against.
#   ##   ex: region = "southcentralus"
#   # region = ""
#   #
#   ## The Azure Resource ID against which metric will be logged, e.g.
#   ##   ex: resource_id = "/subscriptions/<subscription_id>/resourceGroups/<resource_group>/providers/Microsoft.Compute/virtualMachines/<vm_name>"
#   # resource_id = ""


# # Configuration for AWS CloudWatch output.
# [[outputs.cloudwatch]]
#   ## Amazon REGION
#   region = "us-east-1"
#
#   ## Amazon Credentials
#   ## Credentials are loaded in the following order
#   ## 1) Assumed credentials via STS if role_arn is specified
#   ## 2) explicit credentials from 'access_key' and 'secret_key'
#   ## 3) shared profile from 'profile'
#   ## 4) environment variables
#   ## 5) shared credentials file
#   ## 6) EC2 Instance Profile
#   #access_key = ""
#   #secret_key = ""
#   #token = ""
#   #role_arn = ""
#   #profile = ""
#   #shared_credential_file = ""
#
#   ## Endpoint to make request against, the correct endpoint is automatically
#   ## determined and this option should only be set if you wish to override the
#   ## default.
#   ##   ex: endpoint_url = "http://localhost:8000"
#   # endpoint_url = ""
#
#   ## Namespace for the CloudWatch MetricDatums
#   namespace = "InfluxData/Telegraf"
#
#   ## If you have a large amount of metrics, you should consider to send statistic
#   ## values instead of raw metrics which could not only improve performance but
#   ## also save AWS API cost. If enable this flag, this plugin would parse the required
#   ## CloudWatch statistic fields (count, min, max, and sum) and send them to CloudWatch.
#   ## You could use basicstats aggregator to calculate those fields. If not all statistic
#   ## fields are available, all fields would still be sent as raw metrics.
#   # write_statistics = false


# # Configuration for CrateDB to send metrics to.
# [[outputs.cratedb]]
#   # A github.com/jackc/pgx connection string.
#   # See https://godoc.org/github.com/jackc/pgx#ParseDSN
#   url = "postgres://user:password@localhost/schema?sslmode=disable"
#   # Timeout for all CrateDB queries.
#   timeout = "5s"
#   # Name of the table to store metrics in.
#   table = "metrics"
#   # If true, and the metrics table does not exist, create it automatically.
#   table_create = true


# # Configuration for DataDog API to send metrics to.
# [[outputs.datadog]]
#   ## Datadog API key
#   apikey = "my-secret-key" # required.
#
#   # The base endpoint URL can optionally be specified but it defaults to:
#   #url = "https://app.datadoghq.com/api/v1/series"
#
#   ## Connection timeout.
#   # timeout = "5s"


# # Send metrics to nowhere at all
# [[outputs.discard]]
#   # no configuration


# # Configuration for Elasticsearch to send metrics to.
# [[outputs.elasticsearch]]
#   ## The full HTTP endpoint URL for your Elasticsearch instance
#   ## Multiple urls can be specified as part of the same cluster,
#   ## this means that only ONE of the urls will be written to each interval.
#   urls = [ "http://node1.es.example.com:9200" ] # required.
#   ## Elasticsearch client timeout, defaults to "5s" if not set.
#   timeout = "5s"
#   ## Set to true to ask Elasticsearch a list of all cluster nodes,
#   ## thus it is not necessary to list all nodes in the urls config option.
#   enable_sniffer = false
#   ## Set the interval to check if the Elasticsearch nodes are available
#   ## Setting to "0s" will disable the health check (not recommended in production)
#   health_check_interval = "10s"
#   ## HTTP basic authentication details (eg. when using Shield)
#   # username = "telegraf"
#   # password = "mypassword"
#
#   ## Index Config
#   ## The target index for metrics (Elasticsearch will create if it not exists).
#   ## You can use the date specifiers below to create indexes per time frame.
#   ## The metric timestamp will be used to decide the destination index name
#   # %Y - year (2016)
#   # %y - last two digits of year (00..99)
#   # %m - month (01..12)
#   # %d - day of month (e.g., 01)
#   # %H - hour (00..23)
#   # %V - week of the year (ISO week) (01..53)

#   index_name = "telegraf-%Y.%m.%d" # required.
#
#   ## Optional TLS Config
#   # tls_ca = "/etc/telegraf/ca.pem"
#   # tls_cert = "/etc/telegraf/cert.pem"
#   # tls_key = "/etc/telegraf/key.pem"
#   ## Use TLS but skip chain & host verification
#   # insecure_skip_verify = false
#
#   ## Template Config
#   ## Set to true if you want telegraf to manage its index template.
#   ## If enabled it will create a recommended index template for telegraf indexes
#   manage_template = true
#   ## The template name used for telegraf indexes
#   template_name = "telegraf"
#   ## Set to true if you want telegraf to overwrite an existing template
#   overwrite_template = false


# # Send telegraf metrics to file(s)
# [[outputs.file]]
#   ## Files to write to, "stdout" is a specially handled file.
#   files = ["stdout", "/tmp/metrics.out"]
#
#   ## Data format to output.
#   ## Each data format has its own unique set of configuration options, read
#   ## more about them here:
#   ## https://github.com/influxdata/telegraf/blob/master/docs/DATA_FORMATS_OUTPUT.md
#   data_format = "influx"


# # Configuration for Graphite server to send metrics to
# [[outputs.graphite]]
#   ## TCP endpoint for your graphite instance.
#   ## If multiple endpoints are configured, output will be load balanced.
#   ## Only one of the endpoints will be written to with each iteration.
#   servers = ["localhost:2003"]
#   ## Prefix metrics name
#   prefix = ""
#   ## Graphite output template
#   ## see https://github.com/influxdata/telegraf/blob/master/docs/DATA_FORMATS_OUTPUT.md
#   template = "host.tags.measurement.field"
#
#   ## Enable Graphite tags support
#   # graphite_tag_support = false
#
#   ## timeout in seconds for the write connection to graphite
#   timeout = 2
#
#   ## Optional TLS Config
#   # tls_ca = "/etc/telegraf/ca.pem"
#   # tls_cert = "/etc/telegraf/cert.pem"
#   # tls_key = "/etc/telegraf/key.pem"
#   ## Use TLS but skip chain & host verification
#   # insecure_skip_verify = false


# # Send telegraf metrics to graylog(s)
# [[outputs.graylog]]
#   ## UDP endpoint for your graylog instance.
#   servers = ["127.0.0.1:12201", "192.168.1.1:12201"]


# # A plugin that can transmit metrics over HTTP
# [[outputs.http]]
#   ## URL is the address to send metrics to
#   url = "http://127.0.0.1:8080/metric"
#
#   ## Timeout for HTTP message
#   # timeout = "5s"
#
#   ## HTTP method, one of: "POST" or "PUT"
#   # method = "POST"
#
#   ## HTTP Basic Auth credentials
#   # username = "username"
#   # password = "pa$$word"
#
#   ## OAuth2 Client Credentials Grant
#   # client_id = "clientid"
#   # client_secret = "secret"
#   # token_url = "https://indentityprovider/oauth2/v1/token"
#   # scopes = ["urn:opc:idm:__myscopes__"]
#
#   ## Optional TLS Config
#   # tls_ca = "/etc/telegraf/ca.pem"
#   # tls_cert = "/etc/telegraf/cert.pem"
#   # tls_key = "/etc/telegraf/key.pem"
#   ## Use TLS but skip chain & host verification
#   # insecure_skip_verify = false
#
#   ## Data format to output.
#   ## Each data format has it's own unique set of configuration options, read
#   ## more about them here:
#   ## https://github.com/influxdata/telegraf/blob/master/docs/DATA_FORMATS_OUTPUT.md
#   # data_format = "influx"
#
#   ## Additional HTTP headers
#   # [outputs.http.headers]
#   #   # Should be set manually to "application/json" for json data_format
#   #   Content-Type = "text/plain; charset=utf-8"
#
#   ## HTTP Content-Encoding for write request body, can be set to "gzip" to
#   ## compress body or "identity" to apply no encoding.
#   # content_encoding = "identity"


# # Configuration for sending metrics to InfluxDB
# [[outputs.influxdb_v2]]
#   ## The URLs of the InfluxDB cluster nodes.
#   ##
#   ## Multiple URLs can be specified for a single cluster, only ONE of the
#   ## urls will be written to each interval.
#   urls = ["http://127.0.0.1:9999"]
#
#   ## Token for authentication.
#   token = ""
#
#   ## Organization is the name of the organization you wish to write to; must exist.
#   organization = ""
#
#   ## Destination bucket to write into.
#   bucket = ""
#
#   ## Timeout for HTTP messages.
#   # timeout = "5s"
#
#   ## Additional HTTP headers
#   # http_headers = {"X-Special-Header" = "Special-Value"}
#
#   ## HTTP Proxy override, if unset values the standard proxy environment
#   ## variables are consulted to determine which proxy, if any, should be used.
#   # http_proxy = "http://corporate.proxy:3128"
#
#   ## HTTP User-Agent
#   # user_agent = "telegraf"
#
#   ## Content-Encoding for write request body, can be set to "gzip" to
#   ## compress body or "identity" to apply no encoding.
#   # content_encoding = "gzip"
#
#   ## Enable or disable uint support for writing uints influxdb 2.0.
#   # influx_uint_support = false
#
#   ## Optional TLS Config for use on HTTP connections.
#   # tls_ca = "/etc/telegraf/ca.pem"
#   # tls_cert = "/etc/telegraf/cert.pem"
#   # tls_key = "/etc/telegraf/key.pem"
#   ## Use TLS but skip chain & host verification
#   # insecure_skip_verify = false


# # Configuration for sending metrics to an Instrumental project
# [[outputs.instrumental]]
#   ## Project API Token (required)
#   api_token = "API Token" # required
#   ## Prefix the metrics with a given name
#   prefix = ""
#   ## Stats output template (Graphite formatting)
#   ## see https://github.com/influxdata/telegraf/blob/master/docs/DATA_FORMATS_OUTPUT.md#graphite
#   template = "host.tags.measurement.field"
#   ## Timeout in seconds to connect
#   timeout = "2s"
#   ## Display Communcation to Instrumental
#   debug = false


# # Configuration for the Kafka server to send metrics to
# [[outputs.kafka]]
#   ## URLs of kafka brokers
#   brokers = ["localhost:9092"]
#   ## Kafka topic for producer messages
#   topic = "telegraf"
#
#   ## Optional Client id
#   # client_id = "Telegraf"
#
#   ## Set the minimal supported Kafka version.  Setting this enables the use of new
#   ## Kafka features and APIs.  Of particular interest, lz4 compression
#   ## requires at least version 0.10.0.0.
#   ##   ex: version = "1.1.0"
#   # version = ""
#
#   ## Optional topic suffix configuration.
#   ## If the section is omitted, no suffix is used.
#   ## Following topic suffix methods are supported:
#   ##   measurement - suffix equals to separator + measurement's name
#   ##   tags        - suffix equals to separator + specified tags' values
#   ##                 interleaved with separator
#
#   ## Suffix equals to "_" + measurement name
#   # [outputs.kafka.topic_suffix]
#   #   method = "measurement"
#   #   separator = "_"
#
#   ## Suffix equals to "__" + measurement's "foo" tag value.
#   ##   If there's no such a tag, suffix equals to an empty string
#   # [outputs.kafka.topic_suffix]
#   #   method = "tags"
#   #   keys = ["foo"]
#   #   separator = "__"
#
#   ## Suffix equals to "_" + measurement's "foo" and "bar"
#   ##   tag values, separated by "_". If there is no such tags,
#   ##   their values treated as empty strings.
#   # [outputs.kafka.topic_suffix]
#   #   method = "tags"
#   #   keys = ["foo", "bar"]
#   #   separator = "_"
#
#   ## Telegraf tag to use as a routing key
#   ##  ie, if this tag exists, its value will be used as the routing key
#   routing_tag = "host"
#
#   ## Static routing key.  Used when no routing_tag is set or as a fallback
#   ## when the tag specified in routing tag is not found.  If set to "random",
#   ## a random value will be generated for each message.
#   ##   ex: routing_key = "random"
#   ##       routing_key = "telegraf"
#   # routing_key = ""
#
#   ## CompressionCodec represents the various compression codecs recognized by
#   ## Kafka in messages.
#   ##  0 : No compression
#   ##  1 : Gzip compression
#   ##  2 : Snappy compression
#   ##  3 : LZ4 compression
#   # compression_codec = 0
#
#   ##  RequiredAcks is used in Produce Requests to tell the broker how many
#   ##  replica acknowledgements it must see before responding
#   ##   0 : the producer never waits for an acknowledgement from the broker.
#   ##       This option provides the lowest latency but the weakest durability
#   ##       guarantees (some data will be lost when a server fails).
#   ##   1 : the producer gets an acknowledgement after the leader replica has
#   ##       received the data. This option provides better durability as the
#   ##       client waits until the server acknowledges the request as successful
#   ##       (only messages that were written to the now-dead leader but not yet
#   ##       replicated will be lost).
#   ##   -1: the producer gets an acknowledgement after all in-sync replicas have
#   ##       received the data. This option provides the best durability, we
#   ##       guarantee that no messages will be lost as long as at least one in
#   ##       sync replica remains.
#   # required_acks = -1
#
#   ## The maximum number of times to retry sending a metric before failing
#   ## until the next flush.
#   # max_retry = 3
#
#   ## The maximum permitted size of a message. Should be set equal to or
#   ## smaller than the broker's 'message.max.bytes'.
#   # max_message_bytes = 1000000
#
#   ## Optional TLS Config
#   # tls_ca = "/etc/telegraf/ca.pem"
#   # tls_cert = "/etc/telegraf/cert.pem"
#   # tls_key = "/etc/telegraf/key.pem"
#   ## Use TLS but skip chain & host verification
#   # insecure_skip_verify = false
#
#   ## Optional SASL Config
#   # sasl_username = "kafka"
#   # sasl_password = "secret"
#
#   ## Data format to output.
#   ## Each data format has its own unique set of configuration options, read
#   ## more about them here:
#   ## https://github.com/influxdata/telegraf/blob/master/docs/DATA_FORMATS_OUTPUT.md
#   # data_format = "influx"


# # Configuration for the AWS Kinesis output.
# [[outputs.kinesis]]
#   ## Amazon REGION of kinesis endpoint.
#   region = "ap-southeast-2"
#
#   ## Amazon Credentials
#   ## Credentials are loaded in the following order
#   ## 1) Assumed credentials via STS if role_arn is specified
#   ## 2) explicit credentials from 'access_key' and 'secret_key'
#   ## 3) shared profile from 'profile'
#   ## 4) environment variables
#   ## 5) shared credentials file
#   ## 6) EC2 Instance Profile
#   #access_key = ""
#   #secret_key = ""
#   #token = ""
#   #role_arn = ""
#   #profile = ""
#   #shared_credential_file = ""
#
#   ## Endpoint to make request against, the correct endpoint is automatically
#   ## determined and this option should only be set if you wish to override the
#   ## default.
#   ##   ex: endpoint_url = "http://localhost:8000"
#   # endpoint_url = ""
#
#   ## Kinesis StreamName must exist prior to starting telegraf.
#   streamname = "StreamName"
#   ## DEPRECATED: PartitionKey as used for sharding data.
#   partitionkey = "PartitionKey"
#   ## DEPRECATED: If set the paritionKey will be a random UUID on every put.
#   ## This allows for scaling across multiple shards in a stream.
#   ## This will cause issues with ordering.
#   use_random_partitionkey = false
#   ## The partition key can be calculated using one of several methods:
#   ##
#   ## Use a static value for all writes:
#   #  [outputs.kinesis.partition]
#   #    method = "static"
#   #    key = "howdy"
#   #
#   ## Use a random partition key on each write:
#   #  [outputs.kinesis.partition]
#   #    method = "random"
#   #
#   ## Use the measurement name as the partition key:
#   #  [outputs.kinesis.partition]
#   #    method = "measurement"
#   #
#   ## Use the value of a tag for all writes, if the tag is not set the empty
#   ## default option will be used. When no default, defaults to "telegraf"
#   #  [outputs.kinesis.partition]
#   #    method = "tag"
#   #    key = "host"
#   #    default = "mykey"
#
#
#   ## Data format to output.
#   ## Each data format has its own unique set of configuration options, read
#   ## more about them here:
#   ## https://github.com/influxdata/telegraf/blob/master/docs/DATA_FORMATS_OUTPUT.md
#   data_format = "influx"
#
#   ## debug will show upstream aws messages.
#   debug = false


# # Configuration for Librato API to send metrics to.
# [[outputs.librato]]
#   ## Librator API Docs
#   ## http://dev.librato.com/v1/metrics-authentication
#   ## Librato API user
#   api_user = "telegraf@influxdb.com" # required.
#   ## Librato API token
#   api_token = "my-secret-token" # required.
#   ## Debug
#   # debug = false
#   ## Connection timeout.
#   # timeout = "5s"
#   ## Output source Template (same as graphite buckets)
#   ## see https://github.com/influxdata/telegraf/blob/master/docs/DATA_FORMATS_OUTPUT.md#graphite
#   ## This template is used in librato's source (not metric's name)
#   template = "host"
#


# # Configuration for MQTT server to send metrics to
# [[outputs.mqtt]]
#   servers = ["localhost:1883"] # required.
#
#   ## MQTT outputs send metrics to this topic format
#   ##    "<topic_prefix>/<hostname>/<pluginname>/"
#   ##   ex: prefix/web01.example.com/mem
#   topic_prefix = "telegraf"
#
#   ## QoS policy for messages
#   ##   0 = at most once
#   ##   1 = at least once
#   ##   2 = exactly once
#   # qos = 2
#
#   ## username and password to connect MQTT server.
#   # username = "telegraf"
#   # password = "metricsmetricsmetricsmetrics"
#
#   ## client ID, if not set a random ID is generated
#   # client_id = ""
#
#   ## Timeout for write operations. default: 5s
#   # timeout = "5s"
#
#   ## Optional TLS Config
#   # tls_ca = "/etc/telegraf/ca.pem"
#   # tls_cert = "/etc/telegraf/cert.pem"
#   # tls_key = "/etc/telegraf/key.pem"
#   ## Use TLS but skip chain & host verification
#   # insecure_skip_verify = false
#
#   ## When true, metrics will be sent in one MQTT message per flush.  Otherwise,
#   ## metrics are written one metric per MQTT message.
#   # batch = false
#
#   ## Data format to output.
#   ## Each data format has its own unique set of configuration options, read
#   ## more about them here:
#   ## https://github.com/influxdata/telegraf/blob/master/docs/DATA_FORMATS_OUTPUT.md
#   data_format = "influx"


# # Send telegraf measurements to NATS
# [[outputs.nats]]
#   ## URLs of NATS servers
#   servers = ["nats://localhost:4222"]
#   ## Optional credentials
#   # username = ""
#   # password = ""
#   ## NATS subject for producer messages
#   subject = "telegraf"
#
#   ## Optional TLS Config
#   # tls_ca = "/etc/telegraf/ca.pem"
#   # tls_cert = "/etc/telegraf/cert.pem"
#   # tls_key = "/etc/telegraf/key.pem"
#   ## Use TLS but skip chain & host verification
#   # insecure_skip_verify = false
#
#   ## Data format to output.
#   ## Each data format has its own unique set of configuration options, read
#   ## more about them here:
#   ## https://github.com/influxdata/telegraf/blob/master/docs/DATA_FORMATS_OUTPUT.md
#   data_format = "influx"


# # Send telegraf measurements to NSQD
# [[outputs.nsq]]
#   ## Location of nsqd instance listening on TCP
#   server = "localhost:4150"
#   ## NSQ topic for producer messages
#   topic = "telegraf"
#
#   ## Data format to output.
#   ## Each data format has its own unique set of configuration options, read
#   ## more about them here:
#   ## https://github.com/influxdata/telegraf/blob/master/docs/DATA_FORMATS_OUTPUT.md
#   data_format = "influx"


# # Configuration for OpenTSDB server to send metrics to
# [[outputs.opentsdb]]
#   ## prefix for metrics keys
#   prefix = "my.specific.prefix."
#
#   ## DNS name of the OpenTSDB server
#   ## Using "opentsdb.example.com" or "tcp://opentsdb.example.com" will use the
#   ## telnet API. "http://opentsdb.example.com" will use the Http API.
#   host = "opentsdb.example.com"
#
#   ## Port of the OpenTSDB server
#   port = 4242
#
#   ## Number of data points to send to OpenTSDB in Http requests.
#   ## Not used with telnet API.
#   http_batch_size = 50
#
#   ## URI Path for Http requests to OpenTSDB.
#   ## Used in cases where OpenTSDB is located behind a reverse proxy.
#   http_path = "/api/put"
#
#   ## Debug true - Prints OpenTSDB communication
#   debug = false
#
#   ## Separator separates measurement name from field
#   separator = "_"


# # Configuration for the Prometheus client to spawn
# [[outputs.prometheus_client]]
#   ## Address to listen on
#   listen = ":9273"
#
#   ## Use HTTP Basic Authentication.
#   # basic_username = "Foo"
#   # basic_password = "Bar"
#
#   ## If set, the IP Ranges which are allowed to access metrics.
#   ##   ex: ip_range = ["192.168.0.0/24", "192.168.1.0/30"]
#   # ip_range = []
#
#   ## Path to publish the metrics on.
#   # path = "/metrics"
#
#   ## Expiration interval for each metric. 0 == no expiration
#   # expiration_interval = "60s"
#
#   ## Collectors to enable, valid entries are "gocollector" and "process".
#   ## If unset, both are enabled.
#   # collectors_exclude = ["gocollector", "process"]
#
#   ## Send string metrics as Prometheus labels.
#   ## Unless set to false all string metrics will be sent as labels.
#   # string_as_label = true
#
#   ## If set, enable TLS with the given certificate.
#   # tls_cert = "/etc/ssl/telegraf.crt"
#   # tls_key = "/etc/ssl/telegraf.key"


# # Configuration for the Riemann server to send metrics to
# [[outputs.riemann]]
#   ## The full TCP or UDP URL of the Riemann server
#   url = "tcp://localhost:5555"
#
#   ## Riemann event TTL, floating-point time in seconds.
#   ## Defines how long that an event is considered valid for in Riemann
#   # ttl = 30.0
#
#   ## Separator to use between measurement and field name in Riemann service name
#   ## This does not have any effect if 'measurement_as_attribute' is set to 'true'
#   separator = "/"
#
#   ## Set measurement name as Riemann attribute 'measurement', instead of prepending it to the Riemann service name
#   # measurement_as_attribute = false
#
#   ## Send string metrics as Riemann event states.
#   ## Unless enabled all string metrics will be ignored
#   # string_as_state = false
#
#   ## A list of tag keys whose values get sent as Riemann tags.
#   ## If empty, all Telegraf tag values will be sent as tags
#   # tag_keys = ["telegraf","custom_tag"]
#
#   ## Additional Riemann tags to send.
#   # tags = ["telegraf-output"]
#
#   ## Description for Riemann event
#   # description_text = "metrics collected from telegraf"
#
#   ## Riemann client write timeout, defaults to "5s" if not set.
#   # timeout = "5s"


# # Configuration for the Riemann server to send metrics to
# [[outputs.riemann_legacy]]
#   ## URL of server
#   url = "localhost:5555"
#   ## transport protocol to use either tcp or udp
#   transport = "tcp"
#   ## separator to use between input name and field name in Riemann service name
#   separator = " "


# # Generic socket writer capable of handling multiple socket types.
# [[outputs.socket_writer]]
#   ## URL to connect to
#   # address = "tcp://127.0.0.1:8094"
#   # address = "tcp://example.com:http"
#   # address = "tcp4://127.0.0.1:8094"
#   # address = "tcp6://127.0.0.1:8094"
#   # address = "tcp6://[2001:db8::1]:8094"
#   # address = "udp://127.0.0.1:8094"
#   # address = "udp4://127.0.0.1:8094"
#   # address = "udp6://127.0.0.1:8094"
#   # address = "unix:///tmp/telegraf.sock"
#   # address = "unixgram:///tmp/telegraf.sock"
#
#   ## Optional TLS Config
#   # tls_ca = "/etc/telegraf/ca.pem"
#   # tls_cert = "/etc/telegraf/cert.pem"
#   # tls_key = "/etc/telegraf/key.pem"
#   ## Use TLS but skip chain & host verification
#   # insecure_skip_verify = false
#
#   ## Period between keep alive probes.
#   ## Only applies to TCP sockets.
#   ## 0 disables keep alive probes.
#   ## Defaults to the OS configuration.
#   # keep_alive_period = "5m"
#
#   ## Data format to generate.
#   ## Each data format has its own unique set of configuration options, read
#   ## more about them here:
#   ## https://github.com/influxdata/telegraf/blob/master/docs/DATA_FORMATS_INPUT.md
#   # data_format = "influx"


# # Configuration for Google Cloud Stackdriver to send metrics to
# [[outputs.stackdriver]]
#   # GCP Project
#   project = "erudite-bloom-151019"
#
#   # The namespace for the metric descriptor
#   namespace = "telegraf"


# # Configuration for Wavefront server to send metrics to
# [[outputs.wavefront]]
#   ## DNS name of the wavefront proxy server
#   host = "wavefront.example.com"
#
#   ## Port that the Wavefront proxy server listens on
#   port = 2878
#
#   ## prefix for metrics keys
#   #prefix = "my.specific.prefix."
#
#   ## whether to use "value" for name of simple fields
#   #simple_fields = false
#
#   ## character to use between metric and field name.  defaults to . (dot)
#   #metric_separator = "."
#
#   ## Convert metric name paths to use metricSeperator character
#   ## When true (default) will convert all _ (underscore) chartacters in final metric name
#   #convert_paths = true
#
#   ## Use Regex to sanitize metric and tag names from invalid characters
#   ## Regex is more thorough, but significantly slower
#   #use_regex = false
#
#   ## point tags to use as the source name for Wavefront (if none found, host will be used)
#   #source_override = ["hostname", "agent_host", "node_host"]
#
#   ## whether to convert boolean values to numeric values, with false -> 0.0 and true -> 1.0.  default true
#   #convert_bool = true
#
#   ## Define a mapping, namespaced by metric prefix, from string values to numeric values
#   ## The example below maps "green" -> 1.0, "yellow" -> 0.5, "red" -> 0.0 for
#   ## any metrics beginning with "elasticsearch"
#   #[[outputs.wavefront.string_to_number.elasticsearch]]
#   #  green = 1.0
#   #  yellow = 0.5
#   #  red = 0.0



###############################################################################
#                            PROCESSOR PLUGINS                                #
###############################################################################

# # Convert values to another metric value type
# [[processors.converter]]
#   ## Tags to convert
#   ##
#   ## The table key determines the target type, and the array of key-values
#   ## select the keys to convert.  The array may contain globs.
#   ##   <target-type> = [<tag-key>...]
#   [processors.converter.tags]
#     string = []
#     integer = []
#     unsigned = []
#     boolean = []
#     float = []
#
#   ## Fields to convert
#   ##
#   ## The table key determines the target type, and the array of key-values
#   ## select the keys to convert.  The array may contain globs.
#   ##   <target-type> = [<field-key>...]
#   [processors.converter.fields]
#     tag = []
#     string = []
#     integer = []
#     unsigned = []
#     boolean = []
#     float = []


# # Map enum values according to given table.
# [[processors.enum]]
#   [[processors.enum.mapping]]
#     ## Name of the field to map
#     field = "status"
#
#     ## Destination field to be used for the mapped value.  By default the source
#     ## field is used, overwriting the original value.
#     # dest = "status_code"
#
#     ## Default value to be used for all values not contained in the mapping
#     ## table.  When unset, the unmodified value for the field will be used if no
#     ## match is found.
#     # default = 0
#
#     ## Table of mappings
#     [processors.enum.mapping.value_mappings]
#       green = 1
#       yellow = 2
#       red = 3


# # Apply metric modifications using override semantics.
# [[processors.override]]
#   ## All modifications on inputs and aggregators can be overridden:
#   # name_override = "new_name"
#   # name_prefix = "new_name_prefix"
#   # name_suffix = "new_name_suffix"
#
#   ## Tags to be added (all values must be strings)
#   # [processors.override.tags]
#   #   additional_tag = "tag_value"


# # Parse a value in a specified field/tag(s) and add the result in a new metric
# [[processors.parser]]
#   ## The name of the fields whose value will be parsed.
#   parse_fields = []
#
#   ## If true, incoming metrics are not emitted.
#   drop_original = false
#
#   ## If set to override, emitted metrics will be merged by overriding the
#   ## original metric using the newly parsed metrics.
#   merge = "override"
#
#   ## The dataformat to be read from files
#   ## Each data format has its own unique set of configuration options, read
#   ## more about them here:
#   ## https://github.com/influxdata/telegraf/blob/master/docs/DATA_FORMATS_INPUT.md
#   data_format = "influx"


# # Print all metrics that pass through this filter.
# [[processors.printer]]


# # Transforms tag and field values with regex pattern
# [[processors.regex]]
#   ## Tag and field conversions defined in a separate sub-tables
#   # [[processors.regex.tags]]
#   #   ## Tag to change
#   #   key = "resp_code"
#   #   ## Regular expression to match on a tag value
#   #   pattern = "^(\\d)\\d\\d$"
#   #   ## Pattern for constructing a new value (${1} represents first subgroup)
#   #   replacement = "${1}xx"
#
#   # [[processors.regex.fields]]
#   #   key = "request"
#   #   ## All the power of the Go regular expressions available here
#   #   ## For example, named subgroups
#   #   pattern = "^/api(?P<method>/[\\w/]+)\\S*"
#   #   replacement = "${method}"
#   #   ## If result_key is present, a new field will be created
#   #   ## instead of changing existing field
#   #   result_key = "method"
#
#   ## Multiple conversions may be applied for one field sequentially
#   ## Let's extract one more value
#   # [[processors.regex.fields]]
#   #   key = "request"
#   #   pattern = ".*category=(\\w+).*"
#   #   replacement = "${1}"
#   #   result_key = "search_category"


# # Rename measurements, tags, and fields that pass through this filter.
# [[processors.rename]]


# # Perform string processing on tags, fields, and measurements
# [[processors.strings]]
#   ## Convert a tag value to uppercase
#   # [[processors.strings.uppercase]]
#   #   tag = "method"
#
#   ## Convert a field value to lowercase and store in a new field
#   # [[processors.strings.lowercase]]
#   #   field = "uri_stem"
#   #   dest = "uri_stem_normalised"
#
#   ## Trim leading and trailing whitespace using the default cutset
#   # [[processors.strings.trim]]
#   #   field = "message"
#
#   ## Trim leading characters in cutset
#   # [[processors.strings.trim_left]]
#   #   field = "message"
#   #   cutset = "\t"
#
#   ## Trim trailing characters in cutset
#   # [[processors.strings.trim_right]]
#   #   field = "message"
#   #   cutset = "\r\n"
#
#   ## Trim the given prefix from the field
#   # [[processors.strings.trim_prefix]]
#   #   field = "my_value"
#   #   prefix = "my_"
#
#   ## Trim the given suffix from the field
#   # [[processors.strings.trim_suffix]]
#   #   field = "read_count"
#   #   suffix = "_count"
#
#   ## Replace substrings within field names
#   # [[processors.strings.trim_suffix]]
#   #   measurement = "*"
#   #   old = ":"
#   #   new = "_"


# # Print all metrics that pass through this filter.
# [[processors.topk]]
#   ## How many seconds between aggregations
#   # period = 10
#
#   ## How many top metrics to return
#   # k = 10
#
#   ## Over which tags should the aggregation be done. Globs can be specified, in
#   ## which case any tag matching the glob will aggregated over. If set to an
#   ## empty list is no aggregation over tags is done
#   # group_by = ['*']
#
#   ## Over which fields are the top k are calculated
#   # fields = ["value"]
#
#   ## What aggregation to use. Options: sum, mean, min, max
#   # aggregation = "mean"
#
#   ## Instead of the top k largest metrics, return the bottom k lowest metrics
#   # bottomk = false
#
#   ## The plugin assigns each metric a GroupBy tag generated from its name and
#   ## tags. If this setting is different than "" the plugin will add a
#   ## tag (which name will be the value of this setting) to each metric with
#   ## the value of the calculated GroupBy tag. Useful for debugging
#   # add_groupby_tag = ""
#
#   ## These settings provide a way to know the position of each metric in
#   ## the top k. The 'add_rank_field' setting allows to specify for which
#   ## fields the position is required. If the list is non empty, then a field
#   ## will be added to each and every metric for each string present in this
#   ## setting. This field will contain the ranking of the group that
#   ## the metric belonged to when aggregated over that field.
#   ## The name of the field will be set to the name of the aggregation field,
#   ## suffixed with the string '_topk_rank'
#   # add_rank_fields = []
#
#   ## These settings provide a way to know what values the plugin is generating
#   ## when aggregating metrics. The 'add_agregate_field' setting allows to
#   ## specify for which fields the final aggregation value is required. If the
#   ## list is non empty, then a field will be added to each every metric for
#   ## each field present in this setting. This field will contain
#   ## the computed aggregation for the group that the metric belonged to when
#   ## aggregated over that field.
#   ## The name of the field will be set to the name of the aggregation field,
#   ## suffixed with the string '_topk_aggregate'
#   # add_aggregate_fields = []



###############################################################################
#                            AGGREGATOR PLUGINS                               #
###############################################################################

# # Keep the aggregate basicstats of each metric passing through.
# [[aggregators.basicstats]]
#   ## General Aggregator Arguments:
#   ## The period on which to flush & clear the aggregator.
#   period = "30s"
#   ## If true, the original metric will be dropped by the
#   ## aggregator and will not get sent to the output plugins.
#   drop_original = false


# # Create aggregate histograms.
# [[aggregators.histogram]]
#   ## The period in which to flush the aggregator.
#   period = "30s"
#
#   ## If true, the original metric will be dropped by the
#   ## aggregator and will not get sent to the output plugins.
#   drop_original = false
#
#   ## Example config that aggregates all fields of the metric.
#   # [[aggregators.histogram.config]]
#   #   ## The set of buckets.
#   #   buckets = [0.0, 15.6, 34.5, 49.1, 71.5, 80.5, 94.5, 100.0]
#   #   ## The name of metric.
#   #   measurement_name = "cpu"
#
#   ## Example config that aggregates only specific fields of the metric.
#   # [[aggregators.histogram.config]]
#   #   ## The set of buckets.
#   #   buckets = [0.0, 10.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0, 80.0, 90.0, 100.0]
#   #   ## The name of metric.
#   #   measurement_name = "diskio"
#   #   ## The concrete fields of metric
#   #   fields = ["io_time", "read_time", "write_time"]


# # Keep the aggregate min/max of each metric passing through.
# [[aggregators.minmax]]
#   ## General Aggregator Arguments:
#   ## The period on which to flush & clear the aggregator.
#   period = "30s"
#   ## If true, the original metric will be dropped by the
#   ## aggregator and will not get sent to the output plugins.
#   drop_original = false


# # Count the occurrence of values in fields.
# [[aggregators.valuecounter]]
#   ## General Aggregator Arguments:
#   ## The period on which to flush & clear the aggregator.
#   period = "30s"
#   ## If true, the original metric will be dropped by the
#   ## aggregator and will not get sent to the output plugins.
#   drop_original = false
#   ## The fields for which the values will be counted
#   fields = []



###############################################################################
#                            INPUT PLUGINS                                    #
###############################################################################

# Read metrics about battery info
[[inputs.jx_battery]]
  ## Read battery file path
  battery_path = "/home/admin/uevent"
  ## Indicate if everything is fine
  ok = true

# Read metrics about cpu usage
[[inputs.cpu]]
  ## Whether to report per-cpu stats or not
  percpu = true
  ## Whether to report total system cpu stats or not
  totalcpu = true
  ## If true, collect raw CPU time metrics.
  collect_cpu_time = false
  ## If true, compute and report the sum of all non-idle CPU states.
  report_active = false


# Read metrics about disk usage by mount point
[[inputs.disk]]
  ## By default stats will be gathered for all mount points.
  ## Set mount_points will restrict the stats to only the specified mount points.
  # mount_points = ["/"]

  ## Ignore mount points by filesystem type.
  ignore_fs = ["tmpfs", "devtmpfs", "devfs", "overlay", "aufs", "squashfs"]


# Read metrics about disk IO by device
[[inputs.diskio]]
  ## By default, telegraf will gather stats for all devices including
  ## disk partitions.
  ## Setting devices will restrict the stats to the specified devices.
  # devices = ["sda", "sdb", "vd*"]
  ## Uncomment the following line if you need disk serial numbers.
  # skip_serial_number = false
  #
  ## On systems which support it, device metadata can be added in the form of
  ## tags.
  ## Currently only Linux is supported via udev properties. You can view
  ## available properties for a device by running:
  ## 'udevadm info -q property -n /dev/sda'
  # device_tags = ["ID_FS_TYPE", "ID_FS_USAGE"]
  #
  ## Using the same metadata source as device_tags, you can also customize the
  ## name of the device via templates.
  ## The 'name_templates' parameter is a list of templates to try and apply to
  ## the device. The template may contain variables in the form of '$PROPERTY' or
  ## '${PROPERTY}'. The first template which does not contain any variables not
  ## present for the device is used as the device name tag.
  ## The typical use case is for LVM volumes, to get the VG/LV name instead of
  ## the near-meaningless DM-0 name.
  # name_templates = ["$ID_FS_LABEL","$DM_VG_NAME/$DM_LV_NAME"]


# Get kernel statistics from /proc/stat
[[inputs.kernel]]
  # no configuration


# Read metrics about memory usage
[[inputs.mem]]
  # no configuration


# Get the number of processes and group them by status
[[inputs.processes]]
  # no configuration


# Read metrics about swap memory usage
[[inputs.swap]]
  # no configuration


# Read metrics about system load & uptime
[[inputs.system]]
  # no configuration


# # Gather ActiveMQ metrics
# [[inputs.activemq]]
#   ## Required ActiveMQ Endpoint
#   # server = "192.168.50.10"
#
#   ## Required ActiveMQ port
#   # port = 8161
#
#   ## Credentials for basic HTTP authentication
#   # username = "admin"
#   # password = "admin"
#
#   ## Required ActiveMQ webadmin root path
#   # webadmin = "admin"
#
#   ## Maximum time to receive response.
#   # response_timeout = "5s"
#
#   ## Optional TLS Config
#   # tls_ca = "/etc/telegraf/ca.pem"
#   # tls_cert = "/etc/telegraf/cert.pem"
#   # tls_key = "/etc/telegraf/key.pem"
#   ## Use TLS but skip chain & host verification


# # Read stats from aerospike server(s)
# [[inputs.aerospike]]
#   ## Aerospike servers to connect to (with port)
#   ## This plugin will query all namespaces the aerospike
#   ## server has configured and get stats for them.
#   servers = ["localhost:3000"]
#
#   # username = "telegraf"
#   # password = "pa$$word"
#
#   ## Optional TLS Config
#   # enable_tls = false
#   # tls_ca = "/etc/telegraf/ca.pem"
#   # tls_cert = "/etc/telegraf/cert.pem"
#   # tls_key = "/etc/telegraf/key.pem"
#   ## If false, skip chain & host verification
#   # insecure_skip_verify = true


# # Read Apache status information (mod_status)
# [[inputs.apache]]
#   ## An array of URLs to gather from, must be directed at the machine
#   ## readable version of the mod_status page including the auto query string.
#   ## Default is "http://localhost/server-status?auto".
#   urls = ["http://localhost/server-status?auto"]
#
#   ## Credentials for basic HTTP authentication.
#   # username = "myuser"
#   # password = "mypassword"
#
#   ## Maximum time to receive response.
#   # response_timeout = "5s"
#
#   ## Optional TLS Config
#   # tls_ca = "/etc/telegraf/ca.pem"
#   # tls_cert = "/etc/telegraf/cert.pem"
#   # tls_key = "/etc/telegraf/key.pem"
#   ## Use TLS but skip chain & host verification
#   # insecure_skip_verify = false


# # Gather metrics from Apache Aurora schedulers
# [[inputs.aurora]]
#   ## Schedulers are the base addresses of your Aurora Schedulers
#   schedulers = ["http://127.0.0.1:8081"]
#
#   ## Set of role types to collect metrics from.
#   ##
#   ## The scheduler roles are checked each interval by contacting the
#   ## scheduler nodes; zookeeper is not contacted.
#   # roles = ["leader", "follower"]
#
#   ## Timeout is the max time for total network operations.
#   # timeout = "5s"
#
#   ## Username and password are sent using HTTP Basic Auth.
#   # username = "username"
#   # password = "pa$$word"
#
#   ## Optional TLS Config
#   # tls_ca = "/etc/telegraf/ca.pem"
#   # tls_cert = "/etc/telegraf/cert.pem"
#   # tls_key = "/etc/telegraf/key.pem"
#   ## Use TLS but skip chain & host verification
#   # insecure_skip_verify = false


# # Read metrics of bcache from stats_total and dirty_data
# [[inputs.bcache]]
#   ## Bcache sets path
#   ## If not specified, then default is:
#   bcachePath = "/sys/fs/bcache"
#
#   ## By default, telegraf gather stats for all bcache devices
#   ## Setting devices will restrict the stats to the specified
#   ## bcache devices.
#   bcacheDevs = ["bcache0"]


# # Collects Beanstalkd server and tubes stats
# [[inputs.beanstalkd]]
#   ## Server to collect data from
#   server = "localhost:11300"
#
#   ## List of tubes to gather stats about.
#   ## If no tubes specified then data gathered for each tube on server reported by list-tubes command
#   tubes = ["notifications"]


# # Collect bond interface status, slaves statuses and failures count
# [[inputs.bond]]
#   ## Sets 'proc' directory path
#   ## If not specified, then default is /proc
#   # host_proc = "/proc"
#
#   ## By default, telegraf gather stats for all bond interfaces
#   ## Setting interfaces will restrict the stats to the specified
#   ## bond interfaces.
#   # bond_interfaces = ["bond0"]


# # Collect Kafka topics and consumers status from Burrow HTTP API.
# [[inputs.burrow]]
#   ## Burrow API endpoints in format "schema://host:port".
#   ## Default is "http://localhost:8000".
#   servers = ["http://localhost:8000"]
#
#   ## Override Burrow API prefix.
#   ## Useful when Burrow is behind reverse-proxy.
#   # api_prefix = "/v3/kafka"
#
#   ## Maximum time to receive response.
#   # response_timeout = "5s"
#
#   ## Limit per-server concurrent connections.
#   ## Useful in case of large number of topics or consumer groups.
#   # concurrent_connections = 20
#
#   ## Filter clusters, default is no filtering.
#   ## Values can be specified as glob patterns.
#   # clusters_include = []
#   # clusters_exclude = []
#
#   ## Filter consumer groups, default is no filtering.
#   ## Values can be specified as glob patterns.
#   # groups_include = []
#   # groups_exclude = []
#
#   ## Filter topics, default is no filtering.
#   ## Values can be specified as glob patterns.
#   # topics_include = []
#   # topics_exclude = []
#
#   ## Credentials for basic HTTP authentication.
#   # username = ""
#   # password = ""
#
#   ## Optional SSL config
#   # ssl_ca = "/etc/telegraf/ca.pem"
#   # ssl_cert = "/etc/telegraf/cert.pem"
#   # ssl_key = "/etc/telegraf/key.pem"
#   # insecure_skip_verify = false


# # Collects performance metrics from the MON and OSD nodes in a Ceph storage cluster.
# [[inputs.ceph]]
#   ## This is the recommended interval to poll.  Too frequent and you will lose
#   ## data points due to timeouts during rebalancing and recovery
#   interval = '1m'
#
#   ## All configuration values are optional, defaults are shown below
#
#   ## location of ceph binary
#   ceph_binary = "/usr/bin/ceph"
#
#   ## directory in which to look for socket files
#   socket_dir = "/var/run/ceph"
#
#   ## prefix of MON and OSD socket files, used to determine socket type
#   mon_prefix = "ceph-mon"
#   osd_prefix = "ceph-osd"
#
#   ## suffix used to identify socket files
#   socket_suffix = "asok"
#
#   ## Ceph user to authenticate as
#   ceph_user = "client.admin"
#
#   ## Ceph configuration to use to locate the cluster
#   ceph_config = "/etc/ceph/ceph.conf"
#
#   ## Whether to gather statistics via the admin socket
#   gather_admin_socket_stats = true
#
#   ## Whether to gather statistics via ceph commands
#   gather_cluster_stats = false


# # Read specific statistics per cgroup
# [[inputs.cgroup]]
#   ## Directories in which to look for files, globs are supported.
#   ## Consider restricting paths to the set of cgroups you really
#   ## want to monitor if you have a large number of cgroups, to avoid
#   ## any cardinality issues.
#   # paths = [
#   #   "/cgroup/memory",
#   #   "/cgroup/memory/child1",
#   #   "/cgroup/memory/child2/*",
#   # ]
#   ## cgroup stat fields, as file names, globs are supported.
#   ## these file names are appended to each path from above.
#   # files = ["memory.*usage*", "memory.limit_in_bytes"]


# # Get standard chrony metrics, requires chronyc executable.
# [[inputs.chrony]]
#   ## If true, chronyc tries to perform a DNS lookup for the time server.
#   # dns_lookup = false


# # Pull Metric Statistics from Amazon CloudWatch
# [[inputs.cloudwatch]]
#   ## Amazon Region
#   region = "us-east-1"
#
#   ## Amazon Credentials
#   ## Credentials are loaded in the following order
#   ## 1) Assumed credentials via STS if role_arn is specified
#   ## 2) explicit credentials from 'access_key' and 'secret_key'
#   ## 3) shared profile from 'profile'
#   ## 4) environment variables
#   ## 5) shared credentials file
#   ## 6) EC2 Instance Profile
#   #access_key = ""
#   #secret_key = ""
#   #token = ""
#   #role_arn = ""
#   #profile = ""
#   #shared_credential_file = ""
#
#   ## Endpoint to make request against, the correct endpoint is automatically
#   ## determined and this option should only be set if you wish to override the
#   ## default.
#   ##   ex: endpoint_url = "http://localhost:8000"
#   # endpoint_url = ""
#
#   # The minimum period for Cloudwatch metrics is 1 minute (60s). However not all
#   # metrics are made available to the 1 minute period. Some are collected at
#   # 3 minute, 5 minute, or larger intervals. See https://aws.amazon.com/cloudwatch/faqs/#monitoring.
#   # Note that if a period is configured that is smaller than the minimum for a
#   # particular metric, that metric will not be returned by the Cloudwatch API
#   # and will not be collected by Telegraf.
#   #
#   ## Requested CloudWatch aggregation Period (required - must be a multiple of 60s)
#   period = "5m"
#
#   ## Collection Delay (required - must account for metrics availability via CloudWatch API)
#   delay = "5m"
#
#   ## Recommended: use metric 'interval' that is a multiple of 'period' to avoid
#   ## gaps or overlap in pulled data
#   interval = "5m"
#
#   ## Configure the TTL for the internal cache of metrics.
#   ## Defaults to 1 hr if not specified
#   #cache_ttl = "10m"
#
#   ## Metric Statistic Namespace (required)
#   namespace = "AWS/ELB"
#
#   ## Maximum requests per second. Note that the global default AWS rate limit is
#   ## 400 reqs/sec, so if you define multiple namespaces, these should add up to a
#   ## maximum of 400. Optional - default value is 200.
#   ## See http://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/cloudwatch_limits.html
#   ratelimit = 200
#
#   ## Metrics to Pull (optional)
#   ## Defaults to all Metrics in Namespace if nothing is provided
#   ## Refreshes Namespace available metrics every 1h
#   #[[inputs.cloudwatch.metrics]]
#   #  names = ["Latency", "RequestCount"]
#   #
#   #  ## Dimension filters for Metric.  These are optional however all dimensions
#   #  ## defined for the metric names must be specified in order to retrieve
#   #  ## the metric statistics.
#   #  [[inputs.cloudwatch.metrics.dimensions]]
#   #    name = "LoadBalancerName"
#   #    value = "p-example"


# # Collects conntrack stats from the configured directories and files.
# [[inputs.conntrack]]
#    ## The following defaults would work with multiple versions of conntrack.
#    ## Note the nf_ and ip_ filename prefixes are mutually exclusive across
#    ## kernel versions, as are the directory locations.
#
#    ## Superset of filenames to look for within the conntrack dirs.
#    ## Missing files will be ignored.
#    files = ["ip_conntrack_count","ip_conntrack_max",
#             "nf_conntrack_count","nf_conntrack_max"]
#
#    ## Directories to search within for the conntrack files above.
#    ## Missing directrories will be ignored.
#    dirs = ["/proc/sys/net/ipv4/netfilter","/proc/sys/net/netfilter"]


# # Gather health check statuses from services registered in Consul
# [[inputs.consul]]
#   ## Consul server address
#   # address = "localhost"
#
#   ## URI scheme for the Consul server, one of "http", "https"
#   # scheme = "http"
#
#   ## ACL token used in every request
#   # token = ""
#
#   ## HTTP Basic Authentication username and password.
#   # username = ""
#   # password = ""
#
#   ## Data centre to query the health checks from
#   # datacentre = ""
#
#   ## Optional TLS Config
#   # tls_ca = "/etc/telegraf/ca.pem"
#   # tls_cert = "/etc/telegraf/cert.pem"
#   # tls_key = "/etc/telegraf/key.pem"
#   ## Use TLS but skip chain & host verification
#   # insecure_skip_verify = true
#
#   ## Consul checks' tag splitting
#   # When tags are formatted like "key:value" with ":" as a delimiter then
#   # they will be splitted and reported as proper key:value in Telegraf
#   # tag_delimiter = ":"


# # Read metrics from one or many couchbase clusters
# [[inputs.couchbase]]
#   ## specify servers via a url matching:
#   ##  [protocol://][:password]@address[:port]
#   ##  e.g.
#   ##    http://couchbase-0.example.com/
#   ##    http://admin:secret@couchbase-0.example.com:8091/
#   ##
#   ## If no servers are specified, then localhost is used as the host.
#   ## If no protocol is specified, HTTP is used.
#   ## If no port is specified, 8091 is used.
#   servers = ["http://localhost:8091"]


# # Read CouchDB Stats from one or more servers
# [[inputs.couchdb]]
#   ## Works with CouchDB stats endpoints out of the box
#   ## Multiple Hosts from which to read CouchDB stats:
#   hosts = ["http://localhost:8086/_stats"]


# # Input plugin for DC/OS metrics
# [[inputs.dcos]]
#   ## The DC/OS cluster URL.
#   cluster_url = "https://dcos-ee-master-1"
#
#   ## The ID of the service account.
#   service_account_id = "telegraf"
#   ## The private key file for the service account.
#   service_account_private_key = "/etc/telegraf/telegraf-sa-key.pem"
#
#   ## Path containing login token.  If set, will read on every gather.
#   # token_file = "/home/dcos/.dcos/token"
#
#   ## In all filter options if both include and exclude are empty all items
#   ## will be collected.  Arrays may contain glob patterns.
#   ##
#   ## Node IDs to collect metrics from.  If a node is excluded, no metrics will
#   ## be collected for its containers or apps.
#   # node_include = []
#   # node_exclude = []
#   ## Container IDs to collect container metrics from.
#   # container_include = []
#   # container_exclude = []
#   ## Container IDs to collect app metrics from.
#   # app_include = []
#   # app_exclude = []
#
#   ## Maximum concurrent connections to the cluster.
#   # max_connections = 10
#   ## Maximum time to receive a response from cluster.
#   # response_timeout = "20s"
#
#   ## Optional TLS Config
#   # tls_ca = "/etc/telegraf/ca.pem"
#   # tls_cert = "/etc/telegraf/cert.pem"
#   # tls_key = "/etc/telegraf/key.pem"
#   ## If false, skip chain & host verification
#   # insecure_skip_verify = true
#
#   ## Recommended filtering to reduce series cardinality.
#   # [inputs.dcos.tagdrop]
#   #   path = ["/var/lib/mesos/slave/slaves/*"]


# # Read metrics from one or many disque servers
# [[inputs.disque]]
#   ## An array of URI to gather stats about. Specify an ip or hostname
#   ## with optional port and password.
#   ## ie disque://localhost, disque://10.10.3.33:18832, 10.0.0.1:10000, etc.
#   ## If no servers are specified, then localhost is used as the host.
#   servers = ["localhost"]


# # Provide a native collection for dmsetup based statistics for dm-cache
# [[inputs.dmcache]]
#   ## Whether to report per-device stats or not
#   per_device = true


# # Query given DNS server and gives statistics
# [[inputs.dns_query]]
#   ## servers to query
#   servers = ["8.8.8.8"]
#
#   ## Network is the network protocol name.
#   # network = "udp"
#
#   ## Domains or subdomains to query.
#   # domains = ["."]
#
#   ## Query record type.
#   ## Posible values: A, AAAA, CNAME, MX, NS, PTR, TXT, SOA, SPF, SRV.
#   # record_type = "A"
#
#   ## Dns server port.
#   # port = 53
#
#   ## Query timeout in seconds.
#   # timeout = 2


# # Read metrics about docker containers
# [[inputs.docker]]
#   ## Docker Endpoint
#   ##   To use TCP, set endpoint = "tcp://[ip]:[port]"
#   ##   To use environment variables (ie, docker-machine), set endpoint = "ENV"
#   endpoint = "unix:///var/run/docker.sock"
#
#   ## Set to true to collect Swarm metrics(desired_replicas, running_replicas)
#   gather_services = false
#
#   ## Only collect metrics for these containers, collect all if empty
#   container_names = []
#
#   ## Containers to include and exclude. Globs accepted.
#   ## Note that an empty array for both will include all containers
#   container_name_include = []
#   container_name_exclude = []
#
#   ## Container states to include and exclude. Globs accepted.
#   ## When empty only containers in the "running" state will be captured.
#   # container_state_include = []
#   # container_state_exclude = []
#
#   ## Timeout for docker list, info, and stats commands
#   timeout = "5s"
#
#   ## Whether to report for each container per-device blkio (8:0, 8:1...) and
#   ## network (eth0, eth1, ...) stats or not
#   perdevice = true
#   ## Whether to report for each container total blkio and network stats or not
#   total = false
#   ## Which environment variables should we use as a tag
#   ##tag_env = ["JAVA_HOME", "HEAP_SIZE"]
#
#   ## docker labels to include and exclude as tags.  Globs accepted.
#   ## Note that an empty array for both will include all labels as tags
#   docker_label_include = []
#   docker_label_exclude = []
#
#   ## Optional TLS Config
#   # tls_ca = "/etc/telegraf/ca.pem"
#   # tls_cert = "/etc/telegraf/cert.pem"
#   # tls_key = "/etc/telegraf/key.pem"
#   ## Use TLS but skip chain & host verification
#   # insecure_skip_verify = false


# # Read statistics from one or many dovecot servers
# [[inputs.dovecot]]
#   ## specify dovecot servers via an address:port list
#   ##  e.g.
#   ##    localhost:24242
#   ##
#   ## If no servers are specified, then localhost is used as the host.
#   servers = ["localhost:24242"]
#   ## Type is one of "user", "domain", "ip", or "global"
#   type = "global"
#   ## Wildcard matches like "*.com". An empty string "" is same as "*"
#   ## If type = "ip" filters should be <IP/network>
#   filters = [""]


# # Read stats from one or more Elasticsearch servers or clusters
# [[inputs.elasticsearch]]
#   ## specify a list of one or more Elasticsearch servers
#   # you can add username and password to your url to use basic authentication:
#   # servers = ["http://user:pass@localhost:9200"]
#   servers = ["http://localhost:9200"]
#
#   ## Timeout for HTTP requests to the elastic search server(s)
#   http_timeout = "5s"
#
#   ## When local is true (the default), the node will read only its own stats.
#   ## Set local to false when you want to read the node stats from all nodes
#   ## of the cluster.
#   local = true
#
#   ## Set cluster_health to true when you want to also obtain cluster health stats
#   cluster_health = false
#
#   ## Adjust cluster_health_level when you want to also obtain detailed health stats
#   ## The options are
#   ##  - indices (default)
#   ##  - cluster
#   # cluster_health_level = "indices"
#
#   ## Set cluster_stats to true when you want to also obtain cluster stats from the
#   ## Master node.
#   cluster_stats = false
#
#   ## node_stats is a list of sub-stats that you want to have gathered. Valid options
#   ## are "indices", "os", "process", "jvm", "thread_pool", "fs", "transport", "http",
#   ## "breaker". Per default, all stats are gathered.
#   # node_stats = ["jvm", "http"]
#
#   ## Optional TLS Config
#   # tls_ca = "/etc/telegraf/ca.pem"
#   # tls_cert = "/etc/telegraf/cert.pem"
#   # tls_key = "/etc/telegraf/key.pem"
#   ## Use TLS but skip chain & host verification
#   # insecure_skip_verify = false


# # Read metrics from one or more commands that can output to stdout
# [[inputs.exec]]
#   ## Commands array
#   commands = [
#     "/tmp/test.sh",
#     "/usr/bin/mycollector --foo=bar",
#     "/tmp/collect_*.sh"
#   ]
#
#   ## Timeout for each command to complete.
#   timeout = "5s"
#
#   ## measurement name suffix (for separating different commands)
#   name_suffix = "_mycollector"
#
#   ## Data format to consume.
#   ## Each data format has its own unique set of configuration options, read
#   ## more about them here:
#   ## https://github.com/influxdata/telegraf/blob/master/docs/DATA_FORMATS_INPUT.md
#   data_format = "influx"


# # Read metrics from fail2ban.
# [[inputs.fail2ban]]
#   ## Use sudo to run fail2ban-client
#   use_sudo = false


# # Read devices value(s) from a Fibaro controller
# [[inputs.fibaro]]
#   ## Required Fibaro controller address/hostname.
#   ## Note: at the time of writing this plugin, Fibaro only implemented http - no https available
#   url = "http://<controller>:80"
#
#   ## Required credentials to access the API (http://<controller/api/<component>)
#   username = "<username>"
#   password = "<password>"
#
#   ## Amount of time allowed to complete the HTTP request
#   # timeout = "5s"


# # Reload and gather from file[s] on telegraf's interval.
# [[inputs.file]]
#   ## Files to parse each interval.
#   ## These accept standard unix glob matching rules, but with the addition of
#   ## ** as a "super asterisk". ie:
#   ##   /var/log/**.log     -> recursively find all .log files in /var/log
#   ##   /var/log/*/*.log    -> find all .log files with a parent dir in /var/log
#   ##   /var/log/apache.log -> only read the apache log file
#   files = ["/var/log/apache/access.log"]
#
#   ## The dataformat to be read from files
#   ## Each data format has its own unique set of configuration options, read
#   ## more about them here:
#   ## https://github.com/influxdata/telegraf/blob/master/docs/DATA_FORMATS_INPUT.md
#   data_format = "influx"


# # Count files in a directory
# [[inputs.filecount]]
#   ## Directory to gather stats about.
#   ##   deprecated in 1.9; use the directories option
#   directory = "/var/cache/apt/archives"
#
#   ## Directories to gather stats about.
#   ## This accept standard unit glob matching rules, but with the addition of
#   ## ** as a "super asterisk". ie:
#   ##   /var/log/**    -> recursively find all directories in /var/log and count files in each directories
#   ##   /var/log/*/*   -> find all directories with a parent dir in /var/log and count files in each directories
#   ##   /var/log       -> count all files in /var/log and all of its subdirectories
#   directories = ["/var/cache/apt/archives"]
#
#   ## Only count files that match the name pattern. Defaults to "*".
#   name = "*.deb"
#
#   ## Count files in subdirectories. Defaults to true.
#   recursive = false
#
#   ## Only count regular files. Defaults to true.
#   regular_only = true
#
#   ## Only count files that are at least this size. If size is
#   ## a negative number, only count files that are smaller than the
#   ## absolute value of size. Acceptable units are B, KiB, MiB, KB, ...
#   ## Without quotes and units, interpreted as size in bytes.
#   size = "0B"
#
#   ## Only count files that have not been touched for at least this
#   ## duration. If mtime is negative, only count files that have been
#   ## touched in this duration. Defaults to "0s".
#   mtime = "0s"


# # Read stats about given file(s)
# [[inputs.filestat]]
#   ## Files to gather stats about.
#   ## These accept standard unix glob matching rules, but with the addition of
#   ## ** as a "super asterisk". ie:
#   ##   "/var/log/**.log"  -> recursively find all .log files in /var/log
#   ##   "/var/log/*/*.log" -> find all .log files with a parent dir in /var/log
#   ##   "/var/log/apache.log" -> just tail the apache log file
#   ##
#   ## See https://github.com/gobwas/glob for more examples
#   ##
#   files = ["/var/log/**.log"]
#   ## If true, read the entire file and calculate an md5 checksum.
#   md5 = false


# # Read metrics exposed by fluentd in_monitor plugin
# [[inputs.fluentd]]
#   ## This plugin reads information exposed by fluentd (using /api/plugins.json endpoint).
#   ##
#   ## Endpoint:
#   ## - only one URI is allowed
#   ## - https is not supported
#   endpoint = "http://localhost:24220/api/plugins.json"
#
#   ## Define which plugins have to be excluded (based on "type" field - e.g. monitor_agent)
#   exclude = [
# 	  "monitor_agent",
# 	  "dummy",
#   ]


# # Read flattened metrics from one or more GrayLog HTTP endpoints
# [[inputs.graylog]]
#   ## API endpoint, currently supported API:
#   ##
#   ##   - multiple  (Ex http://<host>:12900/system/metrics/multiple)
#   ##   - namespace (Ex http://<host>:12900/system/metrics/namespace/{namespace})
#   ##
#   ## For namespace endpoint, the metrics array will be ignored for that call.
#   ## Endpoint can contain namespace and multiple type calls.
#   ##
#   ## Please check http://[graylog-server-ip]:12900/api-browser for full list
#   ## of endpoints
#   servers = [
#     "http://[graylog-server-ip]:12900/system/metrics/multiple",
#   ]
#
#   ## Metrics list
#   ## List of metrics can be found on Graylog webservice documentation.
#   ## Or by hitting the the web service api at:
#   ##   http://[graylog-host]:12900/system/metrics
#   metrics = [
#     "jvm.cl.loaded",
#     "jvm.memory.pools.Metaspace.committed"
#   ]
#
#   ## Username and password
#   username = ""
#   password = ""
#
#   ## Optional TLS Config
#   # tls_ca = "/etc/telegraf/ca.pem"
#   # tls_cert = "/etc/telegraf/cert.pem"
#   # tls_key = "/etc/telegraf/key.pem"
#   ## Use TLS but skip chain & host verification
#   # insecure_skip_verify = false


# # Read metrics of haproxy, via socket or csv stats page
# [[inputs.haproxy]]
#   ## An array of address to gather stats about. Specify an ip on hostname
#   ## with optional port. ie localhost, 10.10.3.33:1936, etc.
#   ## Make sure you specify the complete path to the stats endpoint
#   ## including the protocol, ie http://10.10.3.33:1936/haproxy?stats
#
#   ## If no servers are specified, then default to 127.0.0.1:1936/haproxy?stats
#   servers = ["http://myhaproxy.com:1936/haproxy?stats"]
#
#   ## Credentials for basic HTTP authentication
#   # username = "admin"
#   # password = "admin"
#
#   ## You can also use local socket with standard wildcard globbing.
#   ## Server address not starting with 'http' will be treated as a possible
#   ## socket, so both examples below are valid.
#   # servers = ["socket:/run/haproxy/admin.sock", "/run/haproxy/*.sock"]
#
#   ## By default, some of the fields are renamed from what haproxy calls them.
#   ## Setting this option to true results in the plugin keeping the original
#   ## field names.
#   # keep_field_names = false
#
#   ## Optional TLS Config
#   # tls_ca = "/etc/telegraf/ca.pem"
#   # tls_cert = "/etc/telegraf/cert.pem"
#   # tls_key = "/etc/telegraf/key.pem"
#   ## Use TLS but skip chain & host verification
#   # insecure_skip_verify = false


# # Monitor disks' temperatures using hddtemp
# [[inputs.hddtemp]]
#   ## By default, telegraf gathers temps data from all disks detected by the
#   ## hddtemp.
#   ##
#   ## Only collect temps from the selected disks.
#   ##
#   ## A * as the device name will return the temperature values of all disks.
#   ##
#   # address = "127.0.0.1:7634"
#   # devices = ["sda", "*"]


# # Read formatted metrics from one or more HTTP endpoints
# [[inputs.http]]
#   ## One or more URLs from which to read formatted metrics
#   urls = [
#     "http://localhost/metrics"
#   ]
#
#   ## HTTP method
#   # method = "GET"
#
#   ## Optional HTTP headers
#   # headers = {"X-Special-Header" = "Special-Value"}
#
#   ## Optional HTTP Basic Auth Credentials
#   # username = "username"
#   # password = "pa$$word"
#
#   ## Optional TLS Config
#   # tls_ca = "/etc/telegraf/ca.pem"
#   # tls_cert = "/etc/telegraf/cert.pem"
#   # tls_key = "/etc/telegraf/key.pem"
#   ## Use TLS but skip chain & host verification
#   # insecure_skip_verify = false
#
#   ## Amount of time allowed to complete the HTTP request
#   # timeout = "5s"
#
#   ## Data format to consume.
#   ## Each data format has its own unique set of configuration options, read
#   ## more about them here:
#   ## https://github.com/influxdata/telegraf/blob/master/docs/DATA_FORMATS_INPUT.md
#   # data_format = "influx"


# # HTTP/HTTPS request given an address a method and a timeout
# [[inputs.http_response]]
#   ## Server address (default http://localhost)
#   # address = "http://localhost"
#
#   ## Set http_proxy (telegraf uses the system wide proxy settings if it's is not set)
#   # http_proxy = "http://localhost:8888"
#
#   ## Set response_timeout (default 5 seconds)
#   # response_timeout = "5s"
#
#   ## HTTP Request Method
#   # method = "GET"
#
#   ## Whether to follow redirects from the server (defaults to false)
#   # follow_redirects = false
#
#   ## Optional HTTP Request Body
#   # body = '''
#   # {'fake':'data'}
#   # '''
#
#   ## Optional substring or regex match in body of the response
#   # response_string_match = "\"service_status\": \"up\""
#   # response_string_match = "ok"
#   # response_string_match = "\".*_status\".?:.?\"up\""
#
#   ## Optional TLS Config
#   # tls_ca = "/etc/telegraf/ca.pem"
#   # tls_cert = "/etc/telegraf/cert.pem"
#   # tls_key = "/etc/telegraf/key.pem"
#   ## Use TLS but skip chain & host verification
#   # insecure_skip_verify = false
#
#   ## HTTP Request Headers (all values must be strings)
#   # [inputs.http_response.headers]
#   #   Host = "github.com"


# # Read flattened metrics from one or more JSON HTTP endpoints
# [[inputs.httpjson]]
#   ## NOTE This plugin only reads numerical measurements, strings and booleans
#   ## will be ignored.
#
#   ## Name for the service being polled.  Will be appended to the name of the
#   ## measurement e.g. httpjson_webserver_stats
#   ##
#   ## Deprecated (1.3.0): Use name_override, name_suffix, name_prefix instead.
#   name = "webserver_stats"
#
#   ## URL of each server in the service's cluster
#   servers = [
#     "http://localhost:9999/stats/",
#     "http://localhost:9998/stats/",
#   ]
#   ## Set response_timeout (default 5 seconds)
#   response_timeout = "5s"
#
#   ## HTTP method to use: GET or POST (case-sensitive)
#   method = "GET"
#
#   ## List of tag names to extract from top-level of JSON server response
#   # tag_keys = [
#   #   "my_tag_1",
#   #   "my_tag_2"
#   # ]
#
#   ## Optional TLS Config
#   # tls_ca = "/etc/telegraf/ca.pem"
#   # tls_cert = "/etc/telegraf/cert.pem"
#   # tls_key = "/etc/telegraf/key.pem"
#   ## Use TLS but skip chain & host verification
#   # insecure_skip_verify = false
#
#   ## HTTP parameters (all values must be strings).  For "GET" requests, data
#   ## will be included in the query.  For "POST" requests, data will be included
#   ## in the request body as "x-www-form-urlencoded".
#   # [inputs.httpjson.parameters]
#   #   event_type = "cpu_spike"
#   #   threshold = "0.75"
#
#   ## HTTP Headers (all values must be strings)
#   # [inputs.httpjson.headers]
#   #   X-Auth-Token = "my-xauth-token"
#   #   apiVersion = "v1"


# # Gather Icinga2 status
# [[inputs.icinga2]]
#   ## Required Icinga2 server address (default: "https://localhost:5665")
#   # server = "https://localhost:5665"
#
#   ## Required Icinga2 object type ("services" or "hosts, default "services")
#   # object_type = "services"
#
#   ## Credentials for basic HTTP authentication
#   # username = "admin"
#   # password = "admin"
#
#   ## Maximum time to receive response.
#   # response_timeout = "5s"
#
#   ## Optional TLS Config
#   # tls_ca = "/etc/telegraf/ca.pem"
#   # tls_cert = "/etc/telegraf/cert.pem"
#   # tls_key = "/etc/telegraf/key.pem"
#   ## Use TLS but skip chain & host verification
#   # insecure_skip_verify = true


# # Read InfluxDB-formatted JSON metrics from one or more HTTP endpoints
# [[inputs.influxdb]]
#   ## Works with InfluxDB debug endpoints out of the box,
#   ## but other services can use this format too.
#   ## See the influxdb plugin's README for more details.
#
#   ## Multiple URLs from which to read InfluxDB-formatted JSON
#   ## Default is "http://localhost:8086/debug/vars".
#   urls = [
#     "http://localhost:8086/debug/vars"
#   ]
#
#   ## Optional TLS Config
#   # tls_ca = "/etc/telegraf/ca.pem"
#   # tls_cert = "/etc/telegraf/cert.pem"
#   # tls_key = "/etc/telegraf/key.pem"
#   ## Use TLS but skip chain & host verification
#   # insecure_skip_verify = false
#
#   ## http request & header timeout
#   timeout = "5s"


# # Collect statistics about itself
# [[inputs.internal]]
#   ## If true, collect telegraf memory stats.
#   # collect_memstats = true


# # This plugin gathers interrupts data from /proc/interrupts and /proc/softirqs.
# [[inputs.interrupts]]
#   ## To filter which IRQs to collect, make use of tagpass / tagdrop, i.e.
#   # [inputs.interrupts.tagdrop]
#     # irq = [ "NET_RX", "TASKLET" ]


# # Read metrics from the bare metal servers via IPMI
# [[inputs.ipmi_sensor]]
#   ## optionally specify the path to the ipmitool executable
#   # path = "/usr/bin/ipmitool"
#   ##
#   ## optionally force session privilege level. Can be CALLBACK, USER, OPERATOR, ADMINISTRATOR
#   # privilege = "ADMINISTRATOR"
#   ##
#   ## optionally specify one or more servers via a url matching
#   ##  [username[:password]@][protocol[(address)]]
#   ##  e.g.
#   ##    root:passwd@lan(127.0.0.1)
#   ##
#   ## if no servers are specified, local machine sensor stats will be queried
#   ##
#   # servers = ["USERID:PASSW0RD@lan(192.168.1.1)"]
#
#   ## Recommended: use metric 'interval' that is a multiple of 'timeout' to avoid
#   ## gaps or overlap in pulled data
#   interval = "30s"
#
#   ## Timeout for the ipmitool command to complete
#   timeout = "20s"
#
#   ## Schema Version: (Optional, defaults to version 1)
#   metric_version = 2


# # Gather packets and bytes counters from Linux ipsets
# [[inputs.ipset]]
#   ## By default, we only show sets which have already matched at least 1 packet.
#   ## set include_unmatched_sets = true to gather them all.
#   include_unmatched_sets = false
#   ## Adjust your sudo settings appropriately if using this option ("sudo ipset save")
#   use_sudo = false
#   ## The default timeout of 1s for ipset execution can be overridden here:
#   # timeout = "1s"


# # Gather packets and bytes throughput from iptables
# [[inputs.iptables]]
#   ## iptables require root access on most systems.
#   ## Setting 'use_sudo' to true will make use of sudo to run iptables.
#   ## Users must configure sudo to allow telegraf user to run iptables with no password.
#   ## iptables can be restricted to only list command "iptables -nvL".
#   use_sudo = false
#   ## Setting 'use_lock' to true runs iptables with the "-w" option.
#   ## Adjust your sudo settings appropriately if using this option ("iptables -wnvl")
#   use_lock = false
#   ## Define an alternate executable, such as "ip6tables". Default is "iptables".
#   # binary = "ip6tables"
#   ## defines the table to monitor:
#   table = "filter"
#   ## defines the chains to monitor.
#   ## NOTE: iptables rules without a comment will not be monitored.
#   ## Read the plugin documentation for more information.
#   chains = [ "INPUT" ]


# # Collect virtual and real server stats from Linux IPVS
# [[inputs.ipvs]]
#   # no configuration


# # Read JMX metrics through Jolokia
# [[inputs.jolokia]]
#   # DEPRECATED: the jolokia plugin has been deprecated in favor of the
#   # jolokia2 plugin
#   # see https://github.com/influxdata/telegraf/tree/master/plugins/inputs/jolokia2
#
#   ## This is the context root used to compose the jolokia url
#   ## NOTE that Jolokia requires a trailing slash at the end of the context root
#   ## NOTE that your jolokia security policy must allow for POST requests.
#   context = "/jolokia/"
#
#   ## This specifies the mode used
#   # mode = "proxy"
#   #
#   ## When in proxy mode this section is used to specify further
#   ## proxy address configurations.
#   ## Remember to change host address to fit your environment.
#   # [inputs.jolokia.proxy]
#   #   host = "127.0.0.1"
#   #   port = "8080"
#
#   ## Optional http timeouts
#   ##
#   ## response_header_timeout, if non-zero, specifies the amount of time to wait
#   ## for a server's response headers after fully writing the request.
#   # response_header_timeout = "3s"
#   ##
#   ## client_timeout specifies a time limit for requests made by this client.
#   ## Includes connection time, any redirects, and reading the response body.
#   # client_timeout = "4s"
#
#   ## Attribute delimiter
#   ##
#   ## When multiple attributes are returned for a single
#   ## [inputs.jolokia.metrics], the field name is a concatenation of the metric
#   ## name, and the attribute name, separated by the given delimiter.
#   # delimiter = "_"
#
#   ## List of servers exposing jolokia read service
#   [[inputs.jolokia.servers]]
#     name = "as-server-01"
#     host = "127.0.0.1"
#     port = "8080"
#     # username = "myuser"
#     # password = "mypassword"
#
#   ## List of metrics collected on above servers
#   ## Each metric consists in a name, a jmx path and either
#   ## a pass or drop slice attribute.
#   ## This collect all heap memory usage metrics.
#   [[inputs.jolokia.metrics]]
#     name = "heap_memory_usage"
#     mbean  = "java.lang:type=Memory"
#     attribute = "HeapMemoryUsage"
#
#   ## This collect thread counts metrics.
#   [[inputs.jolokia.metrics]]
#     name = "thread_count"
#     mbean  = "java.lang:type=Threading"
#     attribute = "TotalStartedThreadCount,ThreadCount,DaemonThreadCount,PeakThreadCount"
#
#   ## This collect number of class loaded/unloaded counts metrics.
#   [[inputs.jolokia.metrics]]
#     name = "class_count"
#     mbean  = "java.lang:type=ClassLoading"
#     attribute = "LoadedClassCount,UnloadedClassCount,TotalLoadedClassCount"


# # Read JMX metrics from a Jolokia REST agent endpoint
# [[inputs.jolokia2_agent]]
#   # default_tag_prefix      = ""
#   # default_field_prefix    = ""
#   # default_field_separator = "."
#
#   # Add agents URLs to query
#   urls = ["http://localhost:8080/jolokia"]
#   # username = ""
#   # password = ""
#   # response_timeout = "5s"
#
#   ## Optional TLS config
#   # tls_ca   = "/var/private/ca.pem"
#   # tls_cert = "/var/private/client.pem"
#   # tls_key  = "/var/private/client-key.pem"
#   # insecure_skip_verify = false
#
#   ## Add metrics to read
#   [[inputs.jolokia2_agent.metric]]
#     name  = "java_runtime"
#     mbean = "java.lang:type=Runtime"
#     paths = ["Uptime"]


# # Read JMX metrics from a Jolokia REST proxy endpoint
# [[inputs.jolokia2_proxy]]
#   # default_tag_prefix      = ""
#   # default_field_prefix    = ""
#   # default_field_separator = "."
#
#   ## Proxy agent
#   url = "http://localhost:8080/jolokia"
#   # username = ""
#   # password = ""
#   # response_timeout = "5s"
#
#   ## Optional TLS config
#   # tls_ca   = "/var/private/ca.pem"
#   # tls_cert = "/var/private/client.pem"
#   # tls_key  = "/var/private/client-key.pem"
#   # insecure_skip_verify = false
#
#   ## Add proxy targets to query
#   # default_target_username = ""
#   # default_target_password = ""
#   [[inputs.jolokia2_proxy.target]]
#     url = "service:jmx:rmi:///jndi/rmi://targethost:9999/jmxrmi"
#     # username = ""
#     # password = ""
#
#   ## Add metrics to read
#   [[inputs.jolokia2_proxy.metric]]
#     name  = "java_runtime"
#     mbean = "java.lang:type=Runtime"
#     paths = ["Uptime"]


# # Read Kapacitor-formatted JSON metrics from one or more HTTP endpoints
# [[inputs.kapacitor]]
#   ## Multiple URLs from which to read Kapacitor-formatted JSON
#   ## Default is "http://localhost:9092/kapacitor/v1/debug/vars".
#   urls = [
#     "http://localhost:9092/kapacitor/v1/debug/vars"
#   ]
#
#   ## Time limit for http requests
#   timeout = "5s"
#
#   ## Optional TLS Config
#   # tls_ca = "/etc/telegraf/ca.pem"
#   # tls_cert = "/etc/telegraf/cert.pem"
#   # tls_key = "/etc/telegraf/key.pem"
#   ## Use TLS but skip chain & host verification
#   # insecure_skip_verify = false


# # Get kernel statistics from /proc/vmstat
# [[inputs.kernel_vmstat]]
#   # no configuration


# # Read status information from one or more Kibana servers
# [[inputs.kibana]]
#   ## specify a list of one or more Kibana servers
#   servers = ["http://localhost:5601"]
#
#   ## Timeout for HTTP requests
#   timeout = "5s"
#
#   ## HTTP Basic Auth credentials
#   # username = "username"
#   # password = "pa$$word"
#
#   ## Optional TLS Config
#   # tls_ca = "/etc/telegraf/ca.pem"
#   # tls_cert = "/etc/telegraf/cert.pem"
#   # tls_key = "/etc/telegraf/key.pem"
#   ## Use TLS but skip chain & host verification
#   # insecure_skip_verify = false


# # Read metrics from the kubernetes kubelet api
# [[inputs.kubernetes]]
#   ## URL for the kubelet
#   url = "http://1.1.1.1:10255"
#
#   ## Use bearer token for authorization
#   # bearer_token = /path/to/bearer/token
#
#   ## Set response_timeout (default 5 seconds)
#   # response_timeout = "5s"
#
#   ## Optional TLS Config
#   # tls_ca = /path/to/cafile
#   # tls_cert = /path/to/certfile
#   # tls_key = /path/to/keyfile
#   ## Use TLS but skip chain & host verification
#   # insecure_skip_verify = false


# # Read metrics from a LeoFS Server via SNMP
# [[inputs.leofs]]
#   ## An array of URLs of the form:
#   ##   host [ ":" port]
#   servers = ["127.0.0.1:4020"]


# # Provides Linux sysctl fs metrics
# [[inputs.linux_sysctl_fs]]
#   # no configuration


# # Read metrics from local Lustre service on OST, MDS
# [[inputs.lustre2]]
#   ## An array of /proc globs to search for Lustre stats
#   ## If not specified, the default will work on Lustre 2.5.x
#   ##
#   # ost_procfiles = [
#   #   "/proc/fs/lustre/obdfilter/*/stats",
#   #   "/proc/fs/lustre/osd-ldiskfs/*/stats",
#   #   "/proc/fs/lustre/obdfilter/*/job_stats",
#   # ]
#   # mds_procfiles = [
#   #   "/proc/fs/lustre/mdt/*/md_stats",
#   #   "/proc/fs/lustre/mdt/*/job_stats",
#   # ]


# # Gathers metrics from the /3.0/reports MailChimp API
# [[inputs.mailchimp]]
#   ## MailChimp API key
#   ## get from https://admin.mailchimp.com/account/api/
#   api_key = "" # required
#   ## Reports for campaigns sent more than days_old ago will not be collected.
#   ## 0 means collect all.
#   days_old = 0
#   ## Campaign ID to get, if empty gets all campaigns, this option overrides days_old
#   # campaign_id = ""


# # Read metrics from one or many mcrouter servers
# [[inputs.mcrouter]]
#   ## An array of address to gather stats about. Specify an ip or hostname
#   ## with port. ie tcp://localhost:11211, tcp://10.0.0.1:11211, etc.
# 	servers = ["tcp://localhost:11211", "unix:///var/run/mcrouter.sock"]
#
# 	## Timeout for metric collections from all servers.  Minimum timeout is "1s".
#   # timeout = "5s"


# # Read metrics from one or many memcached servers
# [[inputs.memcached]]
#   ## An array of address to gather stats about. Specify an ip on hostname
#   ## with optional port. ie localhost, 10.0.0.1:11211, etc.
#   servers = ["localhost:11211"]
#   # unix_sockets = ["/var/run/memcached.sock"]


# # Telegraf plugin for gathering metrics from N Mesos masters
# [[inputs.mesos]]
#   ## Timeout, in ms.
#   timeout = 100
#   ## A list of Mesos masters.
#   masters = ["http://localhost:5050"]
#   ## Master metrics groups to be collected, by default, all enabled.
#   master_collections = [
#     "resources",
#     "master",
#     "system",
#     "agents",
#     "frameworks",
#     "tasks",
#     "messages",
#     "evqueue",
#     "registrar",
#   ]
#   ## A list of Mesos slaves, default is []
#   # slaves = []
#   ## Slave metrics groups to be collected, by default, all enabled.
#   # slave_collections = [
#   #   "resources",
#   #   "agent",
#   #   "system",
#   #   "executors",
#   #   "tasks",
#   #   "messages",
#   # ]
#
#   ## Optional TLS Config
#   # tls_ca = "/etc/telegraf/ca.pem"
#   # tls_cert = "/etc/telegraf/cert.pem"
#   # tls_key = "/etc/telegraf/key.pem"
#   ## Use TLS but skip chain & host verification
#   # insecure_skip_verify = false


# # Collects scores from a minecraft server's scoreboard using the RCON protocol
# [[inputs.minecraft]]
#   ## server address for minecraft
#   # server = "localhost"
#   ## port for RCON
#   # port = "25575"
#   ## password RCON for mincraft server
#   # password = ""


# # Read metrics from one or many MongoDB servers
# [[inputs.mongodb]]
#   ## An array of URLs of the form:
#   ##   "mongodb://" [user ":" pass "@"] host [ ":" port]
#   ## For example:
#   ##   mongodb://user:auth_key@10.10.3.30:27017,
#   ##   mongodb://10.10.3.33:18832,
#   servers = ["mongodb://127.0.0.1:27017"]
#
#   ## When true, collect per database stats
#   # gather_perdb_stats = false
#
#   ## Optional TLS Config
#   # tls_ca = "/etc/telegraf/ca.pem"
#   # tls_cert = "/etc/telegraf/cert.pem"
#   # tls_key = "/etc/telegraf/key.pem"
#   ## Use TLS but skip chain & host verification
#   # insecure_skip_verify = false


# # Read metrics from one or many mysql servers
# [[inputs.mysql]]
#   ## specify servers via a url matching:
#   ##  [username[:password]@][protocol[(address)]]/[?tls=[true|false|skip-verify|custom]]
#   ##  see https://github.com/go-sql-driver/mysql#dsn-data-source-name
#   ##  e.g.
#   ##    servers = ["user:passwd@tcp(127.0.0.1:3306)/?tls=false"]
#   ##    servers = ["user@tcp(127.0.0.1:3306)/?tls=false"]
#   #
#   ## If no servers are specified, then localhost is used as the host.
#   servers = ["tcp(127.0.0.1:3306)/"]
#
#   ## Selects the metric output format.
#   ##
#   ## This option exists to maintain backwards compatibility, if you have
#   ## existing metrics do not set or change this value until you are ready to
#   ## migrate to the new format.
#   ##
#   ## If you do not have existing metrics from this plugin set to the latest
#   ## version.
#   ##
#   ## Telegraf >=1.6: metric_version = 2
#   ##           <1.6: metric_version = 1 (or unset)
#   metric_version = 2
#
#   ## the limits for metrics form perf_events_statements
#   perf_events_statements_digest_text_limit  = 120
#   perf_events_statements_limit              = 250
#   perf_events_statements_time_limit         = 86400
#   #
#   ## if the list is empty, then metrics are gathered from all databasee tables
#   table_schema_databases                    = []
#   #
#   ## gather metrics from INFORMATION_SCHEMA.TABLES for databases provided above list
#   gather_table_schema                       = false
#   #
#   ## gather thread state counts from INFORMATION_SCHEMA.PROCESSLIST
#   gather_process_list                       = true
#   #
#   ## gather user statistics from INFORMATION_SCHEMA.USER_STATISTICS
#   gather_user_statistics                    = true
#   #
#   ## gather auto_increment columns and max values from information schema
#   gather_info_schema_auto_inc               = true
#   #
#   ## gather metrics from INFORMATION_SCHEMA.INNODB_METRICS
#   gather_innodb_metrics                     = true
#   #
#   ## gather metrics from SHOW SLAVE STATUS command output
#   gather_slave_status                       = true
#   #
#   ## gather metrics from SHOW BINARY LOGS command output
#   gather_binary_logs                        = false
#   #
#   ## gather metrics from PERFORMANCE_SCHEMA.TABLE_IO_WAITS_SUMMARY_BY_TABLE
#   gather_table_io_waits                     = false
#   #
#   ## gather metrics from PERFORMANCE_SCHEMA.TABLE_LOCK_WAITS
#   gather_table_lock_waits                   = false
#   #
#   ## gather metrics from PERFORMANCE_SCHEMA.TABLE_IO_WAITS_SUMMARY_BY_INDEX_USAGE
#   gather_index_io_waits                     = false
#   #
#   ## gather metrics from PERFORMANCE_SCHEMA.EVENT_WAITS
#   gather_event_waits                        = false
#   #
#   ## gather metrics from PERFORMANCE_SCHEMA.FILE_SUMMARY_BY_EVENT_NAME
#   gather_file_events_stats                  = false
#   #
#   ## gather metrics from PERFORMANCE_SCHEMA.EVENTS_STATEMENTS_SUMMARY_BY_DIGEST
#   gather_perf_events_statements             = false
#   #
#   ## Some queries we may want to run less often (such as SHOW GLOBAL VARIABLES)
#   interval_slow                   = "30m"
#
#   ## Optional TLS Config (will be used if tls=custom parameter specified in server uri)
#   # tls_ca = "/etc/telegraf/ca.pem"
#   # tls_cert = "/etc/telegraf/cert.pem"
#   # tls_key = "/etc/telegraf/key.pem"
#   ## Use TLS but skip chain & host verification
#   # insecure_skip_verify = false


# # Provides metrics about the state of a NATS server
# [[inputs.nats]]
#   ## The address of the monitoring endpoint of the NATS server
#   server = "http://localhost:8222"
#
#   ## Maximum time to receive response
#   # response_timeout = "5s"


# # Read metrics about network interface usage
[[inputs.net]]
#   ## By default, telegraf gathers stats from any up interface (excluding loopback)
#   ## Setting interfaces will tell it to gather these explicit interfaces,
#   ## regardless of status.
#   ##
#   # interfaces = ["eth0"]
#   ##
#   ## On linux systems telegraf also collects protocol stats.
#   ## Setting ignore_protocol_stats to true will skip reporting of protocol metrics.
#   ##
#   # ignore_protocol_stats = false
#   ##


# # Collect response time of a TCP or UDP connection
# [[inputs.net_response]]
#   ## Protocol, must be "tcp" or "udp"
#   ## NOTE: because the "udp" protocol does not respond to requests, it requires
#   ## a send/expect string pair (see below).
#   protocol = "tcp"
#   ## Server address (default localhost)
#   address = "localhost:80"
#
#   ## Set timeout
#   # timeout = "1s"
#
#   ## Set read timeout (only used if expecting a response)
#   # read_timeout = "1s"
#
#   ## The following options are required for UDP checks. For TCP, they are
#   ## optional. The plugin will send the given string to the server and then
#   ## expect to receive the given 'expect' string back.
#   ## string sent to the server
#   # send = "ssh"
#   ## expected string in answer
#   # expect = "ssh"
#
#   ## Uncomment to remove deprecated fields
#   # fieldexclude = ["result_type", "string_found"]


# # Read TCP metrics such as established, time wait and sockets counts.
# [[inputs.netstat]]
#   # no configuration


# # Read Nginx's basic status information (ngx_http_stub_status_module)
# [[inputs.nginx]]
#   # An array of Nginx stub_status URI to gather stats.
#   urls = ["http://localhost/server_status"]
#
#   ## Optional TLS Config
#   tls_ca = "/etc/telegraf/ca.pem"
#   tls_cert = "/etc/telegraf/cert.cer"
#   tls_key = "/etc/telegraf/key.key"
#   ## Use TLS but skip chain & host verification
#   insecure_skip_verify = false
#
#   # HTTP response timeout (default: 5s)
#   response_timeout = "5s"


# # Read Nginx Plus' full status information (ngx_http_status_module)
# [[inputs.nginx_plus]]
#   ## An array of ngx_http_status_module or status URI to gather stats.
#   urls = ["http://localhost/status"]
#
#   # HTTP response timeout (default: 5s)
#   response_timeout = "5s"


# # Read Nginx Plus Api documentation
# [[inputs.nginx_plus_api]]
#   ## An array of API URI to gather stats.
#   urls = ["http://localhost/api"]
#
#   # Nginx API version, default: 3
#   # api_version = 3
#
#   # HTTP response timeout (default: 5s)
#   response_timeout = "5s"


# # Read Nginx virtual host traffic status module information (nginx-module-vts)
# [[inputs.nginx_vts]]
#   ## An array of ngx_http_status_module or status URI to gather stats.
#   urls = ["http://localhost/status"]
#
#   ## HTTP response timeout (default: 5s)
#   response_timeout = "5s"


# # Read NSQ topic and channel statistics.
# [[inputs.nsq]]
#   ## An array of NSQD HTTP API endpoints
#   endpoints  = ["http://localhost:4151"]
#
#   ## Optional TLS Config
#   # tls_ca = "/etc/telegraf/ca.pem"
#   # tls_cert = "/etc/telegraf/cert.pem"
#   # tls_key = "/etc/telegraf/key.pem"
#   ## Use TLS but skip chain & host verification
#   # insecure_skip_verify = false


# # Collect kernel snmp counters and network interface statistics
# [[inputs.nstat]]
#   ## file paths for proc files. If empty default paths will be used:
#   ##    /proc/net/netstat, /proc/net/snmp, /proc/net/snmp6
#   ## These can also be overridden with env variables, see README.
#   proc_net_netstat = "/proc/net/netstat"
#   proc_net_snmp = "/proc/net/snmp"
#   proc_net_snmp6 = "/proc/net/snmp6"
#   ## dump metrics with 0 values too
#   dump_zeros       = true


# # Get standard NTP query metrics, requires ntpq executable.
# [[inputs.ntpq]]
#   ## If false, set the -n ntpq flag. Can reduce metric gather time.
#   dns_lookup = true


# # Pulls statistics from nvidia GPUs attached to the host
# [[inputs.nvidia_smi]]
#   ## Optional: path to nvidia-smi binary, defaults to $PATH via exec.LookPath
#    bin_path = "/usr/bin/nvidia-smi"
#
#   ## Optional: timeout for GPU polling
#    timeout = "5s"


# # OpenLDAP cn=Monitor plugin
# [[inputs.openldap]]
#   host = "localhost"
#   port = 389
#
#   # ldaps, starttls, or no encryption. default is an empty string, disabling all encryption.
#   # note that port will likely need to be changed to 636 for ldaps
#   # valid options: "" | "starttls" | "ldaps"
#   tls = ""
#
#   # skip peer certificate verification. Default is false.
#   insecure_skip_verify = false
#
#   # Path to PEM-encoded Root certificate to use to verify server certificate
#   tls_ca = "/etc/ssl/certs.pem"
#
#   # dn/password to bind with. If bind_dn is empty, an anonymous bind is performed.
#   bind_dn = ""
#   bind_password = ""
#
#   # Reverse metric names so they sort more naturally. Recommended.
#   # This defaults to false if unset, but is set to true when generating a new config
#   reverse_metric_names = true


# # A plugin to collect stats from Opensmtpd - a validating, recursive, and caching DNS resolver
# [[inputs.opensmtpd]]
#   ## If running as a restricted user you can prepend sudo for additional access:
#   #use_sudo = false
#
#   ## The default location of the smtpctl binary can be overridden with:
#   binary = "/usr/sbin/smtpctl"
#
#   ## The default timeout of 1000ms can be overriden with (in milliseconds):
#   timeout = 1000


# # Read metrics of passenger using passenger-status
# [[inputs.passenger]]
#   ## Path of passenger-status.
#   ##
#   ## Plugin gather metric via parsing XML output of passenger-status
#   ## More information about the tool:
#   ##   https://www.phusionpassenger.com/library/admin/apache/overall_status_report.html
#   ##
#   ## If no path is specified, then the plugin simply execute passenger-status
#   ## hopefully it can be found in your PATH
#   command = "passenger-status -v --show=xml"


# # Gather counters from PF
# [[inputs.pf]]
#   ## PF require root access on most systems.
#   ## Setting 'use_sudo' to true will make use of sudo to run pfctl.
#   ## Users must configure sudo to allow telegraf user to run pfctl with no password.
#   ## pfctl can be restricted to only list command "pfctl -s info".
#   use_sudo = false


# # Read metrics of phpfpm, via HTTP status page or socket
# [[inputs.phpfpm]]
#   ## An array of addresses to gather stats about. Specify an ip or hostname
#   ## with optional port and path
#   ##
#   ## Plugin can be configured in three modes (either can be used):
#   ##   - http: the URL must start with http:// or https://, ie:
#   ##       "http://localhost/status"
#   ##       "http://192.168.130.1/status?full"
#   ##
#   ##   - unixsocket: path to fpm socket, ie:
#   ##       "/var/run/php5-fpm.sock"
#   ##      or using a custom fpm status path:
#   ##       "/var/run/php5-fpm.sock:fpm-custom-status-path"
#   ##
#   ##   - fcgi: the URL must start with fcgi:// or cgi://, and port must be present, ie:
#   ##       "fcgi://10.0.0.12:9000/status"
#   ##       "cgi://10.0.10.12:9001/status"
#   ##
#   ## Example of multiple gathering from local socket and remove host
#   ## urls = ["http://192.168.1.20/status", "/tmp/fpm.sock"]
#   urls = ["http://localhost/status"]


# # Ping given url(s) and return statistics
# [[inputs.ping]]
#   ## List of urls to ping
#   urls = ["example.org"]
#
#   ## Number of pings to send per collection (ping -c <COUNT>)
#   # count = 1
#
#   ## Interval, in s, at which to ping. 0 == default (ping -i <PING_INTERVAL>)
#   ## Not available in Windows.
#   # ping_interval = 1.0
#
#   ## Per-ping timeout, in s. 0 == no timeout (ping -W <TIMEOUT>)
#   # timeout = 1.0
#
#   ## Total-ping deadline, in s. 0 == no deadline (ping -w <DEADLINE>)
#   # deadline = 10
#
#   ## Interface or source address to send ping from (ping -I <INTERFACE/SRC_ADDR>)
#   ## on Darwin and Freebsd only source address possible: (ping -S <SRC_ADDR>)
#   # interface = ""
#
#   ## Specify the ping executable binary, default is "ping"
#   # binary = "ping"
#
#   ## Arguments for ping command
#   ## when arguments is not empty, other options (ping_interval, timeout, etc) will be ignored
#   # arguments = ["-c", "3"]


# # Measure postfix queue statistics
# [[inputs.postfix]]
#   ## Postfix queue directory. If not provided, telegraf will try to use
#   ## 'postconf -h queue_directory' to determine it.
#   # queue_directory = "/var/spool/postfix"


# # Read metrics from one or many PowerDNS servers
# [[inputs.powerdns]]
#   ## An array of sockets to gather stats about.
#   ## Specify a path to unix socket.
#   unix_sockets = ["/var/run/pdns.controlsocket"]


# # Monitor process cpu and memory usage
# [[inputs.procstat]]
#   ## PID file to monitor process
#   pid_file = "/var/run/nginx.pid"
#   ## executable name (ie, pgrep <exe>)
#   # exe = "nginx"
#   ## pattern as argument for pgrep (ie, pgrep -f <pattern>)
#   # pattern = "nginx"
#   ## user as argument for pgrep (ie, pgrep -u <user>)
#   # user = "nginx"
#   ## Systemd unit name
#   # systemd_unit = "nginx.service"
#   ## CGroup name or path
#   # cgroup = "systemd/system.slice/nginx.service"
#
#   ## Windows service name
#   # win_service = ""
#
#   ## override for process_name
#   ## This is optional; default is sourced from /proc/<pid>/status
#   # process_name = "bar"
#
#   ## Field name prefix
#   # prefix = ""
#
#   ## Add PID as a tag instead of a field; useful to differentiate between
#   ## processes whose tags are otherwise the same.  Can create a large number
#   ## of series, use judiciously.
#   # pid_tag = false
#
#   ## Method to use when finding process IDs.  Can be one of 'pgrep', or
#   ## 'native'.  The pgrep finder calls the pgrep executable in the PATH while
#   ## the native finder performs the search directly in a manor dependent on the
#   ## platform.  Default is 'pgrep'
#   # pid_finder = "pgrep"


# # Reads last_run_summary.yaml file and converts to measurments
# [[inputs.puppetagent]]
#   ## Location of puppet last run summary file
#   location = "/var/lib/puppet/state/last_run_summary.yaml"


# # Reads metrics from RabbitMQ servers via the Management Plugin
# [[inputs.rabbitmq]]
#   ## Management Plugin url. (default: http://localhost:15672)
#   # url = "http://localhost:15672"
#   ## Tag added to rabbitmq_overview series; deprecated: use tags
#   # name = "rmq-server-1"
#   ## Credentials
#   # username = "guest"
#   # password = "guest"
#
#   ## Optional TLS Config
#   # tls_ca = "/etc/telegraf/ca.pem"
#   # tls_cert = "/etc/telegraf/cert.pem"
#   # tls_key = "/etc/telegraf/key.pem"
#   ## Use TLS but skip chain & host verification
#   # insecure_skip_verify = false
#
#   ## Optional request timeouts
#   ##
#   ## ResponseHeaderTimeout, if non-zero, specifies the amount of time to wait
#   ## for a server's response headers after fully writing the request.
#   # header_timeout = "3s"
#   ##
#   ## client_timeout specifies a time limit for requests made by this client.
#   ## Includes connection time, any redirects, and reading the response body.
#   # client_timeout = "4s"
#
#   ## A list of nodes to gather as the rabbitmq_node measurement. If not
#   ## specified, metrics for all nodes are gathered.
#   # nodes = ["rabbit@node1", "rabbit@node2"]
#
#   ## A list of queues to gather as the rabbitmq_queue measurement. If not
#   ## specified, metrics for all queues are gathered.
#   # queues = ["telegraf"]
#
#   ## A list of exchanges to gather as the rabbitmq_exchange measurement. If not
#   ## specified, metrics for all exchanges are gathered.
#   # exchanges = ["telegraf"]
#
#   ## Queues to include and exclude. Globs accepted.
#   ## Note that an empty array for both will include all queues
#   queue_name_include = []
#   queue_name_exclude = []


# # Read raindrops stats (raindrops - real-time stats for preforking Rack servers)
# [[inputs.raindrops]]
#   ## An array of raindrops middleware URI to gather stats.
#   urls = ["http://localhost:8080/_raindrops"]


# # Read metrics from one or many redis servers
# [[inputs.redis]]
#   ## specify servers via a url matching:
#   ##  [protocol://][:password]@address[:port]
#   ##  e.g.
#   ##    tcp://localhost:6379
#   ##    tcp://:password@192.168.99.100
#   ##    unix:///var/run/redis.sock
#   ##
#   ## If no servers are specified, then localhost is used as the host.
#   ## If no port is specified, 6379 is used
#   servers = ["tcp://localhost:6379"]
#
#   ## specify server password
#   # password = "s#cr@t%"
#
#   ## Optional TLS Config
#   # tls_ca = "/etc/telegraf/ca.pem"
#   # tls_cert = "/etc/telegraf/cert.pem"
#   # tls_key = "/etc/telegraf/key.pem"
#   ## Use TLS but skip chain & host verification
#   # insecure_skip_verify = true


# # Read metrics from one or many RethinkDB servers
# [[inputs.rethinkdb]]
#   ## An array of URI to gather stats about. Specify an ip or hostname
#   ## with optional port add password. ie,
#   ##   rethinkdb://user:auth_key@10.10.3.30:28105,
#   ##   rethinkdb://10.10.3.33:18832,
#   ##   10.0.0.1:10000, etc.
#   servers = ["127.0.0.1:28015"]
#   ##
#   ## If you use actual rethinkdb of > 2.3.0 with username/password authorization,
#   ## protocol have to be named "rethinkdb2" - it will use 1_0 H.
#   # servers = ["rethinkdb2://username:password@127.0.0.1:28015"]
#   ##
#   ## If you use older versions of rethinkdb (<2.2) with auth_key, protocol
#   ## have to be named "rethinkdb".
#   # servers = ["rethinkdb://username:auth_key@127.0.0.1:28015"]


# # Read metrics one or many Riak servers
# [[inputs.riak]]
#   # Specify a list of one or more riak http servers
#   servers = ["http://localhost:8098"]


# # Read API usage and limits for a Salesforce organisation
# [[inputs.salesforce]]
#   ## specify your credentials
#   ##
#   username = "your_username"
#   password = "your_password"
#   ##
#   ## (optional) security token
#   # security_token = "your_security_token"
#   ##
#   ## (optional) environment type (sandbox or production)
#   ## default is: production
#   ##
#   # environment = "production"
#   ##
#   ## (optional) API version (default: "39.0")
#   ##
#   # version = "39.0"


# # Monitor sensors, requires lm-sensors package
# [[inputs.sensors]]
#   ## Remove numbers from field names.
#   ## If true, a field name like 'temp1_input' will be changed to 'temp_input'.
#   # remove_numbers = true
#
#   ## Timeout is the maximum amount of time that the sensors command can run.
#   # timeout = "5s"


# # Read metrics from storage devices supporting S.M.A.R.T.
# [[inputs.smart]]
#   ## Optionally specify the path to the smartctl executable
#   # path = "/usr/bin/smartctl"
#   #
#   ## On most platforms smartctl requires root access.
#   ## Setting 'use_sudo' to true will make use of sudo to run smartctl.
#   ## Sudo must be configured to to allow the telegraf user to run smartctl
#   ## with out password.
#   # use_sudo = false
#   #
#   ## Skip checking disks in this power mode. Defaults to
#   ## "standby" to not wake up disks that have stoped rotating.
#   ## See --nocheck in the man pages for smartctl.
#   ## smartctl version 5.41 and 5.42 have faulty detection of
#   ## power mode and might require changing this value to
#   ## "never" depending on your disks.
#   # nocheck = "standby"
#   #
#   ## Gather detailed metrics for each SMART Attribute.
#   ## Defaults to "false"
#   ##
#   # attributes = false
#   #
#   ## Optionally specify devices to exclude from reporting.
#   # excludes = [ "/dev/pass6" ]
#   #
#   ## Optionally specify devices and device type, if unset
#   ## a scan (smartctl --scan) for S.M.A.R.T. devices will
#   ## done and all found will be included except for the
#   ## excluded in excludes.
#   # devices = [ "/dev/ada0 -d atacam" ]


# # Retrieves SNMP values from remote agents
# [[inputs.snmp]]
#   agents = [ "127.0.0.1:161" ]
#   ## Timeout for each SNMP query.
#   timeout = "5s"
#   ## Number of retries to attempt within timeout.
#   retries = 3
#   ## SNMP version, values can be 1, 2, or 3
#   version = 2
#
#   ## SNMP community string.
#   community = "public"
#
#   ## The GETBULK max-repetitions parameter
#   max_repetitions = 10
#
#   ## SNMPv3 auth parameters
#   #sec_name = "myuser"
#   #auth_protocol = "md5"      # Values: "MD5", "SHA", ""
#   #auth_password = "pass"
#   #sec_level = "authNoPriv"   # Values: "noAuthNoPriv", "authNoPriv", "authPriv"
#   #context_name = ""
#   #priv_protocol = ""         # Values: "DES", "AES", ""
#   #priv_password = ""
#
#   ## measurement name
#   name = "system"
#   [[inputs.snmp.field]]
#     name = "hostname"
#     oid = ".1.0.0.1.1"
#   [[inputs.snmp.field]]
#     name = "uptime"
#     oid = ".1.0.0.1.2"
#   [[inputs.snmp.field]]
#     name = "load"
#     oid = ".1.0.0.1.3"
#   [[inputs.snmp.field]]
#     oid = "HOST-RESOURCES-MIB::hrMemorySize"
#
#   [[inputs.snmp.table]]
#     ## measurement name
#     name = "remote_servers"
#     inherit_tags = [ "hostname" ]
#     [[inputs.snmp.table.field]]
#       name = "server"
#       oid = ".1.0.0.0.1.0"
#       is_tag = true
#     [[inputs.snmp.table.field]]
#       name = "connections"
#       oid = ".1.0.0.0.1.1"
#     [[inputs.snmp.table.field]]
#       name = "latency"
#       oid = ".1.0.0.0.1.2"
#
#   [[inputs.snmp.table]]
#     ## auto populate table's fields using the MIB
#     oid = "HOST-RESOURCES-MIB::hrNetworkTable"


# # DEPRECATED! PLEASE USE inputs.snmp INSTEAD.
# [[inputs.snmp_legacy]]
#   ## Use 'oids.txt' file to translate oids to names
#   ## To generate 'oids.txt' you need to run:
#   ##   snmptranslate -m all -Tz -On | sed -e 's/"//g' > /tmp/oids.txt
#   ## Or if you have an other MIB folder with custom MIBs
#   ##   snmptranslate -M /mycustommibfolder -Tz -On -m all | sed -e 's/"//g' > oids.txt
#   snmptranslate_file = "/tmp/oids.txt"
#   [[inputs.snmp.host]]
#     address = "192.168.2.2:161"
#     # SNMP community
#     community = "public" # default public
#     # SNMP version (1, 2 or 3)
#     # Version 3 not supported yet
#     version = 2 # default 2
#     # SNMP response timeout
#     timeout = 2.0 # default 2.0
#     # SNMP request retries
#     retries = 2 # default 2
#     # Which get/bulk do you want to collect for this host
#     collect = ["mybulk", "sysservices", "sysdescr"]
#     # Simple list of OIDs to get, in addition to "collect"
#     get_oids = []
#
#   [[inputs.snmp.host]]
#     address = "192.168.2.3:161"
#     community = "public"
#     version = 2
#     timeout = 2.0
#     retries = 2
#     collect = ["mybulk"]
#     get_oids = [
#         "ifNumber",
#         ".1.3.6.1.2.1.1.3.0",
#     ]
#
#   [[inputs.snmp.get]]
#     name = "ifnumber"
#     oid = "ifNumber"
#
#   [[inputs.snmp.get]]
#     name = "interface_speed"
#     oid = "ifSpeed"
#     instance = "0"
#
#   [[inputs.snmp.get]]
#     name = "sysuptime"
#     oid = ".1.3.6.1.2.1.1.3.0"
#     unit = "second"
#
#   [[inputs.snmp.bulk]]
#     name = "mybulk"
#     max_repetition = 127
#     oid = ".1.3.6.1.2.1.1"
#
#   [[inputs.snmp.bulk]]
#     name = "ifoutoctets"
#     max_repetition = 127
#     oid = "ifOutOctets"
#
#   [[inputs.snmp.host]]
#     address = "192.168.2.13:161"
#     #address = "127.0.0.1:161"
#     community = "public"
#     version = 2
#     timeout = 2.0
#     retries = 2
#     #collect = ["mybulk", "sysservices", "sysdescr", "systype"]
#     collect = ["sysuptime" ]
#     [[inputs.snmp.host.table]]
#       name = "iftable3"
#       include_instances = ["enp5s0", "eth1"]
#
#   # SNMP TABLEs
#   # table without mapping neither subtables
#   [[inputs.snmp.table]]
#     name = "iftable1"
#     oid = ".1.3.6.1.2.1.31.1.1.1"
#
#   # table without mapping but with subtables
#   [[inputs.snmp.table]]
#     name = "iftable2"
#     oid = ".1.3.6.1.2.1.31.1.1.1"
#     sub_tables = [".1.3.6.1.2.1.2.2.1.13"]
#
#   # table with mapping but without subtables
#   [[inputs.snmp.table]]
#     name = "iftable3"
#     oid = ".1.3.6.1.2.1.31.1.1.1"
#     # if empty. get all instances
#     mapping_table = ".1.3.6.1.2.1.31.1.1.1.1"
#     # if empty, get all subtables
#
#   # table with both mapping and subtables
#   [[inputs.snmp.table]]
#     name = "iftable4"
#     oid = ".1.3.6.1.2.1.31.1.1.1"
#     # if empty get all instances
#     mapping_table = ".1.3.6.1.2.1.31.1.1.1.1"
#     # if empty get all subtables
#     # sub_tables could be not "real subtables"
#     sub_tables=[".1.3.6.1.2.1.2.2.1.13", "bytes_recv", "bytes_send"]


# # Read stats from one or more Solr servers or cores
# [[inputs.solr]]
#   ## specify a list of one or more Solr servers
#   servers = ["http://localhost:8983"]
#
#   ## specify a list of one or more Solr cores (default - all)
#   # cores = ["main"]


# # Read metrics from Microsoft SQL Server
# [[inputs.sqlserver]]
#   ## Specify instances to monitor with a list of connection strings.
#   ## All connection parameters are optional.
#   ## By default, the host is localhost, listening on default port, TCP 1433.
#   ##   for Windows, the user is the currently running AD user (SSO).
#   ##   See https://github.com/denisenkom/go-mssqldb for detailed connection
#   ##   parameters.
#   # servers = [
#   #  "Server=192.168.1.10;Port=1433;User Id=<user>;Password=<pw>;app name=telegraf;log=1;",
#   # ]
#
#   ## Optional parameter, setting this to 2 will use a new version
#   ## of the collection queries that break compatibility with the original
#   ## dashboards.
#   query_version = 2
#
#   ## If you are using AzureDB, setting this to true will gather resource utilization metrics
#   # azuredb = false
#
#   ## If you would like to exclude some of the metrics queries, list them here
#   ## Possible choices:
#   ## - PerformanceCounters
#   ## - WaitStatsCategorized
#   ## - DatabaseIO
#   ## - DatabaseProperties
#   ## - CPUHistory
#   ## - DatabaseSize
#   ## - DatabaseStats
#   ## - MemoryClerk
#   ## - VolumeSpace
#   ## - PerformanceMetrics
#   # exclude_query = [ 'DatabaseIO' ]


# # Sysstat metrics collector
# [[inputs.sysstat]]
#   ## Path to the sadc command.
#   #
#   ## Common Defaults:
#   ##   Debian/Ubuntu: /usr/lib/sysstat/sadc
#   ##   Arch:          /usr/lib/sa/sadc
#   ##   RHEL/CentOS:   /usr/lib64/sa/sadc
#   sadc_path = "/usr/lib/sa/sadc" # required
#   #
#   #
#   ## Path to the sadf command, if it is not in PATH
#   # sadf_path = "/usr/bin/sadf"
#   #
#   #
#   ## Activities is a list of activities, that are passed as argument to the
#   ## sadc collector utility (e.g: DISK, SNMP etc...)
#   ## The more activities that are added, the more data is collected.
#   # activities = ["DISK"]
#   #
#   #
#   ## Group metrics to measurements.
#   ##
#   ## If group is false each metric will be prefixed with a description
#   ## and represents itself a measurement.
#   ##
#   ## If Group is true, corresponding metrics are grouped to a single measurement.
#   # group = true
#   #
#   #
#   ## Options for the sadf command. The values on the left represent the sadf
#   ## options and the values on the right their description (which are used for
#   ## grouping and prefixing metrics).
#   ##
#   ## Run 'sar -h' or 'man sar' to find out the supported options for your
#   ## sysstat version.
#   [inputs.sysstat.options]
#     -C = "cpu"
#     -B = "paging"
#     -b = "io"
#     -d = "disk"             # requires DISK activity
#     "-n ALL" = "network"
#     "-P ALL" = "per_cpu"
#     -q = "queue"
#     -R = "mem"
#     -r = "mem_util"
#     -S = "swap_util"
#     -u = "cpu_util"
#     -v = "inode"
#     -W = "swap"
#     -w = "task"
#   #  -H = "hugepages"        # only available for newer linux distributions
#   #  "-I ALL" = "interrupts" # requires INT activity
#   #
#   #
#   ## Device tags can be used to add additional tags for devices.
#   ## For example the configuration below adds a tag vg with value rootvg for
#   ## all metrics with sda devices.
#   # [[inputs.sysstat.device_tags.sda]]
#   #  vg = "rootvg"


# # Reads metrics from a Teamspeak 3 Server via ServerQuery
# [[inputs.teamspeak]]
#   ## Server address for Teamspeak 3 ServerQuery
#   # server = "127.0.0.1:10011"
#   ## Username for ServerQuery
#   username = "serverqueryuser"
#   ## Password for ServerQuery
#   password = "secret"
#   ## Array of virtual servers
#   # virtual_servers = [1]


# # Read metrics about temperature
# [[inputs.temp]]
#   # no configuration


# # Read Tengine's basic status information (ngx_http_reqstat_module)
# [[inputs.tengine]]
#   # An array of Tengine reqstat module URI to gather stats.
#   urls = ["http://127.0.0.1/us"]
#
#   # HTTP response timeout (default: 5s)
#   # response_timeout = "5s"
#
#   ## Optional TLS Config
#   # tls_ca = "/etc/telegraf/ca.pem"
#   # tls_cert = "/etc/telegraf/cert.cer"
#   # tls_key = "/etc/telegraf/key.key"
#   ## Use TLS but skip chain & host verification
#   # insecure_skip_verify = false


# # Gather metrics from the Tomcat server status page.
# [[inputs.tomcat]]
#   ## URL of the Tomcat server status
#   # url = "http://127.0.0.1:8080/manager/status/all?XML=true"
#
#   ## HTTP Basic Auth Credentials
#   # username = "tomcat"
#   # password = "s3cret"
#
#   ## Request timeout
#   # timeout = "5s"
#
#   ## Optional TLS Config
#   # tls_ca = "/etc/telegraf/ca.pem"
#   # tls_cert = "/etc/telegraf/cert.pem"
#   # tls_key = "/etc/telegraf/key.pem"
#   ## Use TLS but skip chain & host verification
#   # insecure_skip_verify = false


# # Inserts sine and cosine waves for demonstration purposes
# [[inputs.trig]]
#   ## Set the amplitude
#   amplitude = 10.0


# # Read Twemproxy stats data
# [[inputs.twemproxy]]
#   ## Twemproxy stats address and port (no scheme)
#   addr = "localhost:22222"
#   ## Monitor pool name
#   pools = ["redis_pool", "mc_pool"]


# # A plugin to collect stats from the Unbound DNS resolver
# [[inputs.unbound]]
#   ## Address of server to connect to, read from unbound conf default, optionally ':port'
#   ## Will lookup IP if given a hostname
#   server = "127.0.0.1:8953"
#
#   ## If running as a restricted user you can prepend sudo for additional access:
#   # use_sudo = false
#
#   ## The default location of the unbound-control binary can be overridden with:
#   # binary = "/usr/sbin/unbound-control"
#
#   ## The default timeout of 1s can be overriden with:
#   # timeout = "1s"
#
#   ## When set to true, thread metrics are tagged with the thread id.
#   ##
#   ## The default is false for backwards compatibility, and will be change to
#   ## true in a future version.  It is recommended to set to true on new
#   ## deployments.
#   thread_as_tag = false


# # A plugin to collect stats from Varnish HTTP Cache
# [[inputs.varnish]]
#   ## If running as a restricted user you can prepend sudo for additional access:
#   #use_sudo = false
#
#   ## The default location of the varnishstat binary can be overridden with:
#   binary = "/usr/bin/varnishstat"
#
#   ## By default, telegraf gather stats for 3 metric points.
#   ## Setting stats will override the defaults shown below.
#   ## Glob matching can be used, ie, stats = ["MAIN.*"]
#   ## stats may also be set to ["*"], which will collect all stats
#   stats = ["MAIN.cache_hit", "MAIN.cache_miss", "MAIN.uptime"]
#
#   ## Optional name for the varnish instance (or working directory) to query
#   ## Usually appened after -n in varnish cli
#   # instance_name = instanceName


# # Monitor wifi signal strength and quality
# [[inputs.wireless]]
#   ## Sets 'proc' directory path
#   ## If not specified, then default is /proc
#   # host_proc = "/proc"


# # Reads metrics from a SSL certificate
# [[inputs.x509_cert]]
#   ## List certificate sources
#   sources = ["/etc/ssl/certs/ssl-cert-snakeoil.pem", "tcp://example.org:443"]
#
#   ## Timeout for SSL connection
#   # timeout = "5s"
#
#   ## Optional TLS Config
#   # tls_ca = "/etc/telegraf/ca.pem"
#   # tls_cert = "/etc/telegraf/cert.pem"
#   # tls_key = "/etc/telegraf/key.pem"
#
#   ## Use TLS but skip chain & host verification
#   # insecure_skip_verify = false


# # Read metrics of ZFS from arcstats, zfetchstats, vdev_cache_stats, and pools
# [[inputs.zfs]]
#   ## ZFS kstat path. Ignored on FreeBSD
#   ## If not specified, then default is:
#   # kstatPath = "/proc/spl/kstat/zfs"
#
#   ## By default, telegraf gather all zfs stats
#   ## If not specified, then default is:
#   # kstatMetrics = ["arcstats", "zfetchstats", "vdev_cache_stats"]
#   ## For Linux, the default is:
#   # kstatMetrics = ["abdstats", "arcstats", "dnodestats", "dbufcachestats",
#   #   "dmu_tx", "fm", "vdev_mirror_stats", "zfetchstats", "zil"]
#   ## By default, don't gather zpool stats
#   # poolMetrics = false


# # Reads 'mntr' stats from one or many zookeeper servers
# [[inputs.zookeeper]]
#   ## An array of address to gather stats about. Specify an ip or hostname
#   ## with port. ie localhost:2181, 10.0.0.1:2181, etc.
#
#   ## If no servers are specified, then localhost is used as the host.
#   ## If no port is specified, 2181 is used
#   servers = [":2181"]
#
#   ## Timeout for metric collections from all servers.  Minimum timeout is "1s".
#   # timeout = "5s"
#
#   ## Optional TLS Config
#   # enable_tls = true
#   # tls_ca = "/etc/telegraf/ca.pem"
#   # tls_cert = "/etc/telegraf/cert.pem"
#   # tls_key = "/etc/telegraf/key.pem"
#   ## If false, skip chain & host verification
#   # insecure_skip_verify = true



###############################################################################
#                            SERVICE INPUT PLUGINS                            #
###############################################################################

# # AMQP consumer plugin
# [[inputs.amqp_consumer]]
#   ## Broker to consume from.
#   ##   deprecated in 1.7; use the brokers option
#   # url = "amqp://localhost:5672/influxdb"
#
#   ## Brokers to consume from.  If multiple brokers are specified a random broker
#   ## will be selected anytime a connection is established.  This can be
#   ## helpful for load balancing when not using a dedicated load balancer.
#   brokers = ["amqp://localhost:5672/influxdb"]
#
#   ## Authentication credentials for the PLAIN auth_method.
#   # username = ""
#   # password = ""
#
#   ## Exchange to declare and consume from.
#   exchange = "telegraf"
#
#   ## Exchange type; common types are "direct", "fanout", "topic", "header", "x-consistent-hash".
#   # exchange_type = "topic"
#
#   ## If true, exchange will be passively declared.
#   # exchange_passive = false
#
#   ## Exchange durability can be either "transient" or "durable".
#   # exchange_durability = "durable"
#
#   ## Additional exchange arguments.
#   # exchange_arguments = { }
#   # exchange_arguments = {"hash_propery" = "timestamp"}
#
#   ## AMQP queue name.
#   queue = "telegraf"
#
#   ## AMQP queue durability can be "transient" or "durable".
#   queue_durability = "durable"
#
#   ## Binding Key.
#   binding_key = "#"
#
#   ## Maximum number of messages server should give to the worker.
#   # prefetch_count = 50
#
#   ## Maximum messages to read from the broker that have not been written by an
#   ## output.  For best throughput set based on the number of metrics within
#   ## each message and the size of the output's metric_batch_size.
#   ##
#   ## For example, if each message from the queue contains 10 metrics and the
#   ## output metric_batch_size is 1000, setting this to 100 will ensure that a
#   ## full batch is collected and the write is triggered immediately without
#   ## waiting until the next flush_interval.
#   # max_undelivered_messages = 1000
#
#   ## Auth method. PLAIN and EXTERNAL are supported
#   ## Using EXTERNAL requires enabling the rabbitmq_auth_mechanism_ssl plugin as
#   ## described here: https://www.rabbitmq.com/plugins.html
#   # auth_method = "PLAIN"
#
#   ## Optional TLS Config
#   # tls_ca = "/etc/telegraf/ca.pem"
#   # tls_cert = "/etc/telegraf/cert.pem"
#   # tls_key = "/etc/telegraf/key.pem"
#   ## Use TLS but skip chain & host verification
#   # insecure_skip_verify = false
#
#   ## Data format to consume.
#   ## Each data format has its own unique set of configuration options, read
#   ## more about them here:
#   ## https://github.com/influxdata/telegraf/blob/master/docs/DATA_FORMATS_INPUT.md
#   data_format = "influx"


# # Read Cassandra metrics through Jolokia
# [[inputs.cassandra]]
#   ## DEPRECATED: The cassandra plugin has been deprecated.  Please use the
#   ## jolokia2 plugin instead.
#   ##
#   ## see https://github.com/influxdata/telegraf/tree/master/plugins/inputs/jolokia2
#
#   context = "/jolokia/read"
#   ## List of cassandra servers exposing jolokia read service
#   servers = ["myuser:mypassword@10.10.10.1:8778","10.10.10.2:8778",":8778"]
#   ## List of metrics collected on above servers
#   ## Each metric consists of a jmx path.
#   ## This will collect all heap memory usage metrics from the jvm and
#   ## ReadLatency metrics for all keyspaces and tables.
#   ## "type=Table" in the query works with Cassandra3.0. Older versions might
#   ## need to use "type=ColumnFamily"
#   metrics  = [
#     "/java.lang:type=Memory/HeapMemoryUsage",
#     "/org.apache.cassandra.metrics:type=Table,keyspace=*,scope=*,name=ReadLatency"
#   ]


# # Influx HTTP write listener
# [[inputs.http_listener]]
#   ## Address and port to host HTTP listener on
#   service_address = ":8186"
#
#   ## maximum duration before timing out read of the request
#   read_timeout = "10s"
#   ## maximum duration before timing out write of the response
#   write_timeout = "10s"
#
#   ## Maximum allowed http request body size in bytes.
#   ## 0 means to use the default of 524,288,000 bytes (500 mebibytes)
#   max_body_size = "500MiB"
#
#   ## Maximum line size allowed to be sent in bytes.
#   ## 0 means to use the default of 65536 bytes (64 kibibytes)
#   max_line_size = "64KiB"
#
#   ## Set one or more allowed client CA certificate file names to
#   ## enable mutually authenticated TLS connections
#   tls_allowed_cacerts = ["/etc/telegraf/clientca.pem"]
#
#   ## Add service certificate and key
#   tls_cert = "/etc/telegraf/cert.pem"
#   tls_key = "/etc/telegraf/key.pem"
#
#   ## Optional username and password to accept for HTTP basic authentication.
#   ## You probably want to make sure you have TLS configured above for this.
#   # basic_username = "foobar"
#   # basic_password = "barfoo"


# # Generic HTTP write listener
# [[inputs.http_listener_v2]]
#   ## Address and port to host HTTP listener on
#   service_address = ":8080"
#
#   ## Path to listen to.
#   # path = "/telegraf"
#
#   ## HTTP methods to accept.
#   # methods = ["POST", "PUT"]
#
#   ## maximum duration before timing out read of the request
#   # read_timeout = "10s"
#   ## maximum duration before timing out write of the response
#   # write_timeout = "10s"
#
#   ## Maximum allowed http request body size in bytes.
#   ## 0 means to use the default of 524,288,00 bytes (500 mebibytes)
#   # max_body_size = "500MB"
#
#   ## Set one or more allowed client CA certificate file names to
#   ## enable mutually authenticated TLS connections
#   # tls_allowed_cacerts = ["/etc/telegraf/clientca.pem"]
#
#   ## Add service certificate and key
#   # tls_cert = "/etc/telegraf/cert.pem"
#   # tls_key = "/etc/telegraf/key.pem"
#
#   ## Optional username and password to accept for HTTP basic authentication.
#   ## You probably want to make sure you have TLS configured above for this.
#   # basic_username = "foobar"
#   # basic_password = "barfoo"
#
#   ## Data format to consume.
#   ## Each data format has its own unique set of configuration options, read
#   ## more about them here:
#   ## https://github.com/influxdata/telegraf/blob/master/docs/DATA_FORMATS_INPUT.md
#   data_format = "influx"


# # Influx HTTP write listener
# [[inputs.influxdb_listener]]
#   ## Address and port to host HTTP listener on
#   service_address = ":8186"
#
#   ## maximum duration before timing out read of the request
#   read_timeout = "10s"
#   ## maximum duration before timing out write of the response
#   write_timeout = "10s"
#
#   ## Maximum allowed http request body size in bytes.
#   ## 0 means to use the default of 524,288,000 bytes (500 mebibytes)
#   max_body_size = "500MiB"
#
#   ## Maximum line size allowed to be sent in bytes.
#   ## 0 means to use the default of 65536 bytes (64 kibibytes)
#   max_line_size = "64KiB"
#
#   ## Set one or more allowed client CA certificate file names to
#   ## enable mutually authenticated TLS connections
#   tls_allowed_cacerts = ["/etc/telegraf/clientca.pem"]
#
#   ## Add service certificate and key
#   tls_cert = "/etc/telegraf/cert.pem"
#   tls_key = "/etc/telegraf/key.pem"
#
#   ## Optional username and password to accept for HTTP basic authentication.
#   ## You probably want to make sure you have TLS configured above for this.
#   # basic_username = "foobar"
#   # basic_password = "barfoo"


# # Read JTI OpenConfig Telemetry from listed sensors
# [[inputs.jti_openconfig_telemetry]]
#   ## List of device addresses to collect telemetry from
#   servers = ["localhost:1883"]
#
#   ## Authentication details. Username and password are must if device expects
#   ## authentication. Client ID must be unique when connecting from multiple instances
#   ## of telegraf to the same device
#   username = "user"
#   password = "pass"
#   client_id = "telegraf"
#
#   ## Frequency to get data
#   sample_frequency = "1000ms"
#
#   ## Sensors to subscribe for
#   ## A identifier for each sensor can be provided in path by separating with space
#   ## Else sensor path will be used as identifier
#   ## When identifier is used, we can provide a list of space separated sensors.
#   ## A single subscription will be created with all these sensors and data will
#   ## be saved to measurement with this identifier name
#   sensors = [
#    "/interfaces/",
#    "collection /components/ /lldp",
#   ]
#
#   ## We allow specifying sensor group level reporting rate. To do this, specify the
#   ## reporting rate in Duration at the beginning of sensor paths / collection
#   ## name. For entries without reporting rate, we use configured sample frequency
#   sensors = [
#    "1000ms customReporting /interfaces /lldp",
#    "2000ms collection /components",
#    "/interfaces",
#   ]
#
#   ## x509 Certificate to use with TLS connection. If it is not provided, an insecure
#   ## channel will be opened with server
#   ssl_cert = "/etc/telegraf/cert.pem"
#
#   ## Delay between retry attempts of failed RPC calls or streams. Defaults to 1000ms.
#   ## Failed streams/calls will not be retried if 0 is provided
#   retry_delay = "1000ms"
#
#   ## To treat all string values as tags, set this to true
#   str_as_tags = false


# # Read metrics from Kafka topic(s)
# [[inputs.kafka_consumer]]
#   ## kafka servers
#   brokers = ["localhost:9092"]
#   ## topic(s) to consume
#   topics = ["telegraf"]
#
#   ## Optional Client id
#   # client_id = "Telegraf"
#
#   ## Set the minimal supported Kafka version.  Setting this enables the use of new
#   ## Kafka features and APIs.  Of particular interest, lz4 compression
#   ## requires at least version 0.10.0.0.
#   ##   ex: version = "1.1.0"
#   # version = ""
#
#   ## Optional TLS Config
#   # tls_ca = "/etc/telegraf/ca.pem"
#   # tls_cert = "/etc/telegraf/cert.pem"
#   # tls_key = "/etc/telegraf/key.pem"
#   ## Use TLS but skip chain & host verification
#   # insecure_skip_verify = false
#
#   ## Optional SASL Config
#   # sasl_username = "kafka"
#   # sasl_password = "secret"
#
#   ## the name of the consumer group
#   consumer_group = "telegraf_metrics_consumers"
#   ## Offset (must be either "oldest" or "newest")
#   offset = "oldest"
#   ## Maximum length of a message to consume, in bytes (default 0/unlimited);
#   ## larger messages are dropped
#   max_message_len = 1000000
#
#   ## Maximum messages to read from the broker that have not been written by an
#   ## output.  For best throughput set based on the number of metrics within
#   ## each message and the size of the output's metric_batch_size.
#   ##
#   ## For example, if each message from the queue contains 10 metrics and the
#   ## output metric_batch_size is 1000, setting this to 100 will ensure that a
#   ## full batch is collected and the write is triggered immediately without
#   ## waiting until the next flush_interval.
#   # max_undelivered_messages = 1000
#
#   ## Data format to consume.
#   ## Each data format has its own unique set of configuration options, read
#   ## more about them here:
#   ## https://github.com/influxdata/telegraf/blob/master/docs/DATA_FORMATS_INPUT.md
#   data_format = "influx"


# # Read metrics from Kafka topic(s)
# [[inputs.kafka_consumer_legacy]]
#   ## topic(s) to consume
#   topics = ["telegraf"]
#   ## an array of Zookeeper connection strings
#   zookeeper_peers = ["localhost:2181"]
#   ## Zookeeper Chroot
#   zookeeper_chroot = ""
#   ## the name of the consumer group
#   consumer_group = "telegraf_metrics_consumers"
#   ## Offset (must be either "oldest" or "newest")
#   offset = "oldest"
#
#   ## Data format to consume.
#   ## Each data format has its own unique set of configuration options, read
#   ## more about them here:
#   ## https://github.com/influxdata/telegraf/blob/master/docs/DATA_FORMATS_INPUT.md
#   data_format = "influx"
#
#   ## Maximum length of a message to consume, in bytes (default 0/unlimited);
#   ## larger messages are dropped
#   max_message_len = 65536


# # Stream and parse log file(s).
# [[inputs.logparser]]
#   ## Log files to parse.
#   ## These accept standard unix glob matching rules, but with the addition of
#   ## ** as a "super asterisk". ie:
#   ##   /var/log/**.log     -> recursively find all .log files in /var/log
#   ##   /var/log/*/*.log    -> find all .log files with a parent dir in /var/log
#   ##   /var/log/apache.log -> only tail the apache log file
#   files = ["/var/log/apache/access.log"]
#
#   ## Read files that currently exist from the beginning. Files that are created
#   ## while telegraf is running (and that match the "files" globs) will always
#   ## be read from the beginning.
#   from_beginning = false
#
#   ## Method used to watch for file updates.  Can be either "inotify" or "poll".
#   # watch_method = "inotify"
#
#   ## Parse logstash-style "grok" patterns:
#   [inputs.logparser.grok]
#     ## This is a list of patterns to check the given log file(s) for.
#     ## Note that adding patterns here increases processing time. The most
#     ## efficient configuration is to have one pattern per logparser.
#     ## Other common built-in patterns are:
#     ##   %{COMMON_LOG_FORMAT}   (plain apache & nginx access logs)
#     ##   %{COMBINED_LOG_FORMAT} (access logs + referrer & agent)
#     patterns = ["%{COMBINED_LOG_FORMAT}"]
#
#     ## Name of the outputted measurement name.
#     measurement = "apache_access_log"
#
#     ## Full path(s) to custom pattern files.
#     custom_pattern_files = []
#
#     ## Custom patterns can also be defined here. Put one pattern per line.
#     custom_patterns = '''
#     '''
#
#     ## Timezone allows you to provide an override for timestamps that
#     ## don't already include an offset
#     ## e.g. 04/06/2016 12:41:45 data one two 5.43µs
#     ##
#     ## Default: "" which renders UTC
#     ## Options are as follows:
#     ##   1. Local             -- interpret based on machine localtime
#     ##   2. "Canada/Eastern"  -- Unix TZ values like those found in https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
#     ##   3. UTC               -- or blank/unspecified, will return timestamp in UTC
#     # timezone = "Canada/Eastern"


# # Read metrics from MQTT topic(s)
# [[inputs.mqtt_consumer]]
#   ## MQTT broker URLs to be used. The format should be scheme://host:port,
#   ## schema can be tcp, ssl, or ws.
#   servers = ["tcp://localhost:1883"]
#
#   ## QoS policy for messages
#   ##   0 = at most once
#   ##   1 = at least once
#   ##   2 = exactly once
#   ##
#   ## When using a QoS of 1 or 2, you should enable persistent_session to allow
#   ## resuming unacknowledged messages.
#   qos = 0
#
#   ## Connection timeout for initial connection in seconds
#   connection_timeout = "30s"
#
#   ## Maximum messages to read from the broker that have not been written by an
#   ## output.  For best throughput set based on the number of metrics within
#   ## each message and the size of the output's metric_batch_size.
#   ##
#   ## For example, if each message from the queue contains 10 metrics and the
#   ## output metric_batch_size is 1000, setting this to 100 will ensure that a
#   ## full batch is collected and the write is triggered immediately without
#   ## waiting until the next flush_interval.
#   # max_undelivered_messages = 1000
#
#   ## Topics to subscribe to
#   topics = [
#     "telegraf/host01/cpu",
#     "telegraf/+/mem",
#     "sensors/#",
#   ]
#
#   # if true, messages that can't be delivered while the subscriber is offline
#   # will be delivered when it comes back (such as on service restart).
#   # NOTE: if true, client_id MUST be set
#   persistent_session = false
#   # If empty, a random client ID will be generated.
#   client_id = ""
#
#   ## username and password to connect MQTT server.
#   # username = "telegraf"
#   # password = "metricsmetricsmetricsmetrics"
#
#   ## Optional TLS Config
#   # tls_ca = "/etc/telegraf/ca.pem"
#   # tls_cert = "/etc/telegraf/cert.pem"
#   # tls_key = "/etc/telegraf/key.pem"
#   ## Use TLS but skip chain & host verification
#   # insecure_skip_verify = false
#
#   ## Data format to consume.
#   ## Each data format has its own unique set of configuration options, read
#   ## more about them here:
#   ## https://github.com/influxdata/telegraf/blob/master/docs/DATA_FORMATS_INPUT.md
#   data_format = "influx"


# # Read metrics from NATS subject(s)
# [[inputs.nats_consumer]]
#   ## urls of NATS servers
#   servers = ["nats://localhost:4222"]
#   ## Use Transport Layer Security
#   secure = false
#   ## subject(s) to consume
#   subjects = ["telegraf"]
#   ## name a queue group
#   queue_group = "telegraf_consumers"
#
#   ## Sets the limits for pending msgs and bytes for each subscription
#   ## These shouldn't need to be adjusted except in very high throughput scenarios
#   # pending_message_limit = 65536
#   # pending_bytes_limit = 67108864
#
#   ## Maximum messages to read from the broker that have not been written by an
#   ## output.  For best throughput set based on the number of metrics within
#   ## each message and the size of the output's metric_batch_size.
#   ##
#   ## For example, if each message from the queue contains 10 metrics and the
#   ## output metric_batch_size is 1000, setting this to 100 will ensure that a
#   ## full batch is collected and the write is triggered immediately without
#   ## waiting until the next flush_interval.
#   # max_undelivered_messages = 1000
#
#   ## Data format to consume.
#   ## Each data format has its own unique set of configuration options, read
#   ## more about them here:
#   ## https://github.com/influxdata/telegraf/blob/master/docs/DATA_FORMATS_INPUT.md
#   data_format = "influx"


# # Read NSQ topic for metrics.
# [[inputs.nsq_consumer]]
#   ## Server option still works but is deprecated, we just prepend it to the nsqd array.
#   # server = "localhost:4150"
#   ## An array representing the NSQD TCP HTTP Endpoints
#   nsqd = ["localhost:4150"]
#   ## An array representing the NSQLookupd HTTP Endpoints
#   nsqlookupd = ["localhost:4161"]
#   topic = "telegraf"
#   channel = "consumer"
#   max_in_flight = 100
#
#   ## Maximum messages to read from the broker that have not been written by an
#   ## output.  For best throughput set based on the number of metrics within
#   ## each message and the size of the output's metric_batch_size.
#   ##
#   ## For example, if each message from the queue contains 10 metrics and the
#   ## output metric_batch_size is 1000, setting this to 100 will ensure that a
#   ## full batch is collected and the write is triggered immediately without
#   ## waiting until the next flush_interval.
#   # max_undelivered_messages = 1000
#
#   ## Data format to consume.
#   ## Each data format has its own unique set of configuration options, read
#   ## more about them here:
#   ## https://github.com/influxdata/telegraf/blob/master/docs/DATA_FORMATS_INPUT.md
#   data_format = "influx"


# # Read metrics from one or many pgbouncer servers
# [[inputs.pgbouncer]]
#   ## specify address via a url matching:
#   ##   postgres://[pqgotest[:password]]@localhost[/dbname]\
#   ##       ?sslmode=[disable|verify-ca|verify-full]
#   ## or a simple string:
#   ##   host=localhost user=pqotest password=... sslmode=... dbname=app_production
#   ##
#   ## All connection parameters are optional.
#   ##
#   address = "host=localhost user=pgbouncer sslmode=disable"


# # Read metrics from one or many postgresql servers
# [[inputs.postgresql]]
#   ## specify address via a url matching:
#   ##   postgres://[pqgotest[:password]]@localhost[/dbname]\
#   ##       ?sslmode=[disable|verify-ca|verify-full]
#   ## or a simple string:
#   ##   host=localhost user=pqotest password=... sslmode=... dbname=app_production
#   ##
#   ## All connection parameters are optional.
#   ##
#   ## Without the dbname parameter, the driver will default to a database
#   ## with the same name as the user. This dbname is just for instantiating a
#   ## connection with the server and doesn't restrict the databases we are trying
#   ## to grab metrics for.
#   ##
#   address = "host=localhost user=postgres sslmode=disable"
#   ## A custom name for the database that will be used as the "server" tag in the
#   ## measurement output. If not specified, a default one generated from
#   ## the connection address is used.
#   # outputaddress = "db01"
#
#   ## connection configuration.
#   ## maxlifetime - specify the maximum lifetime of a connection.
#   ## default is forever (0s)
#   max_lifetime = "0s"
#
#   ## A  list of databases to explicitly ignore.  If not specified, metrics for all
#   ## databases are gathered.  Do NOT use with the 'databases' option.
#   # ignored_databases = ["postgres", "template0", "template1"]
#
#   ## A list of databases to pull metrics about. If not specified, metrics for all
#   ## databases are gathered.  Do NOT use with the 'ignored_databases' option.
#   # databases = ["app_production", "testing"]


# # Read metrics from one or many postgresql servers
# [[inputs.postgresql_extensible]]
#   ## specify address via a url matching:
#   ##   postgres://[pqgotest[:password]]@localhost[/dbname]\
#   ##       ?sslmode=[disable|verify-ca|verify-full]
#   ## or a simple string:
#   ##   host=localhost user=pqotest password=... sslmode=... dbname=app_production
#   #
#   ## All connection parameters are optional.  #
#   ## Without the dbname parameter, the driver will default to a database
#   ## with the same name as the user. This dbname is just for instantiating a
#   ## connection with the server and doesn't restrict the databases we are trying
#   ## to grab metrics for.
#   #
#   address = "host=localhost user=postgres sslmode=disable"
#
#   ## connection configuration.
#   ## maxlifetime - specify the maximum lifetime of a connection.
#   ## default is forever (0s)
#   max_lifetime = "0s"
#
#   ## A list of databases to pull metrics about. If not specified, metrics for all
#   ## databases are gathered.
#   ## databases = ["app_production", "testing"]
#   #
#   ## A custom name for the database that will be used as the "server" tag in the
#   ## measurement output. If not specified, a default one generated from
#   ## the connection address is used.
#   # outputaddress = "db01"
#   #
#   ## Define the toml config where the sql queries are stored
#   ## New queries can be added, if the withdbname is set to true and there is no
#   ## databases defined in the 'databases field', the sql query is ended by a
#   ## 'is not null' in order to make the query succeed.
#   ## Example :
#   ## The sqlquery : "SELECT * FROM pg_stat_database where datname" become
#   ## "SELECT * FROM pg_stat_database where datname IN ('postgres', 'pgbench')"
#   ## because the databases variable was set to ['postgres', 'pgbench' ] and the
#   ## withdbname was true. Be careful that if the withdbname is set to false you
#   ## don't have to define the where clause (aka with the dbname) the tagvalue
#   ## field is used to define custom tags (separated by commas)
#   ## The optional "measurement" value can be used to override the default
#   ## output measurement name ("postgresql").
#   #
#   ## Structure :
#   ## [[inputs.postgresql_extensible.query]]
#   ##   sqlquery string
#   ##   version string
#   ##   withdbname boolean
#   ##   tagvalue string (comma separated)
#   ##   measurement string
#   [[inputs.postgresql_extensible.query]]
#     sqlquery="SELECT * FROM pg_stat_database"
#     version=901
#     withdbname=false
#     tagvalue=""
#     measurement=""
#   [[inputs.postgresql_extensible.query]]
#     sqlquery="SELECT * FROM pg_stat_bgwriter"
#     version=901
#     withdbname=false
#     tagvalue="postgresql.stats"


# # Read metrics from one or many prometheus clients
# [[inputs.prometheus]]
#   ## An array of urls to scrape metrics from.
#   urls = ["http://localhost:9100/metrics"]
#
#   ## An array of Kubernetes services to scrape metrics from.
#   # kubernetes_services = ["http://my-service-dns.my-namespace:9100/metrics"]
#
#   ## Kubernetes config file to create client from.
#   # kube_config = "/path/to/kubernetes.config"
#
#   ## Scrape Kubernetes pods for the following prometheus annotations:
#   ## - prometheus.io/scrape: Enable scraping for this pod
#   ## - prometheus.io/scheme: If the metrics endpoint is secured then you will need to
#   ##     set this to 'https' & most likely set the tls config.
#   ## - prometheus.io/path: If the metrics path is not /metrics, define it with this annotation.
#   ## - prometheus.io/port: If port is not 9102 use this annotation
#   # monitor_kubernetes_pods = true
#
#   ## Use bearer token for authorization
#   # bearer_token = /path/to/bearer/token
#
#   ## Specify timeout duration for slower prometheus clients (default is 3s)
#   # response_timeout = "3s"
#
#   ## Optional TLS Config
#   # tls_ca = /path/to/cafile
#   # tls_cert = /path/to/certfile
#   # tls_key = /path/to/keyfile
#   ## Use TLS but skip chain & host verification
#   # insecure_skip_verify = false


# # Generic socket listener capable of handling multiple socket types.
# [[inputs.socket_listener]]
#   ## URL to listen on
#   # service_address = "tcp://:8094"
#   # service_address = "tcp://127.0.0.1:http"
#   # service_address = "tcp4://:8094"
#   # service_address = "tcp6://:8094"
#   # service_address = "tcp6://[2001:db8::1]:8094"
#   # service_address = "udp://:8094"
#   # service_address = "udp4://:8094"
#   # service_address = "udp6://:8094"
#   # service_address = "unix:///tmp/telegraf.sock"
#   # service_address = "unixgram:///tmp/telegraf.sock"
#
#   ## Maximum number of concurrent connections.
#   ## Only applies to stream sockets (e.g. TCP).
#   ## 0 (default) is unlimited.
#   # max_connections = 1024
#
#   ## Read timeout.
#   ## Only applies to stream sockets (e.g. TCP).
#   ## 0 (default) is unlimited.
#   # read_timeout = "30s"
#
#   ## Optional TLS configuration.
#   ## Only applies to stream sockets (e.g. TCP).
#   # tls_cert = "/etc/telegraf/cert.pem"
#   # tls_key  = "/etc/telegraf/key.pem"
#   ## Enables client authentication if set.
#   # tls_allowed_cacerts = ["/etc/telegraf/clientca.pem"]
#
#   ## Maximum socket buffer size (in bytes when no unit specified).
#   ## For stream sockets, once the buffer fills up, the sender will start backing up.
#   ## For datagram sockets, once the buffer fills up, metrics will start dropping.
#   ## Defaults to the OS default.
#   # read_buffer_size = "64KiB"
#
#   ## Period between keep alive probes.
#   ## Only applies to TCP sockets.
#   ## 0 disables keep alive probes.
#   ## Defaults to the OS configuration.
#   # keep_alive_period = "5m"
#
#   ## Data format to consume.
#   ## Each data format has its own unique set of configuration options, read
#   ## more about them here:
#   ## https://github.com/influxdata/telegraf/blob/master/docs/DATA_FORMATS_INPUT.md
#   # data_format = "influx"


# # Statsd UDP/TCP Server
# [[inputs.statsd]]
#   ## Protocol, must be "tcp", "udp", "udp4" or "udp6" (default=udp)
#   protocol = "udp"
#
#   ## MaxTCPConnection - applicable when protocol is set to tcp (default=250)
#   max_tcp_connections = 250
#
#   ## Enable TCP keep alive probes (default=false)
#   tcp_keep_alive = false
#
#   ## Specifies the keep-alive period for an active network connection.
#   ## Only applies to TCP sockets and will be ignored if tcp_keep_alive is false.
#   ## Defaults to the OS configuration.
#   # tcp_keep_alive_period = "2h"
#
#   ## Address and port to host UDP listener on
#   service_address = ":8125"
#
#   ## The following configuration options control when telegraf clears it's cache
#   ## of previous values. If set to false, then telegraf will only clear it's
#   ## cache when the daemon is restarted.
#   ## Reset gauges every interval (default=true)
#   delete_gauges = true
#   ## Reset counters every interval (default=true)
#   delete_counters = true
#   ## Reset sets every interval (default=true)
#   delete_sets = true
#   ## Reset timings & histograms every interval (default=true)
#   delete_timings = true
#
#   ## Percentiles to calculate for timing & histogram stats
#   percentiles = [90]
#
#   ## separator to use between elements of a statsd metric
#   metric_separator = "_"
#
#   ## Parses tags in the datadog statsd format
#   ## http://docs.datadoghq.com/guides/dogstatsd/
#   parse_data_dog_tags = false
#
#   ## Statsd data translation templates, more info can be read here:
#   ## https://github.com/influxdata/telegraf/blob/master/docs/TEMPLATE_PATTERN.md
#   # templates = [
#   #     "cpu.* measurement*"
#   # ]
#
#   ## Number of UDP messages allowed to queue up, once filled,
#   ## the statsd server will start dropping packets
#   allowed_pending_messages = 10000
#
#   ## Number of timing/histogram values to track per-measurement in the
#   ## calculation of percentiles. Raising this limit increases the accuracy
#   ## of percentiles but also increases the memory usage and cpu time.
#   percentile_limit = 1000


# # Accepts syslog messages per RFC5425
# [[inputs.syslog]]
#   ## Specify an ip or hostname with port - eg., tcp://localhost:6514, tcp://10.0.0.1:6514
#   ## Protocol, address and port to host the syslog receiver.
#   ## If no host is specified, then localhost is used.
#   ## If no port is specified, 6514 is used (RFC5425#section-4.1).
#   server = "tcp://:6514"
#
#   ## TLS Config
#   # tls_allowed_cacerts = ["/etc/telegraf/ca.pem"]
#   # tls_cert = "/etc/telegraf/cert.pem"
#   # tls_key = "/etc/telegraf/key.pem"
#
#   ## Period between keep alive probes.
#   ## 0 disables keep alive probes.
#   ## Defaults to the OS configuration.
#   ## Only applies to stream sockets (e.g. TCP).
#   # keep_alive_period = "5m"
#
#   ## Maximum number of concurrent connections (default = 0).
#   ## 0 means unlimited.
#   ## Only applies to stream sockets (e.g. TCP).
#   # max_connections = 1024
#
#   ## Read timeout is the maximum time allowed for reading a single message (default = 5s).
#   ## 0 means unlimited.
#   # read_timeout = "5s"
#
#   ## Whether to parse in best effort mode or not (default = false).
#   ## By default best effort parsing is off.
#   # best_effort = false
#
#   ## Character to prepend to SD-PARAMs (default = "_").
#   ## A syslog message can contain multiple parameters and multiple identifiers within structured data section.
#   ## Eg., [id1 name1="val1" name2="val2"][id2 name1="val1" nameA="valA"]
#   ## For each combination a field is created.
#   ## Its name is created concatenating identifier, sdparam_separator, and parameter name.
#   # sdparam_separator = "_"


# # Stream a log file, like the tail -f command
# [[inputs.tail]]
#   ## files to tail.
#   ## These accept standard unix glob matching rules, but with the addition of
#   ## ** as a "super asterisk". ie:
#   ##   "/var/log/**.log"  -> recursively find all .log files in /var/log
#   ##   "/var/log/*/*.log" -> find all .log files with a parent dir in /var/log
#   ##   "/var/log/apache.log" -> just tail the apache log file
#   ##
#   ## See https://github.com/gobwas/glob for more examples
#   ##
#   files = ["/var/mymetrics.out"]
#   ## Read file from beginning.
#   from_beginning = false
#   ## Whether file is a named pipe
#   pipe = false
#
#   ## Method used to watch for file updates.  Can be either "inotify" or "poll".
#   # watch_method = "inotify"
#
#   ## Data format to consume.
#   ## Each data format has its own unique set of configuration options, read
#   ## more about them here:
#   ## https://github.com/influxdata/telegraf/blob/master/docs/DATA_FORMATS_INPUT.md
#   data_format = "influx"


# # Generic TCP listener
# [[inputs.tcp_listener]]
#   # DEPRECATED: the TCP listener plugin has been deprecated in favor of the
#   # socket_listener plugin
#   # see https://github.com/influxdata/telegraf/tree/master/plugins/inputs/socket_listener


# # Generic UDP listener
# [[inputs.udp_listener]]
#   # DEPRECATED: the TCP listener plugin has been deprecated in favor of the
#   # socket_listener plugin
#   # see https://github.com/influxdata/telegraf/tree/master/plugins/inputs/socket_listener


# # Read metrics from VMware vCenter
# [[inputs.vsphere]]
#   ## List of vCenter URLs to be monitored. These three lines must be uncommented
#   ## and edited for the plugin to work.
#   vcenters = [ "https://vcenter.local/sdk" ]
#   username = "user@corp.local"
#   password = "secret"
#
#   ## VMs
#   ## Typical VM metrics (if omitted or empty, all metrics are collected)
#   vm_metric_include = [
#     "cpu.demand.average",
#     "cpu.idle.summation",
#     "cpu.latency.average",
#     "cpu.readiness.average",
#     "cpu.ready.summation",
#     "cpu.run.summation",
#     "cpu.usagemhz.average",
#     "cpu.used.summation",
#     "cpu.wait.summation",
#     "mem.active.average",
#     "mem.granted.average",
#     "mem.latency.average",
#     "mem.swapin.average",
#     "mem.swapinRate.average",
#     "mem.swapout.average",
#     "mem.swapoutRate.average",
#     "mem.usage.average",
#     "mem.vmmemctl.average",
#     "net.bytesRx.average",
#     "net.bytesTx.average",
#     "net.droppedRx.summation",
#     "net.droppedTx.summation",
#     "net.usage.average",
#     "power.power.average",
#     "virtualDisk.numberReadAveraged.average",
#     "virtualDisk.numberWriteAveraged.average",
#     "virtualDisk.read.average",
#     "virtualDisk.readOIO.latest",
#     "virtualDisk.throughput.usage.average",
#     "virtualDisk.totalReadLatency.average",
#     "virtualDisk.totalWriteLatency.average",
#     "virtualDisk.write.average",
#     "virtualDisk.writeOIO.latest",
#     "sys.uptime.latest",
#   ]
#   # vm_metric_exclude = [] ## Nothing is excluded by default
#   # vm_instances = true ## true by default
#
#   ## Hosts
#   ## Typical host metrics (if omitted or empty, all metrics are collected)
#   host_metric_include = [
#     "cpu.coreUtilization.average",
#     "cpu.costop.summation",
#     "cpu.demand.average",
#     "cpu.idle.summation",
#     "cpu.latency.average",
#     "cpu.readiness.average",
#     "cpu.ready.summation",
#     "cpu.swapwait.summation",
#     "cpu.usage.average",
#     "cpu.usagemhz.average",
#     "cpu.used.summation",
#     "cpu.utilization.average",
#     "cpu.wait.summation",
#     "disk.deviceReadLatency.average",
#     "disk.deviceWriteLatency.average",
#     "disk.kernelReadLatency.average",
#     "disk.kernelWriteLatency.average",
#     "disk.numberReadAveraged.average",
#     "disk.numberWriteAveraged.average",
#     "disk.read.average",
#     "disk.totalReadLatency.average",
#     "disk.totalWriteLatency.average",
#     "disk.write.average",
#     "mem.active.average",
#     "mem.latency.average",
#     "mem.state.latest",
#     "mem.swapin.average",
#     "mem.swapinRate.average",
#     "mem.swapout.average",
#     "mem.swapoutRate.average",
#     "mem.totalCapacity.average",
#     "mem.usage.average",
#     "mem.vmmemctl.average",
#     "net.bytesRx.average",
#     "net.bytesTx.average",
#     "net.droppedRx.summation",
#     "net.droppedTx.summation",
#     "net.errorsRx.summation",
#     "net.errorsTx.summation",
#     "net.usage.average",
#     "power.power.average",
#     "storageAdapter.numberReadAveraged.average",
#     "storageAdapter.numberWriteAveraged.average",
#     "storageAdapter.read.average",
#     "storageAdapter.write.average",
#     "sys.uptime.latest",
#   ]
#   # host_metric_exclude = [] ## Nothing excluded by default
#   # host_instances = true ## true by default
#
#   ## Clusters
#   # cluster_metric_include = [] ## if omitted or empty, all metrics are collected
#   # cluster_metric_exclude = [] ## Nothing excluded by default
#   # cluster_instances = true ## true by default
#
#   ## Datastores
#   # datastore_metric_include = [] ## if omitted or empty, all metrics are collected
#   # datastore_metric_exclude = [] ## Nothing excluded by default
#   # datastore_instances = false ## false by default for Datastores only
#
#   ## Datacenters
#   datacenter_metric_include = [] ## if omitted or empty, all metrics are collected
#   datacenter_metric_exclude = [ "*" ] ## Datacenters are not collected by default.
#   # datacenter_instances = false ## false by default for Datastores only
#
#   ## Plugin Settings
#   ## separator character to use for measurement and field names (default: "_")
#   # separator = "_"
#
#   ## number of objects to retreive per query for realtime resources (vms and hosts)
#   ## set to 64 for vCenter 5.5 and 6.0 (default: 256)
#   # max_query_objects = 256
#
#   ## number of metrics to retreive per query for non-realtime resources (clusters and datastores)
#   ## set to 64 for vCenter 5.5 and 6.0 (default: 256)
#   # max_query_metrics = 256
#
#   ## number of go routines to use for collection and discovery of objects and metrics
#   # collect_concurrency = 1
#   # discover_concurrency = 1
#
#   ## whether or not to force discovery of new objects on initial gather call before collecting metrics
#   ## when true for large environments this may cause errors for time elapsed while collecting metrics
#   ## when false (default) the first collection cycle may result in no or limited metrics while objects are discovered
#   # force_discover_on_init = false
#
#   ## the interval before (re)discovering objects subject to metrics collection (default: 300s)
#   # object_discovery_interval = "300s"
#
#   ## timeout applies to any of the api request made to vcenter
#   # timeout = "20s"
#
#   ## Optional SSL Config
#   # ssl_ca = "/path/to/cafile"
#   # ssl_cert = "/path/to/certfile"
#   # ssl_key = "/path/to/keyfile"
#   ## Use SSL but skip chain & host verification
#   # insecure_skip_verify = false


# # A Webhooks Event collector
# [[inputs.webhooks]]
#   ## Address and port to host Webhook listener on
#   service_address = ":1619"
#
#   [inputs.webhooks.filestack]
#     path = "/filestack"
#
#   [inputs.webhooks.github]
#     path = "/github"
#     # secret = ""
#
#   [inputs.webhooks.mandrill]
#     path = "/mandrill"
#
#   [inputs.webhooks.rollbar]
#     path = "/rollbar"
#
#   [inputs.webhooks.papertrail]
#     path = "/papertrail"
#
#   [inputs.webhooks.particle]
#     path = "/particle"


# # This plugin implements the Zipkin http server to gather trace and timing data needed to troubleshoot latency problems in microservice architectures.
# [[inputs.zipkin]]
#   # path = "/api/v1/spans" # URL path for span data
#   # port = 9411            # Port on which Telegraf listens

