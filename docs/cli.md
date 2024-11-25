# CLI Commands and Flags

Codegate provides a command-line interface through `cli.py` with the following
structure:

## Main Command

```bash
codegate [OPTIONS] COMMAND [ARGS]...
```

## Available Commands

### serve

Start the Codegate server:

```bash
codegate serve [OPTIONS]
```

#### Options

- `--port INTEGER`: Port to listen on (default: 8989)
  - Must be between 1 and 65535
  - Overrides configuration file and environment variables
  
- `--host TEXT`: Host to bind to (default: localhost)
  - Overrides configuration file and environment variables
  
- `--log-level [ERROR|WARNING|INFO|DEBUG]`: Set the log level (default: INFO)
  - Case-insensitive
  - Overrides configuration file and environment variables
  
- `--log-format [JSON|TEXT]`: Set the log format (default: JSON)
  - Case-insensitive
  - Overrides configuration file and environment variables
  
- `--config FILE`: Path to YAML config file
  - Optional
  - Must be a valid YAML file
  - Configuration values can be overridden by environment variables and CLI options

- `--prompts FILE`: Path to YAML prompts file
  - Optional
  - Must be a valid YAML file
  - Overrides default prompts and configuration file prompts

### show-prompts

Display the loaded system prompts:

```bash
codegate show-prompts [OPTIONS]
```

#### Options

- `--prompts FILE`: Path to YAML prompts file
  - Optional
  - Must be a valid YAML file
  - If not provided, shows default prompts from prompts/default.yaml

## Error Handling

The CLI provides user-friendly error messages for:
- Invalid port numbers
- Invalid log levels
- Invalid log formats
- Configuration file errors
- Prompts file errors
- Server startup failures

All errors are output to stderr with appropriate exit codes.

## Examples

Start server with default settings:
```bash
codegate serve
```

Start server on specific port and host:
```bash
codegate serve --port 8989 --host localhost
```

Start server with custom logging:
```bash
codegate serve --log-level DEBUG --log-format TEXT
```

Start server with configuration file:
```bash
codegate serve --config my-config.yaml
```

Start server with custom prompts:
```bash
codegate serve --prompts my-prompts.yaml
```

Show default system prompts:
```bash
codegate show-prompts
```

Show prompts from a custom file:
```bash
codegate show-prompts --prompts my-prompts.yaml