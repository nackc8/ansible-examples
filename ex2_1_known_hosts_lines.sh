#!/bin/bash

##
## This script explorws how ssh-keyscan works and its relation to known_hosts.
##

# Get the IP address of the current machine, ex 192.168.0.169. This is just for
# this example. In an Ansible playbook you'll get the IP by other means.
IP="$(ip route get 8.8.8.8 | grep -oP '(?<=src )[^ ]+')"

# ssh-keyscan is a utility which can be used to get fingerprint lines to put
# in the known_hosts file. We can try it out by running it on the current
# machine's IP address. The output will be a line that we can add to the
# known_hosts file. This is useful for adding the current machine to the
# known_hosts file of another machine.
#
# See: run 'man ssh-keyscan" on the Bash command line
ssh-keyscan "$IP"

# This is an example output:
#
#   # 192.168.0.169:22 SSH-2.0-OpenSSH_8.9p1 Ubuntu-3ubuntu0.6
#   192.168.0.169 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBLYQo2QVocbgtVa3EAEXc30ChUraDPCOfndCR2bycF7SWZtf2eui6r6TYzFavulR35TdEQ8wEbmkkXQmi/jEUr8=
#   # 192.168.0.169:22 SSH-2.0-OpenSSH_8.9p1 Ubuntu-3ubuntu0.6
#   # 192.168.0.169:22 SSH-2.0-OpenSSH_8.9p1 Ubuntu-3ubuntu0.6
#   192.168.0.169 ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCuERkDeaSJ1mhOnpXKmpG2DqicuGq6If/ws+yBN5EY8IVzMaQbgPQfMHl4giJu3oCykP0o7c/3ddrofPZ9hNR/cjCh4W/8Xo7kW+imHp6i2PZZ3shTJ+FdgessUVED+J4mFSkuK3zSKqQEXdAcyBEzf8LyBcRA3E+AJ2y19uw5aln2NvXTuRRjQKvwp0zToT0ciolkIwwDTk4DQlsi2odGk9rBsQsY08LpU3PyCGe5MmTegmn6p0M05DRqM9hflMvR3Hpg++URMYMeA8JRGvfMREzsR4Wu0ypbpZUthZ28eo54CI2aXYYZV/oeaOZ1FdfIi84+CRyk7avkv5lYxox6JKK0QXNF9K+mHZMZVwgd5fu6dbPXS84B9p9cVRUs36lz7M6c+camked2X8nNH4/OJb0LX1NE0gtLB1e2hz8OrxkGDQu/kLx5ZU8w9S8D3dQTix93mRuwz+ACSIEqQRq8A8cbztAsN2cgrpZ7XUh/vKA/QjJNnlzCtM6qZv6Pykk=
#   # 192.168.0.169:22 SSH-2.0-OpenSSH_8.9p1 Ubuntu-3ubuntu0.6
#   192.168.0.169 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKDXumSvQ9/K8zpB16GdurypmI07Btd8jDAN1v6EYe/h
#   # 192.168.0.169:22 SSH-2.0-OpenSSH_8.9p1 Ubuntu-3ubuntu0.6
#
# Phew! That is a lot of lines! The lines beginning with # 192.168 are merly
# comments. The other lines are the actual fingerprint lines. We can get rid of
# the comments as they are directed to stderr, we'll redirect it to null
ssh-keyscan "$IP" 2>/dev/null

