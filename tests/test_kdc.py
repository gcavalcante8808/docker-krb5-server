import os

import kerberos
import pytest


def test_admin_login_succeeds_when_default_password_is_provided():
    krb5_password = os.getenv('KRB5_PASS')

    kerberos.checkPassword('admin/admin', krb5_password, '', 'EXAMPLE.COM')


def test_admin_login_fails_when_we_dont_know_the_password():
    krb5_password = 'we-dont-know-the-password'

    with pytest.raises(kerberos.BasicAuthError) as e:
        kerberos.checkPassword('admin/admin', krb5_password, '', 'EXAMPLE.COM')
    error_message = e.value.args[0]

    assert 'Preauthentication failed' in error_message
