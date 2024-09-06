.. include:: /_replacevars.rst

SDK File System Optimization/Customization
==========================================

.. rubric:: Purpose
   :name: rootfs-optimization-purpose

.. ifconfig:: CONFIG_sdk in ('PLSDK')

    The purpose of this article is to explain the file systems that are
    delivered as part of the Processor SDK Linux and how those file systems
    can be modified to customize them for your use case. The tools discussed
    in this article are installed by default in the Processor SDK Linux file
    system for your convenience.

.. ifconfig:: CONFIG_sdk in ('PSDKL','j7_foundational')

    The purpose of this article is to explain the file system that is
    delivered as part of the |__SDK_FULL_NAME__| and how this file system
    can be modified to customize it for your use case. The tools discussed
    in this article are installed by default in the |__SDK_FULL_NAME__| file
    system for your convenience.

|

.. rubric:: Pre-built File Systems
   :name: pre-built-file-systems

.. ifconfig:: CONFIG_sdk in ('PLSDK')

    The Processor SDK Linux ships with two default file systems. They are:

    #. tisdk-base-image-<machine>.tar.gz - This file system is the simple file
       system that forms the base of the SDK file system. It has some basic
       utilities installed but is intended to be rather small and light
       weight.
    #. tisdk-default-image-<machine>.tar.gz - This file system is created by taking
       the base file system and adding all the additional SDK components
       such as 3D graphics, matrix, profiling tools, etc. It is a larger
       file system but is meant to have most of the tools developers would
       need when working with TI processors.

    Both of these file systems contain the **opkg** package manager and can
    be used as a starting point for system optimization as discussed in the
    next sections.

.. ifconfig:: CONFIG_sdk in ('PSDKL','j7_foundational')

    The |__SDK_FULL_NAME__| ships with a default file system:

    #. tisdk-default-image-<machine>.tar.gz - This file system is created by taking
       a base file system and adding all the additional SDK components
       such as 3D graphics, matrix, profiling tools, etc. It is somewhat larger than
       a base file system, but is meant to have most of the tools developers would
       need when working with TI processors.

    This file system contains the **opkg** package manager and can
    be used as a starting point for system optimization as discussed in the
    next sections.

|

.. rubric:: The Basics of OPKG
   :name: the-basics-of-opkg

.. rubric:: opkg - list commands
   :name: opkg---list-commands

**opkg** is the package manager used in the SDK file system to install
and remove packages. You can get a list of the full commands supported
by **opkg** by running the following command on the target device:

::

    target# opkg

.. rubric:: opkg - list installed packages
   :name: opkg---list-installed-packages

To the list of packages are part of the file system and the version of
each package you can run the following command on the target device:

::

    target# opkg list-installed

.. note::

 This list only contains information about packages that were
 installed using the package manager. Applications that were built and
 copied to the file system and not installed as a .ipk package are not
 tracked by **opkg**

.. rubric:: opkg - list package contents
   :name: opkg---list-package-contents

Sometimes it is useful to know what files a package has installed. To do
this you can use the following command:

::

    target# opkg files <pkgname>

Where <pkgname> is the name of the package as given in the *opkg
list-installed* output. This command will produce a list of all the
files on the file system that belong to the given package.

.. rubric:: opkg - find a file owner
   :name: opkg---find-a-file-owner

Sometimes you may find a file on the target file system that you want to
remove, or just know where it came from. In this case you can use the
following command:

::

    target# opkg search <file>

This command will find which package installed the given file. This may
be useful later when you want to remove an particular file because this
command can help you find the package to remove.

.. rubric:: opkg - finding dependencies
   :name: opkg---finding-dependencies

Sometimes when you want to remove a package it is useful to find out
what other packages depend on the package you are removing. While the
opkg remove command will tell you the immediate dependencies you can
find the longer list of dependencies using:

::

    target# opkg whatdepends <pkgname>

This command will print the list of packages the depend on the package
you entered, as well as the packages that depend on those packages, and
so forth.

.. rubric:: Removing Packages
   :name: removing-packages

One of the simplest ways to modify the contents of the file system is to
use the **opkg** utility to remove packages (or install if you have
pre-built packages). Removing a package is often as simple as:

::

    target# opkg remove <pkgname>

However, sometimes a package is a DEPENDENCY of another package. In this
case you have the following options:

-  Use the --force-depends option

   -  This option will force the removal of the package but will leave
      any packages that depend on this package installed. This can be
      useful in the case that you want to remove a particular package,
      but that package is depended on by some other package that you do
      not want removed.

-  Use the --force-removal-of-dependent-packages option

   -  This option will go up the dependency list and remove all packages
      in the dependency chain. You should check all the packages being
      removed to make sure they are indeed packages you want to remove
      and do not contain other files you want.

-  Remove the individual packages that depend on this package first

   -  This way you can control exactly which dependent packages are
      removed and which are left in place.

::

    target# opkg remove --force-removal-of-dependent-packages <pkgname>

.. note::

 opkg will print the packages that depend on the package being
 removed. It is usually a good idea to use the *opkg files* command for
 the packages that depend on the one being removed so that you can make
 sure that no files you really want to keep are going to be removed.

.. note::
 You can also use the whatdepends option discussed above to see
 the dependency list for a package

By using the *opkg remove* command in conjunction with the commands for
listing packages, finding file owners, and listing package contents, you
can quickly strip down a full file system into something smaller and
more optimized for your use case. However, once a package is removed it
cannot currently be re-installed without generating the .ipk file to
install it.

.. rubric:: Adding Applications
   :name: adding-applications

In most cases installing additional applications can be as simple as
copying the the binary executable to the file system. However, if you
have built your own .ipk packages you can use opkg to install those ipks
into the target file system. One major advantage of using the package
manager is the ability to track the package and it's content with the
opkg package manager. More details will be coming about how to build
your own packages, but for now please refer to `Building the
SDK <../../Overview_Building_the_SDK.html>`__ .

To learn about Arago project, please refer `this
link <https://git.yoctoproject.org/meta-arago>`__.
