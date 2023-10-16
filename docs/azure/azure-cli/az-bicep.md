# az bicep

## Commands

| Name | Description |
| :--- | :--- |
| [az bicep install](#az-bicep-install) | Install Bicep CLI. |
| [az bicep upgrade](#az-bicep-upgrade) | Upgrade Bicep CLI to the latest version. |
| [az bicep build](#az-bicep-build) | Build a Bicep file. |
| [az bicep build-params](#az-bicep-build-params) | Build .bicepparam file. |
| [az bicep decompile](#az-bicep-decompile) | Attempt to decompile an ARM template file to a Bicep file. |
| [az bicep decompile-params](#az-bicep-decompile-params) | Decompile a parameters .json file to .bicepparam. |
| [az bicep format](#az-bicep-format) |	Format a Bicep file. |
| [az bicep generate-params](#az-bicep-generate-params) | Generate parameters file for a Bicep file. |

## az bicep install

Install Bicep CLI.

```bash
az bicep install
```

## az bicep build

Build a Bicep file.

```bash
az bicep build --file {bicep_file}
```

Build a Bicep file and print all output to stdout.

```bash
az bicep build --file {bicep_file}
```

### Global Parameters

**--debug**
Increase logging verbosity to show all debug logs.

**--only-show-errors**
Only show errors, suppressing warnings.

**--verbose**
Increase logging verbosity. Use --debug for full debug logs.

## az bicep build-params

Build a .bicepparam file.

```bash
az bicep build-params --file {bicepparam_file}
```

Build a .bicepparam file and print all output to stdout.

```bash
az bicep build-params --file {bicepparam_file} --stdout
```

## az bicep decompile

Decompile an ARM template file.

```bash
az bicep decompile --file {json_template_file}
```

Decompile an ARM template file and overwrite existing Bicep file.

```bash
az bicep decompile --file {json_template_file} --force
```

## az bicep decompile-params

Attempts to decompile a parameters .json file to .bicepparam.

```bash
az bicep decompile-params --file {json_template_file}
```

Attempts to decompile a parameters .json file to .bicepparam and print all output to stdout.

```bash
az bicep decompile-params --file {json_template_file} --stdout
```

## az bicep format

Format a Bicep file.

```bash
az bicep format --file {bicep_file}
```

Format a Bicep file and print all output to stdout.

```bash
az bicep format --file {bicep_file} --stdout
```

## Generate parameters file for a Bicep file.

Generate parameters file for a Bicep file.

```bash
az bicep generate-params --file {bicep_file}
```

Generate parameters file for a Bicep file and print all output to stdout.

```bash
az bicep generate-params --file {bicep_file} --stdout
```

