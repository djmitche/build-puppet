# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

add_phase check_os
check_os() {
    if ! grep -q 'CentOS' /etc/issue; then
        echo "masterize.sh only works on CentOS"
        return 1
    fi
}

add_phase setup_hostname
setup_hostname() {
    local myhostname=`hostname -s`
    local myfqdn=`hostname`
    if [ "$myhostname" == "$myfqdn" ]; then
        echo "This host doesn't have a fqdn set. That will break ssl stuff. Please run \`hostname <fqdn>\` and run this script again."
        return 1
    fi

    # fix the hostname in /etc/sysconfig/network
    if ! grep -q $myfqdn /etc/sysconfig/network; then
        sed -i "s/^HOSTNAME=.*/HOSTNAME=$myfqdn/" /etc/sysconfig/network
    fi
}

add_phase setup_clock
setup_clock() {
    /sbin/service ntpd stop || true
    /usr/sbin/ntpdate pool.ntp.org
}

add_phase setup_yum_repos
setup_yum_repos() {
    [ -f /etc/yum.repos.d/bootstrap.repo ] && return

    rm -rf /etc/yum.repos.d/*
    cat <<'EOF' >/etc/yum.repos.d/bootstrap.repo
[centos-os]
name=centos - os - $basearch
baseurl=http://puppetagain.pub.build.mozilla.org/data/repos/yum/mirrors/centos/6/latest/os/$basearch
enabled=1
gpgcheck=0

[centos-updates]
name=centos - updates - $basearch
baseurl=http://puppetagain.pub.build.mozilla.org/data/repos/yum/mirrors/centos/6/latest/updates/$basearch
enabled=1
gpgcheck=0

[puppet]
name=puppet
baseurl=http://puppetagain.pub.build.mozilla.org/data/repos/yum/mirrors/puppetlabs/el/6/products/$basearch
enabled=1
gpgcheck=0

[puppet-deps]
name=puppet
baseurl=http://puppetagain.pub.build.mozilla.org/data/repos/yum/mirrors/puppetlabs/el/6/dependencies/$basearch
enabled=1
gpgcheck=0
EOF
    /usr/bin/yum clean all
}

SSH_PRIVATE_KEY="/root/puppetsync"
SSH_PUBLIC_KEY="${SSH_PUBLIC_KEY}.pub"
add_phase setup_ssh_keys
setup_ssh_keys() {
    [ -f "${SSH_PRIVATE_KEY}" ] && return
    ssh-keygen -f "${SSH_PRIVATE_KEY}" -N ''
}

add_phase setup_secrets
setup_secrets() {
    local secrets_file="$PWD/manifests/extlookup/secrets.csv"
    [ -f "${secrets_file}" ] && return
    echo "'${secrets_file}' does not exist.  Please copy it from secrets-template.csv and"
    echo "fill in the required values, at least:"
    echo " root_pw_hash"
    echo " puppetsync_pubkey"
    echo "   (from ${SSH_PUBLIC_KEY})"
    echo " puppetmaster_deploy_htpasswd"
    return 1
}

add_phase setup_config
setup_config() {
    local config_link="$PWD/manifests/config.pp"
    local nodes_link="$PWD/manifests/nodes.pp"
    ok=true
    if [ -f "${config_link}" ]; then
        echo "config:" `readlink "${config_link}"`
    else
        ok=false
    fi
    if [ -f "${nodes_link}" ]; then
        echo "nodes:" `readlink "${nodes_link}"`
    else
        ok=false
    fi
    if ! $ok; then
        echo "One or both of '${config_link}' or '${nodes_link}' do not exist.  Link them to the"
        echo "appropriate config and nodes for this org, e.g."
        echo " (cd $PWD/manifests; ln -s myorg-config.pp config.pp)"
        echo " (cd $PWD/manifests; ln -s myorg-nodes nodes.pp)"
        return 1
    fi
}
