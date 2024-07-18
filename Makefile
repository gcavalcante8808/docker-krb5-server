SHELL = /bin/bash
.SHELLFLAGS = -euo pipefail -c


run-tests-on-docker:
	docker compose -f docker-compose.yml -f docker-compose.tests.yml up --build --exit-code-from tests

test: setup
	pytest

.PHONY: setup
setup: /etc/krb5.conf python-dependencies

.ONESHELL: /etc/krb5.conf
/etc/krb5.conf:
	cat <<- EOF > /etc/krb5.conf
		[libdefaults]
		dns_lookup_realm = false
		ticket_lifetime = 24h
		renew_lifetime = 7d
		forwardable = true
		rdns = false
		default_realm = $${KRB5_REALM}
		[realms]
		$${KRB5_REALM} = {
			kdc = $${KRB5_KDC}
			admin_server = $${KRB5_ADMINSERVER}
		}
	EOF

python-dependencies:
	pip install --no-cache-dir -r requirements.txt
