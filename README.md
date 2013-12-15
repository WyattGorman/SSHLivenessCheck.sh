SSHLivenessCheck.sh
===================

Simple SSH-driven multi-host liveness check.

Usage: ./SSHLivenessCheck.sh [user@example.com | emails_file] [user@host | host_file]

Script takes a single email address or a file of email addresses to send alert emails to,
and a single host argument formatted as "user@host challenge response [ssh options]" or a
file of the hosts to check with the challenge commands and expected responses to confirm identity.

Script SSHes into the host(s) (assuming no password required), and runs the
challenge command. If the response is not the same as the expected response it sends an email
reporting the host is down to the specified email address(es).
