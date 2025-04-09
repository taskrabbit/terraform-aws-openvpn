#cloud-config
runcmd:
  # Fetch IMDSv2 token
  - |
    TOKEN=$(curl -H "X-aws-ec2-metadata-token-ttl-seconds: 60" -X PUT "http://169.254.169.254/latest/api/token")
    echo "IMDSv2 token fetched: $TOKEN"

  # Use the token to make a metadata request
  - |
    INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s "http://169.254.169.254/latest/meta-data/instance-id")
    echo "Instance ID: $INSTANCE_ID"
  - echo "OPENVPN_CERT_SOURCE=s3://${replace(s3_bucket,"/(/)+$/","")}/${replace(s3_bucket_prefix,"/^(/)+|(/)+$/","")}" > /etc/openvpn/get-openvpn-certs.env
  - if [ -n "${vpc_dns_ip}" ]; then echo "push \"dhcp-option DNS ${vpc_dns_ip}\"" >> /etc/openvpn/server.conf;fi
  - echo 'crl-verify /etc/openvpn/keys/crl.pem' >> /etc/openvpn/server.conf
  - echo "push \"route $(ip route get 8.8.8.8| grep src| sed 's/.*src \(.*\)$/\1/g') 255.255.255.255 net_gateway\"" >> /etc/openvpn/server.conf
  - echo "push \"route ${cidrhost(element(split(",",route_cidrs),1), 0)}  ${cidrnetmask(element(split(",",route_cidrs),1))}\"" >> /etc/openvpn/server.conf
  - echo "push \"route ${cidrhost(element(split(",",route_cidrs),2), 0)}  ${cidrnetmask(element(split(",",route_cidrs),2))}\"" >> /etc/openvpn/server.conf
  - echo "push \"route ${cidrhost(element(split(",",route_cidrs),3), 0)}  ${cidrnetmask(element(split(",",route_cidrs),3))}\"" >> /etc/openvpn/server.conf
  - echo "push \"route ${cidrhost(element(split(",",route_cidrs),4), 0)}  ${cidrnetmask(element(split(",",route_cidrs),4))}\"" >> /etc/openvpn/server.conf
  - for route in `echo ${additional_routes} | tr ',' ' '`; do echo "push \"route $${route}  255.255.255.255\"" >> /etc/openvpn/server.conf;done
  - sed -i 's/\(ExecStartPost=.*chmod.*$\)/ExecStartPost=\/bin\/chown -R nobody:nogroup \/etc\/openvpn\n\1\n/g' /etc/systemd/system/get-openvpn-certs.service
  - systemctl daemon-reload
  - systemctl start get-openvpn-certs
  - systemctl restart openvpn@server
  - systemctl restart iptables
  - if [ ${assign_eip} = 'true' ]; then for eip in `aws ec2 describe-tags --region=${region} --filters  "Name=resource-type,Values=elastic-ip" "Name=value,Values=${stack_item_label}" | jq -r '.Tags[].ResourceId'`; do if [ `aws ec2 describe-addresses --allocation-id $${eip} --region=${region} | jq -r '.Addresses[].InstanceId'` = 'null' ]; then echo "$${eip} is available, assigning it to current instance";aws ec2 associate-address --instance-id "$${INSTANCE_ID}" --allocation-id $${eip} --region=${region};else echo "$${eip} is taken";fi; done;fi

output : { all : '| tee -a /var/log/cloud-init-output.log' }
