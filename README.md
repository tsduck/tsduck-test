## TSDuck Test Suite

### TSDuck tests

The code of TSDuck is mainly divided in two parts, a large C++ library (`tsduck.dll` or `tsduck.so`)
and a collection of small command line tools and plugins.

Similarly, the tests for TSDuck are divided in two parts.

- The TSDuck library has its own unitary test suite based on CppUnit. This test suite is part of
  the [main tsduck](https://github.com/tsduck/tsduck) repository for TSDuck in directory `src/utest`.
  This test suite is fully automated. The `utest` executable is built twice, once using the shared
  library and once using the static library. Both versions of the test suite are built and run using
  `make test`.
- The tools and plugins are less easy to test. They work on large transport stream files which
  would clutter the tsduck repository. The repository `tsduck-test` contains those tests and
  the relevant scripts and data files.

### Large files

This repository contains large files, typically transport stream files.

Initially, these files were not stored inside the regular GitHub repository.
Instead, they used the "[Git Large File Storage](https://git-lfs.github.com)" (LFS) feature of GitHub.
However, using LFS on GitHub happended to be a pain, as experienced by others and explained in
[this article](https://medium.com/@megastep/github-s-large-file-storage-is-no-panacea-for-open-source-quite-the-opposite-12c0e16a9a91).

As a consequence, the transport stream files were re-integrated into the Git
repository. But we know limit their size to 20 MB.

### Structure of test suite

In short, execute the script `run-all-tests.sh` to run the complete test suite.

The repository contains the following subdirectories:

- `tests` : Contains one script per test or set of tests. Each test script can be
  executed individually. All tests are executed using the script `run-all-tests.sh`.

- `common` : Contains utilities and common script.

- `input` : Contains input data files for the tests.

- `reference` : Contains reference output files for the various tests.

- `tmp` : Contains output files which are created by the execution of the tests.
  These files are typically compared against reference output files in `reference`.
  These files are temporary by definition. The subdirectory `tmp` is present on
  test machines only and is excluded from the Git repository.

### Adding new tests

To add a new test:

- Add input files in subdirectory `input`.

- Create the script `test-NNN.sh` in subdirectory `tests`. Use other existing
  test scripts as templates.

- Run the command `tests/test-NNN.sh --init`. If the test is properly written,
  this creates the reference output files in subdirectory `reference`. Manually
  check the created files, verify that they are correct. Be careful with this
  step since these files will be used as references.

- Run the same command without the `--init` option. This time, the output files
  are created in `tmp` and are compared with files in `reference`. Verify that
  all tests pass. Errors may appear if the test script is not properly written
  or if the output files contain unique, non-deterministic, time-dependent,
  system-dependent or file-system-dependent information. Make sure the output
  files are totally reproduceable in all environments. At worst, add code in
  the test script to remove any information from the output files which is
  known to be non-reproduceable.

Sometimes, TSDuck is modified in such in a way that an output file is modified
on purpose. Usually, this starts with a failed test. When analysing the test
failure, it appears that the modification of the output is intentional. In that
case, re-run the command `tests/test-NNN.sh --init` to update the reference
output files. Do not forget to manually validate them since they will act as
the new reference.
