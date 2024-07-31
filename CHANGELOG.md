## Unreleased

* Bring in covalence to help with bootstrapping/testing. Consider some kitchen/localstack testing.
* PoC docker-openvpn-server modules

## 2.0.3

#### IMPROVEMENTS:
- Update OpenVPN cluster with launch template.

## 2.0.2

#### IMPROVEMENTS:
- Update root volume type to gp3.

## 2.0.1

#### IMPROVEMENTS:
- Add encryption to root block device.

## 2.0.0

#### IMPROVEMENTS:
- Add support for additional tags.

## 1.0.0

#### IMPROVEMENTS:

Rollup fixes from whistle/terraform-aws-openvpn 0.0.9 - 0.2.5
- Update server.conf with VPC DNS IP address
- Feature: Automatically push instance's subnet route into `server.conf`
- export `zone_id`, `dns_name` from aws_elb
- Fix the 4 subnet fixed mapping
- Fill in some examples
- Add additional configuration options to Openvpn (#15)
  * Add eip and extra route capability
  * Update formatting
  * Fix the tag filter
- OpenVPN CertGen RoleID Output (DEVOPS-1692)
- OpenVPN RoleID Output (DEVOPS-1613)
- Configure DNS entry in server.conf
- Pin template provider version
- Adding crl-verify to server.conf
- Change permissions temporarily in user_data to avoid AMI change


## 0.0.11

#### IMPROVEMENTS:
- Terraform 0.8.x compatibility updates.

## 0.0.10

#### IMPROVEMENTS:
- Terraform 0.8.x compatibility updates.

## 0.0.9

#### IMPROVEMENTS:
- Added AMIs in Oregon (us-west-2)

## 0.0.8

#### IMPROVEMENTS:
- [#6]: (certs) - Simplify logic when specifying a custom ami.
- [#7]: (generate-certs) - Terraform 0.7.x compatibility updates.
- [#7]: (certs) - Terraform 0.7.x compatibility updates.

## 0.0.7

#### BUG FIXES:
- Resolved regression in certificate generator user data template.

## 0.0.6

#### BREAKING CHANGES:
- Updates in resource naming will cause churn for existing resources.
- Updated certificate generator to require VPC deployment

#### IMPROVEMENTS:
- Standardization with other Unif.io OSS terraform modules
- Documentation improvements
- Updated security group scheme for OpenVPN server
- Added pre-built AMI lookup to the server module

## 0.0.5

#### FEATURES:
- Initial release of `generate-certs` module

## 0.0.4

#### IMPROVEMENTS:
- Standardization with other Unif.io OSS terraform modules
- CI Builder
- Small tweaks:
  - IAM roles are now `<stack_item_label>-<region>` instead of `<region>-<stack_item_label>`
  - Removed unused vars for user data.
  - ELB healthcheck on nodes.
  - lifecycle `create_before_destroy` fixes to deal with dependency issues on build.
  - somewhat breaking change: in_vpc now is `1`(true) instead of `0`(false)

## 0.0.3

#### IMPROVEMENTS:
- Fix: tag.application for elb reverted to using short name instead of full application name due to naming restrictions

## 0.0.2

#### IMPROVEMENTS:
- Fix: use updated `awscli` client from pip instead of apt

## 0.0.1

#### FEATURES:
- Basic functioning openvpn server working off us-east-1
