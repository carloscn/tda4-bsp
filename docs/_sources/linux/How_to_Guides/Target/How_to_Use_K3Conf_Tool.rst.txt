.. include:: /_replacevars.rst

How to Use K3Conf Tool
================================

Overview
--------

k3conf is standalone application designed to provide a quick and easy way to
diagnose/debug/audit TI K3 architecture based processors configuration at
runtime, with no particular kernel dependency.

k3conf is designed to be as much platform-agnostic as possible, being able to
run on any Linux platform and easily ported to other OS.
Even if k3conf today focuses mainly on TISCI related functionality, it is
intended to be extended to any other area.


How to use
---------------------

k3conf is part of yocto build and SDK installer.
On target user needs to use command "k3conf".

Type "k3conf --help" to get complete list of available commands and options.


.. note::

  K3CONF currently supports AM654, J721E, J7200, AM64x, AM62x, J721S2, J784S4 and
  AM62Ax Devices.

Source code for k3conf tool can be accessed from
https://git.ti.com/cgit/k3conf/k3conf/ git repo.
