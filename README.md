# NRT Wizard

NRT Wizard is a toolset for easily creating NRT instances comprising
of separate components. The tools provided can be used to select
components, configure them and control what version of the NRT codebase
is used.

## Setup

NRT Wizard should generally be installed and setup automatically, for
example in Docker or by a provisioning script.

```bash
npm install -g nrt-wizard
```

In development, instead clone this repo and run:

```bash
npm install -g
```

## Usage

To create an NRT instance:

```bash
nrt create-instance ./target_dir
```

## Components

An NRT instance consists of several components running individually. During
setup, NRT Wizard will download the selected components and install them
automatically.

### Installation

Components are responsible for specifying how they are installed for each
platform. A general good practice is combining these dependencies in to a
script that installs the requirements in a platform-dependent script file, such
as a `.bat` or `.sh`.

Add a `setup` attribute to `scripts` in your package.json. The attribute
should define a command to run for each platform when NRT Wizard clones the
repository, for example:

```json
{
  "scripts": {
    "setup": {
      "osx": "coffee bin/setup.coffee",
      "win": "cmd.exe \c coffee bin/setup.coffee",
      "unix": "/bin/sh ./install.sh"
  }
}
```