# This is an example output:
#
#   192.168.0.169 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBLYQo2QVocbgtVa3EAEXc30ChUraDPCOfndCR2bycF7SWZtf2eui6r6TYzFavulR35TdEQ8wEbmkkXQmi/jEUr8=
#   192.168.0.169 ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCuERkDeaSJ1mhOnpXKmpG2DqicuGq6If/ws+yBN5EY8IVzMaQbgPQfMHl4giJu3oCykP0o7c/3ddrofPZ9hNR/cjCh4W/8Xo7kW+imHp6i2PZZ3shTJ+FdgessUVED+J4mFSkuK3zSKqQEXdAcyBEzf8LyBcRA3E+AJ2y19uw5aln2NvXTuRRjQKvwp0zToT0ciolkIwwDTk4DQlsi2odGk9rBsQsY08LpU3PyCGe5MmTegmn6p0M05DRqM9hflMvR3Hpg++URMYMeA8JRGvfMREzsR4Wu0ypbpZUthZ28eo54CI2aXYYZV/oeaOZ1FdfIi84+CRyk7avkv5lYxox6JKK0QXNF9K+mHZMZVwgd5fu6dbPXS84B9p9cVRUs36lz7M6c+camked2X8nNH4/OJb0LX1NE0gtLB1e2hz8OrxkGDQu/kLx5ZU8w9S8D3dQTix93mRuwz+ACSIEqQRq8A8cbztAsN2cgrpZ7XUh/vKA/QjJNnlzCtM6qZv6Pykk=
#   192.168.0.169 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKDXumSvQ9/K8zpB16GdurypmI07Btd8jDAN1v6EYe/h
#
# This is much better! One thing to note is that there are three fingerprints
# for the same IP address. This is because the machine has three different
# keys. If we add these lines to the known_hosts file of another machine, then
# that machine will trust the current machine.

# One last thing to note though is that the lines above show the IPs and the
# encryption algorithms. This is not necessary and not recommended for security
# reasons. We can remove the IPs and the encryption algorithms by telling
# ssh-keyscan to "hash' the output. This is done by using the -H option.
ssh-keyscan -H "$IP" 2>/dev/null

# This is an example output:
#
#   |1|HKoYsosp4/wOrWrhGI0/N/PRSTE=|RWaycOMA+XW9i2yBS7zPoNaLE8w= ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBLYQo2QVocbgtVa3EAEXc30ChUraDPCOfndCR2bycF7SWZtf2eui6r6TYzFavulR35TdEQ8wEbmkkXQmi/jEUr8=
#   |1|PtkecjXduKhpevh1dRwvxsX+8+M=|lWKNCwkbXyTfu5GLR8SB25WcNtI= ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCuERkDeaSJ1mhOnpXKmpG2DqicuGq6If/ws+yBN5EY8IVzMaQbgPQfMHl4giJu3oCykP0o7c/3ddrofPZ9hNR/cjCh4W/8Xo7kW+imHp6i2PZZ3shTJ+FdgessUVED+J4mFSkuK3zSKqQEXdAcyBEzf8LyBcRA3E+AJ2y19uw5aln2NvXTuRRjQKvwp0zToT0ciolkIwwDTk4DQlsi2odGk9rBsQsY08LpU3PyCGe5MmTegmn6p0M05DRqM9hflMvR3Hpg++URMYMeA8JRGvfMREzsR4Wu0ypbpZUthZ28eo54CI2aXYYZV/oeaOZ1FdfIi84+CRyk7avkv5lYxox6JKK0QXNF9K+mHZMZVwgd5fu6dbPXS84B9p9cVRUs36lz7M6c+camked2X8nNH4/OJb0LX1NE0gtLB1e2hz8OrxkGDQu/kLx5ZU8w9S8D3dQTix93mRuwz+ACSIEqQRq8A8cbztAsN2cgrpZ7XUh/vKA/QjJNnlzCtM6qZv6Pykk=
#   |1|Th5mtZEBJR+WJrxErFvqN4sqo/c=|e3aLrpcAVup40iPiIiALpExxRJs= ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKDXumSvQ9/K8zpB16GdurypmI07Btd8jDAN1v6EYe/h
#
# This is much better! The IPs and the encryption algorithms are now hashed.
# This is the output that we can add to the known_hosts file of another
# machine.
#
# In our Ansible playbook we'll run the above command and add the output made to
# standard output as a host fact. This will allow us to add the current machine
# to the known_hosts file of another machine.
