# NRT Instance

NRT Instance is a toolset for easily creating NRT instances comprising
of separate modules. The tools provided can be used to select modules,
configure them and control what versions of the NRT codebase are used.

## Setup

NRT Instance should generally be installed and setup automatically, for
example in Docker or by a provisioning script.

```bash
npm install
```

## Modules

An NRT instance consists of several modules running individually. During
setup, NRT Instance will download the selected modules and install them
automatically.

To do this, modules must define how they are set up.

### package.json

Add a `setup` attribute to `scripts` in your package.json. The attribute
should define a command to run when NRT Instance clones the repository,
for example:

```json
{
  "scripts": {
    "setup": "coffee bin/setup.coffee"
  }
}
```
