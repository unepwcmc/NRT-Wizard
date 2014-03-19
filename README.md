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

## Usage

To create an NRT instance:

```bash
nrt create-instance ./target_dir
```

## Components

An NRT instance consists of several components running individually. During
setup, NRT Wizard will download the selected components and install them
automatically.
