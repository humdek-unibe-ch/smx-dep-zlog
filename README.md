# A Wrapper Repo for the zlog Project

This is one of the core dependencies for all Streamix C libraries which build
up a Streamix app.

This repository solely serves as a wrapper for the zlog project to create a deb
package from the latest release.

Note that the library was slightly altered to avoid priority inversion
problems. The changes only concern the runtime part of zlog but not the
initialisation part as zlog is initialised in the main thread of Streamix.

To compile the zlog project simply type `make`.
