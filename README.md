# A Wrapper Repo for the zlog Project

This repository solely serves as a wrapper for the zlog project to create a deb package from the latest release.

Unfortunately, this is necessary because LGPL (under which is zlog is published) does not allow static linking.

- To compile the zlog project simply type `make`.
- To generate the deb packages simply type `make dpkg`.
