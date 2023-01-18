## AWS OpenSearch Operator Guide

Amazon OpenSearch is a managed service that allows you to set up, manage, and scale a search engine for your website or application. It is built on top of Apache Lucene and provides a simple and easy-to-use interface for adding search functionality to your application.

_This bundle does not support Elasticsearch._ If you need Elasticsearch support you can request it [here](https://roadmap.massdriver.cloud/) or [create your own](https://docs.massdriver.cloud/bundles).

## Design Decisions

* Conditionally creates a service-linked role for OpenSearch. The role is retained on decommission since it is a global resource and may be in use by other OpenSearch clusters.
* Node-to-node encryption is enabled.
* Custom KMS keys are created and retained after decommissioning.
* Encryption at rest is enabled.
* HTTPS is enforced w/ TLS 1.2.
* Require a VPC deployment.
* Creates a logwatch group for each log type, KMS encrypted.
* Advanced security is enabled.

### Caveats

* Cold storage, Warm Nodes, and Cognito aren't supported at this time. Feel free to open an issue and we'll prioritize adding support.

## References

* [OpenSearch Home Page](https://opensearch.org/)
* [Developer Guide](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/what-is.html)
* [Instance types](https://instances.vantage.sh/opensearch/)

<!-- do we need these add'l links? -->

* [Monitoring OpenSearch cluster metrics with Amazon CloudWatch](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/managedomains-cloudwatchmetrics.html)
* [Operational best practices for Amazon OpenSearch Service](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/bp.html)
* [Dedicated master nodes in Amazon OpenSearch Service](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/managedomains-dedicatedmasternodes.html)
* [UltraWarm storage for Amazon OpenSearch Service](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/ultrawarm.html)
* [Fine-grained access control in Amazon OpenSearch Service](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/fgac.html)
* [Security in Amazon OpenSearch Service](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/security.html)
* [Launching your Amazon OpenSearch Service domains within a VPC](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/vpc.html)
* [Auto-Tune for Amazon OpenSearch Service](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/auto-tune.html)
* [Sizing Amazon OpenSearch Service domains](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/sizing-domains.html)
